//Cubit para manejar los estados de mensajes

import 'package:chat_app/cubits/messages/messagestate.dart';
import 'package:chat_app/repository/firestorerepository.dart';
import 'package:chat_app/repository/hiverepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageCubit extends Cubit<MessageState> {
  final HiveRepository hiveRepository;
  final FirestoreRepository firestoreRepository;

  MessageCubit({
    required this.hiveRepository,
    required this.firestoreRepository,
  }) : super(const MessagesLoading(
          messages: [],
        ));

  //Obtener los mensajes de un chat
  Future<void> getMessages(String chatId) async {
    //Primero se obtienen los mensajes de Hive y se emite el estado Loading
    final messages = await hiveRepository.getMessages(chatId);
    emit(MessagesLoading(messages: messages));

    //Luego se obtienen los mensajes de Firestore y actualiza tanto el estado
    //Como el box de Hive
    final newMessages = await firestoreRepository.getMessages(chatId);
    emit(MessagesLoaded(messages: newMessages));
    await hiveRepository.saveMessages(chatId, newMessages);
  }
}
