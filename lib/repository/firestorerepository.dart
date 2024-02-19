//Repositorio para Firestore

import 'package:chat_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreRepository {
  final _firestore = FirebaseFirestore.instance;

  //Obtener la lista de usuarios
  Future<List<AppUser>> getUsers() async {
    final users = await _firestore.collection('users').get();
    return users.docs.map((e) => AppUser.fromMap(e.data())).toList();
  }

  //Obtener un usuario por su id
  Future<AppUser?> getUserById(String id) async {
    final user = await _firestore.collection('users').doc(id).get();
    return AppUser.fromMap(user.data()!);
  }

  //Actualizar la información de un usuario
  Future<void> updateUser(AppUser user) async {
    await _firestore.collection('users').doc(user.id).update(user.toMap());
  }

  //Eliminar un usuario
  Future<void> deleteUser(String id) async {
    await _firestore.collection('users').doc(id).delete();
  }

  //Agregar un usuario
  Future<void> addOrUpdateUser(AppUser user) async {
    await _firestore.collection('users').doc(user.id).set(user.toMap());
  }

  //------------Contactos

  //Obtener la lista de contactos de un usuario
  Future<List<AppUser>> getContacts(String id) async {
    final contacts = await _firestore
        .collection('users')
        .doc(id)
        .collection('contacts')
        .get();
    return contacts.docs.map((e) => AppUser.fromMap(e.data())).toList();
  }

  //Agregar un contacto
  Future<void> addContact(String userId, AppUser contact) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('contacts')
        .doc(contact.id)
        .set(contact.toMap());
  }

  //Eliminar un contacto
  Future<void> deleteContact(String userId, String contactId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('contacts')
        .doc(contactId)
        .delete();
  }

  //Buscar 10 usuarios que coincidan con el nombre
  Future<List<AppUser>> searchUsers(String name) async {
    final users = await _firestore
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: name)
        .where('name', isLessThan: '${name}z')
        .limit(10)
        .get();
    return users.docs.map((e) => AppUser.fromMap(e.data())).toList();
  }
}
