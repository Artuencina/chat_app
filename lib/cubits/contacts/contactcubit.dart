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

  //Metodo para obtener los contactos
  //Obtiene de firebase y guarda en Hive
  Future<void> getRemoteContacts(String userId) async {
    emit(const ContactLoading(contacts: []));

    try {
      final contacts = await firestoreRepository.getContacts(userId);

      if (contacts.isEmpty) {
        emit(const ContactError(message: 'No hay contactos', contacts: []));
        return;
      }

      await hiveRepository.saveContacts(contacts);
      emit(ContactReady(contacts: contacts));
    } catch (e) {
      emit(ContactError(message: e.toString(), contacts: state.contacts));
    }
  }

  //Metodo para obtener los contactos de Hive
  Future<void> getLocalContacts() async {
    emit(const ContactLoading(contacts: []));

    try {
      final contacts = await hiveRepository.getContacts();

      if (contacts.isEmpty) {
        emit(const ContactError(message: 'No contacts found', contacts: []));
        return;
      }

      emit(ContactReady(contacts: contacts));
    } catch (e) {
      emit(ContactError(message: e.toString(), contacts: state.contacts));
    }
  }

  //Metodo para agregar un contacto
  Future<void> addContact(String userId, AppUser user) async {
    try {
      await firestoreRepository.addContact(userId, user);

      final contacts = [...state.contacts, user];
      contacts.sort((a, b) => a.name.compareTo(b.name));

      emit(ContactReady(contacts: contacts));
    } catch (e) {
      emit(ContactError(message: e.toString(), contacts: state.contacts));
    }
  }
}
