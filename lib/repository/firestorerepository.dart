//Repositorio para Firestore

import 'package:chat_app/models/chat.dart';
import 'package:chat_app/models/message.dart';
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

  //---------Chats

  //Crear un chat con un usuario
  Future<void> createChat(String userId, String contactId) async {
    //Si el chat ya existe, no hacer nada
    if (await getChatId(userId, contactId) != null) return;

    final chatId = _firestore.collection('chats').doc().id;

    final Chat chat = Chat(
      id: chatId,
      userId: userId,
      otherUserId: contactId,
      lastMessage: '',
      lastMessageTime: null,
      unreadMessages: 0,
    );

    //Guardar chat en la coleccion de chats
    await _firestore.collection('chats').doc(chatId).set(chat.toMap());

    //Tambien guardamos el id del chat en la coleccion de usuarios
    //Y el id del chat en la coleccion de contactos
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('contacts')
        .doc(contactId)
        .set({'chatId': chatId});
  }

  //Obtener los chats de un usuario
  Future<List<Chat>> getChats(String userId) async {
    final chats = await _firestore
        .collection('chats')
        .where('userId', isEqualTo: userId)
        .get();

    return chats.docs.map((e) => Chat.fromMap(e.data())).toList();
  }

  //Obtener el id del chat entre dos usuarios
  Future<String?> getChatId(String userId, String contactId) async {
    final chat = await _firestore
        .collection('users')
        .doc(userId)
        .collection('contacts')
        .doc(contactId)
        .get();

    final data = chat.data();

    return data != null ? data['chatId'] : null;
  }

  //Obtener el chat a partir de un Id
  Future<Chat?> getChatById(String chat) async {
    final chatData = await _firestore.collection('chats').doc(chat).get();
    return Chat.fromMap(chatData.data()!);
  }

  //Eliminar un chat
  Future<void> deleteChat(String chatId) async {
    final chat = await getChatById(chatId);
    await _firestore.collection('chats').doc(chatId).delete();

    //Borrar tambien el registro en la coleccion de contactos del usuario
    await _firestore
        .collection('users')
        .doc(chat!.userId)
        .collection('contacts')
        .doc(chat.otherUserId)
        .delete();
  }

  //Actualizar el ultimo mensaje de un chat
  Future<void> updateChatLastMessage(Message message) {
    final chatId = message.chatId;

    return _firestore.collection('chats').doc(chatId).update({
      'lastMessage': message.text,
      'lastMessageTime': message.time,
    });
  }

  //---------Mensajes

  //Obtener los mensajes de un chat
  Future<List<Message>> getMessages(String chatId) async {
    final messages = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('time', descending: true)
        .limit(25)
        .get();

    return messages.docs.map((e) => Message.fromMap(e.data())).toList();
  }

  //Agregar un mensaje a un chat
  Future<void> addMessage(Message message) async {
    await _firestore
        .collection('chats')
        .doc(message.chatId)
        .collection('messages')
        .doc()
        .set(message.toMap());
  }
}
