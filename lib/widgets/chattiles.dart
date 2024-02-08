//Tile de un chat con un usuario
import 'package:chat_app/chats.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chats extends StatelessWidget {
  const Chats({super.key});

  static DateFormat dateFormat = DateFormat('HH:mm');

  @override
  Widget build(BuildContext context) {
    //Obtener chats del usuario 0
    final chats = getChats(0);

    return ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(chats[index].user.imageUrl),
            ),
            title: Text(chats[index].otherUser.name,
                style: Theme.of(context).textTheme.titleLarge),
            subtitle: Text(chats[index].lastMessage,
                style: Theme.of(context).textTheme.bodySmall),
            trailing: Text(dateFormat.format(chats[index].lastMessageTime!),
                style: Theme.of(context).textTheme.bodySmall),
          );
        });
  }
}
