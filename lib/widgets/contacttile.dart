//Tile para mostrar en el listview de contactos

import 'package:chat_app/models/user.dart';
import 'package:flutter/material.dart';

class ContactTile extends StatelessWidget {
  const ContactTile({super.key, required this.contact});

  final AppUser contact;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: contact.imageUrl.isEmpty
            ? NetworkImage(contact.imageUrl)
            : const AssetImage('assets/images/profile.png') as ImageProvider,
      ),
      title: Text(
        contact.name,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        contact.info,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.person_add_alt_1_rounded),
        onPressed: () {
          //Agregar contacto
        },
      ),
    );
  }
}
