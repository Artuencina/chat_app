//Burbuja de chat que muestra el mensaje, la hora
//Dependiendo si el mensaje es del usuario o del otro usuario, se muestra a la derecha o a la izquierda
//El color del usuario es primary y el del otro usuario es secondary
//TODO: Agregar estados de lectura

import 'package:chat_app/models/message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//Formatter
final DateFormat formatter = DateFormat('HH:mm');

class ChatBubble extends StatefulWidget {
  const ChatBubble({
    super.key,
    required this.message,
    required this.isMine,
  });

  final Message message;
  final bool isMine;

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          widget.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            color: widget.isMine
                ? Theme.of(context).primaryColor
                : Theme.of(context).highlightColor,
            borderRadius: widget.isMine
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.message.text,
                style: TextStyle(
                  color: widget.isMine
                      ? Theme.of(context).highlightColor
                      : Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                formatter.format(widget.message.time),
                style: TextStyle(
                  color: widget.isMine
                      ? Theme.of(context).highlightColor
                      : Theme.of(context).primaryColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
