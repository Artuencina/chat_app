import 'package:chat_app/cubits/user/usercubit.dart';
import 'package:chat_app/models/chat.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/repository/hiverepository.dart';
import 'package:chat_app/widgets/chatbubble.dart';
import 'package:chat_app/widgets/newmessage.dart';
import 'package:chat_app/widgets/profilemini.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  late String? userId;

  String lastUserMessageId = '';

  @override
  void initState() {
    //Obtener el chat a partir del id
    chat = HiveRepository().getChatById(widget.chatId);

    //Obtener el userId del estado del UserCubit
    userId = chat!.userId;

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
          centerTitle: true,
          title: otherUser == null ? const Text('Chat') : Text(otherUser!.name),
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            ProfileThumbnail(user: otherUser!),
            const SizedBox(
              width: 15,
            )
          ],
        ),
        //Streambuilder de firebase para mostrar los mensajes
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('chats')
              .doc(chat!.id)
              .collection('messages')
              .orderBy('time', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            List<QueryDocumentSnapshot> messages = [];

            if (snapshot.data != null) {
              messages = snapshot.data!.docs;
            }

            return Column(
              children: [
                Expanded(
                    child: snapshot.connectionState != ConnectionState.waiting
                        ? ListView.builder(
                            reverse: true,
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final message = Message.fromMap(messages[index]
                                  .data() as Map<String, dynamic>);
                              final continueChat =
                                  lastUserMessageId == message.senderId;
                              lastUserMessageId = message.senderId;

                              return ChatBubble(
                                message: message,
                                isMine: message.senderId == userId,
                                continueChat: continueChat,
                              );
                            })
                        : const SizedBox()),
                if (snapshot.connectionState == ConnectionState.waiting)
                  const LinearProgressIndicator(),
                NewMessageField(chat: chat!),
              ],
            );
          },
        ));
  }
}
