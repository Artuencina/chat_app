//Repositorio para Firestore

import 'package:chat_app/models/user.dart';
import 'package:chat_app/repository/hiverepository.dart';
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
  //Quitar de los usuarios encontrados al usuario con el id userId
  //Si el nombre esta vacio o tiene menos de 3 caracteres, no buscar
  Future<List<AppUser>> searchUsers(String name, String userId) async {
    if (name.isEmpty || name.length < 3) {
      return [];
    }

    final users = await _firestore
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: name)
        .where('name', isLessThanOrEqualTo: '${name}z')
        .limit(25)
        .get();

    final appUsers = users.docs.map((e) => AppUser.fromMap(e.data())).toList();

    appUsers.removeWhere((element) => element.id == userId);

    //Obtenemos los contactos locales para no mostrarlos
    final localContacts = await HiveRepository().getContacts();

    for (var contact in localContacts) {
      appUsers.removeWhere((element) => element.id == contact.id);
    }

    return appUsers;
  }
}
