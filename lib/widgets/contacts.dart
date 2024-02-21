//Widget que muestra los contactos

import 'package:chat_app/cubits/contacts/contactcubit.dart';
import 'package:chat_app/cubits/contacts/contactstate.dart';
import 'package:chat_app/widgets/contacttile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactsCubit, ContactState>(
      builder: ((context, state) {
        if (state is ContactLoading) {
          return Column(
            children: [
              LinearProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.contacts.length,
                  itemBuilder: (context, index) {
                    return ContactTile(contact: state.contacts[index]);
                  },
                ),
              ),
            ],
          );
        }

        if (state is ContactError) {
          return Center(
            child: Text(state.message),
          );
        }

        if (state is ContactReady) {
          return ListView.builder(
            itemCount: state.contacts.length,
            itemBuilder: (context, index) {
              return ContactTile(contact: state.contacts[index]);
            },
          );
        }

        return const SizedBox.shrink();
      }),
    );
  }
}
