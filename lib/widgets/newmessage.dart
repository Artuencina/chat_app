//Icono de clip para adjuntar archivos
//Textfield para escribir el mensaje
//Boton para enviar el mensaje

import 'package:chat_app/cubits/chat/chatcubit.dart';
import 'package:chat_app/models/chat.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/repository/firestorerepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewMessageField extends StatefulWidget {
  const NewMessageField({super.key, required this.chat});

  final Chat chat;

  @override
  State<NewMessageField> createState() => _NewMessageFieldState();
}

class _NewMessageFieldState extends State<NewMessageField> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Card(
        elevation: 5,
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.attach_file),
            ),
            Expanded(
              child: TextField(
                controller: _textController,
                textCapitalization: TextCapitalization.sentences,
                minLines: 1,
                maxLines: 5,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Enviar mensaje...'),
              ),
            ),
            IconButton(
              onPressed: () async {
                //Utilizando el repositorio de firestore, enviamos el mensaje
                final Message message = Message(
                    chatId: widget.chat.id,
                    text: _textController.text,
                    senderId: widget.chat.userId,
                    time: DateTime.now(),
                    status: MessageStatus.enviado);

                //Enviar mensaje a un targetId
                await FirestoreRepository()
                    .addMessage(message, widget.chat.otherUserId);

                if (context.mounted) {
                  context.read<ChatCubit>().updateChat(widget.chat, message);
                }

                _textController.clear();
              },
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
