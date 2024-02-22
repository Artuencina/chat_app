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
        //Loading muestra los chats locales y un icono arriba
        //indicandoq ue esta cargando los chats de firebase
        if (state is ChatsLoading) {
          return Column(
            children: [
              const LinearProgressIndicator(),
              Expanded(
                child: ListView.builder(
                  itemCount: state.chats.length,
                  itemBuilder: (context, index) {
                    final Chat chat = state.chats[index];
                    final AppUser? otherUser =
                        HiveRepository().getUserById(chat.otherUserId);
                    return Column(
                      children: [
                        ListTile(
                          leading: ProfileThumbnail(
                            user: otherUser!,
                          ),
                          title: Text(
                            otherUser.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          subtitle: Text(
                            chat.lastMessage,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          trailing: Text(
                            chat.lastMessageTime == null
                                ? ''
                                : dateFormat.format(chat.lastMessageTime!),
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
                ),
              ),
            ],
          );
        } else if (state is ChatsLoaded) {
          return ListView.builder(
            itemCount: state.chats.length,
            itemBuilder: (context, index) {
              final Chat chat = state.chats[index];

              final AppUser? otherUser =
                  HiveRepository().getUserById(chat.otherUserId);

              return Column(
                children: [
                  ListTile(
                    leading: otherUser == null
                        ? const Icon(Icons.person)
                        : ProfileThumbnail(
                            user: otherUser,
                          ),
                    title: Text(
                      otherUser == null ? '' : otherUser.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      chat.lastMessage,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          chat.lastMessageTime == null
                              ? ''
                              : dateFormat.format(chat.lastMessageTime!),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        if (chat.unreadMessages > 0)
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(chat.unreadMessages.toString(),
                                style: Theme.of(context).textTheme.bodySmall),
                          ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        '/chat/${chat.id}',
                      );
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
        } else if (state is ChatsInitial) {
          return const Center(
            child: CircularProgressIndicator(),
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
