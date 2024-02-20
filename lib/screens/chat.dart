import 'package:chat_app/cubits/messages/messagecubit.dart';
import 'package:chat_app/cubits/messages/messagestate.dart';
import 'package:chat_app/models/chat.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/repository/hiverepository.dart';
import 'package:chat_app/widgets/profilemini.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.chatId});

  final String chatId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late Chat? chat;

  late AppUser? otherUser;

  @override
  void initState() {
    //Obtener el chat a partir del id
    chat = HiveRepository().getChatById(widget.chatId);

    if (chat == null) {
      //Si el chat es null, mostrar un error
      return;
    }

    //Obtener el usuario con el id del chat
    otherUser = HiveRepository().getUserById(chat!.otherUserId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ProfileThumbnail(user: otherUser!),
      ),
      body: BlocBuilder<MessageCubit, MessageState>(
        builder: (context, state) {
          if (state is MessagesLoading) {
            //TODO: Mientras carga tiene que mostrar los que estan en HIVE
            //Y mostrar algun icono de carga debajo
            return const Center(child: CircularProgressIndicator());
          } else if (state is MessagesLoaded) {
            return ListView.builder(
              itemCount: state.messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(state.messages[index].text),
                );
              },
            );
          } else {
            return const Center(child: Text('Error'));
          }
        },
      ),
    );
  }
}
