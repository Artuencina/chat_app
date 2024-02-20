//Tile para mostrar en el listview de contactos

import 'package:chat_app/cubits/contacts/contactcubit.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/widgets/profilemini.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactTile extends StatelessWidget {
  const ContactTile({super.key, required this.contact, this.isContact = true});

  final AppUser contact;

  final bool isContact;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ProfileThumbnail(
        user: contact,
      ),
      title: Text(
        contact.name,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        contact.info,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: isContact
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.chat),
                  onPressed: () {
                    //Iniciar chat
                  },
                ),
                //Eliminar contacto
                PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: ListTile(
                          leading: const Icon(Icons.delete),
                          title: const Text('Eliminar contacto'),
                          onTap: () {
                            //Eliminar contacto
                            final userId =
                                FirebaseAuth.instance.currentUser!.uid;
                            context
                                .read<ContactsCubit>()
                                .deleteContact(userId, contact);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ];
                  },
                ),
              ],
            )
          : IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: () {
                //Agregar contacto
                final userId = FirebaseAuth.instance.currentUser!.uid;
                context.read<ContactsCubit>().addContact(userId, contact);
                Navigator.pop(context);
              },
            ),
    );
  }
}
