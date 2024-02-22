//Cubit para chats
import 'package:chat_app/cubits/chat/chatstate.dart';
import 'package:chat_app/models/chat.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/repository/firestorerepository.dart';
import 'package:chat_app/repository/hiverepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class ChatCubit extends Cubit<ChatsState> {
  final HiveRepository hiveRepository;
  final FirestoreRepository firestoreRepository;

  ChatCubit({required this.hiveRepository, required this.firestoreRepository})
      : super(const ChatsInitial(chats: []));

  //Metodo para cargar los chats
  Future<void> loadChats() async {
    //Obtener los chats de hive
    final localChats = await hiveRepository.getChats();

    if (localChats.isEmpty) {
      emit(const ChatsEmpty(chats: []));
    } else {
      //Antes de emitir el estado, vamos a obtener los usuarios de los chats
      //Para evitar errores de usuario no encontrado
      for (var chat in localChats) {
        //Preguntamos si el usuario existe dentro de hive, si no, lo traemos
        final user = hiveRepository.getUserById(chat.otherUserId);
        if (user == null) {
          final user = await firestoreRepository.getUserById(chat.otherUserId);
          if (user != null) {
            await hiveRepository.saveUser(user);
          }
        }
      }
      emit(ChatsLoading(chats: localChats));
    }

    final currentUserId = await hiveRepository.getCurrentUserId();

    if (currentUserId == null) return;

    if (await fetchChats(currentUserId, localChats)) {
      emit(ChatsLoaded(chats: await hiveRepository.getChats()));
    } else if (localChats.isEmpty) {
      emit(const ChatsEmpty(chats: []));
    } else {
      emit(ChatsLoaded(chats: localChats));
    }
  }

  //Hacer fetch de los chats que estan en firebase y actualizar la base local
  Future<bool> fetchChats(String currentUserId, List<Chat> localChats) async {
    //Vamos a traer los chats de firebase y actualizar los chats de hive si hay diferencia
    final firebaseChats = await firestoreRepository.getChats(currentUserId);

    //Si no hay chats en firebase, no hacemos nada
    if (firebaseChats.isEmpty) {
      emit(const ChatsEmpty(chats: []));
      return false;
    }

    bool hayNuevosChats = false;

    //Si hay chats en firebase, los comparamos con los de hive
    //Si hay diferencia, actualizamos los chats de hive
    if (localChats.isEmpty) {
      //Si no hay chats en hive, guardamos los chats de firebase
      for (var chat in firebaseChats) {
        await hiveRepository.saveChat(chat);

        //Tambien obtenemos el usuario del chat y lo guardamos en hive
        final otherUser =
            await firestoreRepository.getUserById(chat.otherUserId);
        if (otherUser != null) {
          await hiveRepository.saveUser(otherUser);
        }
      }
    } else {
      //Si hay chats en hive, comparamos con los de firebase
      for (var chat in firebaseChats) {
        final hiveChat = localChats.firstWhere((c) => c.id == chat.id,
            orElse: () => Chat.empty());
        if (hiveChat.isEmpty()) {
          //Si el chat no existe en hive, lo guardamos
          await hiveRepository.saveChat(chat);
          hayNuevosChats = true;
          //Tambien obtenemos el usuario del chat y lo guardamos en hive
          final otherUser =
              await firestoreRepository.getUserById(chat.otherUserId);
          if (otherUser != null) {
            await hiveRepository.saveUser(otherUser);
          }
        }
        if (chat.lastMessageTime == null) continue;
        //Si el chat existe en hive, comparamos el ultimo mensaje
        if (chat.lastMessageTime!
            .isAfter(hiveChat.lastMessageTime ?? DateTime(0))) {
          //Si el ultimo mensaje es diferente, actualizamos el chat
          hayNuevosChats = true;
          await hiveRepository.updateChat(chat);
        }
      }
    }
    return hayNuevosChats;
  }

  //Actualizar el chat de forma reiterada cuando hay un cambio en la base remota
  Future<void> checkChats() async {
    final currentUserId = await hiveRepository.getCurrentUserId();
    if (currentUserId == null) return;

    final localChats = await hiveRepository.getChats();

    if (await fetchChats(currentUserId, localChats)) {
      emit(ChatsLoaded(chats: await hiveRepository.getChats()));
    } else if (localChats.isEmpty) {
      emit(const ChatsEmpty(chats: []));
    } else {
      emit(ChatsLoaded(chats: localChats));
    }
  }

  //Metodo para actualizar la lista de chats cuando se recibe un nuevo mensaje
  //Aumenta el contador de mensajes no leidos
  //Se cambia el mensaje y la fecha del ultimo mensaje
  //Se mueve el chat al inicio de la lista
  Future<void> updateChat(Chat chat, Message message) async {
    final bool isMine = message.senderId == chat.userId;

    chat.lastMessageTime = message.time;

    //Si el mensaje es del usuario actual, no aumentamos el contador de mensajes no leidos
    if (!isMine) {
      chat.unreadMessages++;
      chat.lastMessage = message.text;
    } else {
      chat.unreadMessages = 0;
      chat.lastMessage = 'Tú: ${message.text}';
    }
    await hiveRepository.updateChat(chat);
    await firestoreRepository.updateChatLastMessage(chat);

    loadChats();
  }

  //Agregar un chat
  Future<void> addChat(String userId, String otherUserId) async {
    //id con uuId
    final chatId = const Uuid().v4();

    final chat = Chat(
      id: chatId,
      userId: userId,
      otherUserId: otherUserId,
      lastMessage: '',
      lastMessageTime: null,
      unreadMessages: 0,
    );

    //Agregar chat a hive
    await hiveRepository.saveChat(chat);

    emit(ChatsLoaded(chats: await hiveRepository.getChats()));

    //Agregar chat a firebase
    await firestoreRepository.createChat(chat);
  }
}
