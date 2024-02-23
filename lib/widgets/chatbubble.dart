//Burbuja de chat que muestra el mensaje, la hora
//Dependiendo si el mensaje es del usuario o del otro usuario, se muestra a la derecha o a la izquierda
//El color del usuario es primary y el del otro usuario es secondary

import 'package:chat_app/models/message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//Formatter
final DateFormat formatter = DateFormat('HH:mm');

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    required this.isMine,
    required this.continueChat,
  });

  final Message message;
  final bool isMine;
  final bool continueChat;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment:
          isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: width * 0.8,
          ),
          margin: EdgeInsets.symmetric(
              vertical: continueChat ? 1 : 10, horizontal: 10),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          decoration: BoxDecoration(
            color: isMine
                ? Theme.of(context).primaryColor
                : Theme.of(context).highlightColor,
            borderRadius: isMine
                ? const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )
                : const BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  message.text,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                formatter.format(message.time),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(
                width: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
