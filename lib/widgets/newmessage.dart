//Icono de clip para adjuntar archivos
//Textfield para escribir el mensaje
//Boton para enviar el mensaje

import 'package:flutter/material.dart';

class NewMessageField extends StatefulWidget {
  const NewMessageField({super.key});

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
              onPressed: () {},
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
