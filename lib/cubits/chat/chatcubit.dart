//Cubit para chats
import 'package:chat_app/cubits/chat/chatstate.dart';
import 'package:chat_app/models/chat.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/repository/hiverepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatCubit extends Cubit<ChatsState> {
  final HiveRepository hiveRepository;

  ChatCubit({required this.hiveRepository}) : super(ChatsInitial());

  //Metodo para cargar los chats
  Future<void> loadChats() async {
    //emit(ChatsLoading());

    //Obtener los chats de firebase
    final chats = await hiveRepository.getChats();

    if (chats.isEmpty) {
      emit(ChatsEmpty());
    } else {
      emit(ChatsLoaded(chats: chats));
    }
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
    loadChats();
  }

  //Metodo para guardar un chat
  Future<void> saveChat(Chat chat) async {
    await hiveRepository.saveChat(chat);
    loadChats();
  }
}
