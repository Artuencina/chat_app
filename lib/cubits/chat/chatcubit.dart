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
      emit(ChatsLoading(chats: localChats));
    }

    final currentUserId = await hiveRepository.getCurrentUserId();

    if (currentUserId == null) {
      emit(ChatsLoaded(chats: localChats));
      return;
    }

    //Vamos a traer los chats de firebase y actualizar los chats de hive si hay diferencia
    final firebaseChats = await firestoreRepository.getChats(currentUserId);

    //Si no hay chats en firebase, no hacemos nada
    if (firebaseChats.isEmpty) {
      emit(const ChatsEmpty(chats: []));
      return;
    }

    //Si hay chats en firebase, los comparamos con los de hive
    //Si hay diferencia, actualizamos los chats de hive
    if (localChats.isEmpty) {
      //Si no hay chats en hive, guardamos los chats de firebase
      for (var chat in firebaseChats) {
        await hiveRepository.saveChat(chat);
      }
    } else {
      //Si hay chats en hive, comparamos con los de firebase
      for (var chat in firebaseChats) {
        final hiveChat = localChats.firstWhere((c) => c.id == chat.id,
            orElse: () => Chat.empty());
        if (hiveChat.isEmpty()) {
          //Si el chat no existe en hive, lo guardamos
          await hiveRepository.saveChat(chat);
        }
        //Si el chat existe en hive, comparamos el ultimo mensaje
        if (chat.lastMessage != hiveChat.lastMessage) {
          //Si el ultimo mensaje es diferente, actualizamos el chat
          await hiveRepository.updateChat(chat);
        }
      }
    }

    //Obtener los chats actualizados
    emit(ChatsLoaded(chats: await hiveRepository.getChats()));
  }

  //Metodo para actualizar la lista de chats cuando se recibe un nuevo mensaje
  //Aumenta el contador de mensajes no leidos
  //Se cambia el mensaje y la fecha del ultimo mensaje
  //Se mueve el chat al inicio de la lista
  Future<void> updateChat(Chat chat, Message message) async {
    chat.lastMessage = message.text;
    chat.lastMessageTime = message.time;
    chat.unreadMessages++;
    await hiveRepository.updateChat(chat);
    await firestoreRepository.updateChatLastMessage(message);
    emit(ChatsLoaded(chats: state.chats));
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
    emit(ChatsLoaded(chats: state.chats));

    //Agregar chat a firebase
    await firestoreRepository.createChat(chat);
  }
}
