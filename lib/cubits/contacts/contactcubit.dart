//Cubit para manejar los estados de los contactos

import 'package:chat_app/cubits/contacts/contactstate.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/repository/firestorerepository.dart';
import 'package:chat_app/repository/hiverepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsCubit extends Cubit<ContactState> {
  HiveRepository hiveRepository;
  FirestoreRepository firestoreRepository;

  ContactsCubit({
    required this.hiveRepository,
    required this.firestoreRepository,
  }) : super(const ContactInitial(contacts: []));

  //Obtener los contactos de Hive y de Firestore
  Future<void> getContacts() async {
    final contacts = await hiveRepository.getContacts();

    if (contacts.isEmpty) {
      emit(const ContactError(message: 'No hay contactos', contacts: []));
    } else {
      emit(ContactLoading(contacts: contacts));
    }

    final userId = await hiveRepository.getCurrentUserId();

    if (userId == null) {
      if (contacts.isEmpty) {
        emit(const ContactError(message: 'No hay usuario', contacts: []));
        return;
      }
      emit(ContactReady(contacts: contacts));
      return;
    }

    final firebaseContacts = await firestoreRepository.getContacts(userId);

    if (firebaseContacts.isEmpty) {
      return;
    }

    for (var contact in firebaseContacts) {
      if (!contacts.contains(contact)) {
        await hiveRepository.addContact(contact);
      }
    }

    final allContacts = await hiveRepository.getContacts();

    emit(ContactReady(contacts: allContacts));
  }

  //Metodo para agregar un contacto
  Future<void> addContact(String userId, AppUser user) async {
    try {
      await firestoreRepository.addContact(userId, user);

      await hiveRepository.addContact(user);

      final contacts = [...state.contacts, user];
      contacts.sort((a, b) => a.name.compareTo(b.name));

      emit(ContactReady(contacts: contacts));
    } catch (e) {
      emit(ContactError(message: e.toString(), contacts: state.contacts));
    }
  }

  //Eliminar contacto
  Future<void> deleteContact(String userId, AppUser user) async {
    try {
      await firestoreRepository.deleteContact(userId, user.id);

      await hiveRepository.deleteContact(user);

      final contacts = state.contacts.where((e) => e.id != user.id).toList();

      if (contacts.isEmpty) {
        emit(ContactError(message: 'No hay contactos', contacts: contacts));
        return;
      }

      emit(ContactReady(contacts: contacts));
    } catch (e) {
      emit(ContactError(message: e.toString(), contacts: state.contacts));
    }
  }
}
