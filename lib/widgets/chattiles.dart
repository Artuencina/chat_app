//Tile de un chat con un usuario

import 'package:chat_app/cubits/chat/chatcubit.dart';
import 'package:chat_app/cubits/chat/chatstate.dart';
import 'package:chat_app/models/chat.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/repository/hiverepository.dart';
import 'package:chat_app/widgets/profilemini.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class Chats extends StatelessWidget {
  const Chats({super.key});

  static DateFormat dateFormat = DateFormat('HH:mm');

  @override
  Widget build(BuildContext context) {
    //Obtener chats del usuario 0

    return BlocBuilder<ChatCubit, ChatsState>(
      builder: (context, state) {
        if (state is ChatsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ChatsLoaded) {
          return ListView.builder(
            itemCount: state.chats.length,
            itemBuilder: (context, index) {
              final Chat chat = state.chats[index];

              final AppUser? user = HiveRepository().getUserById(chat.userId);
              final AppUser? otherUser =
                  HiveRepository().getUserById(chat.otherUserId);

              return Column(
                children: [
                  ListTile(
                    leading: ProfileThumbnail(
                      user: user!,
                    ),
                    title: Text(
                      otherUser!.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      chat.lastMessage,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    trailing: Text(
                      dateFormat.format(chat.lastMessageTime!),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    onTap: () {
                      //Abrir chat
                    },
                  ),
                  const Divider(
                    height: 0,
                  ),
                ],
              );
            },
          );
        } else if (state is ChatsEmpty) {
          return const Center(
            child: Text('No hay chats, empieza a chatear con tus amigos'),
          );
        } else {
          return const Center(
            child: Text('Error al cargar los chats'),
          );
        }
      },
    );
  }
}
