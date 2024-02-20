//Repositorio para facilitar el acceso a los datos
//Utilizando hive

import 'package:chat_app/models/chat.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/repository/firestorerepository.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveRepository {
  //Metodo para registrar todos los adaptadores de Hive
  Future<void> registerAdapters() async {
    Hive.registerAdapter(ChatAdapter());
    Hive.registerAdapter(MessageAdapter());
    Hive.registerAdapter(AppUserAdapter());
  }

  //DEBUG
  //Metodo para borrar todos los datos de Hive
  Future<void> deleteAllData() async {
    //Abrir las cajas y borrarlas
    await Hive.deleteBoxFromDisk('settings');
    await Hive.deleteBoxFromDisk('chats');
    await Hive.deleteBoxFromDisk('messages');
    await Hive.deleteBoxFromDisk('users');
    await Hive.deleteBoxFromDisk('contacts');
  }

  //Metodo para guardar un chat
  Future<void> saveChat(Chat chat) async {
    final box = await Hive.openBox<Chat>('chats');
    await box.put(chat.otherUserId, chat);
  }

  //Guardar datos de inicio de sesion en el box settings
  Future<void> saveLoginData(String email, String password) async {
    var box = await Hive.openBox('settings');
    await box.put('email', email);
    await box.put('password', password);
  }

  //Metodo para actualizar un chat en la lista y moverlo al inicio
  Future<void> updateChat(Chat chat) async {
    final box = await Hive.openBox<Chat>('chats');
    await box.put(chat.otherUserId, chat);

    //Mover el chat al inicio de la lista
    final chats = await getChats();
    chats.removeWhere((c) => c.id == chat.id);
    chats.insert(0, chat);
  }

  //Metodo para obtener todos los chats
  Future<List<Chat>> getChats() async {
    final box = await Hive.openBox<Chat>('chats');
    return box.values.toList();
  }

  //Metodo para obtener un chat por el id de otherUser
  Future<Chat?> getChatByOtherUserId(String id) async {
    final box = await Hive.openBox<Chat>('chats');

    return box.get(id);
  }

  //Obtener chat a partir de un id
  Chat? getChatById(String id) {
    final box = Hive.box('chats');
    return box.values.firstWhere((c) => c.id == id);
  }

  //Metodo para guardar un usuario
  Future<void> saveUser(AppUser user) async {
    if (Hive.isBoxOpen('users') == true) {
      final box = Hive.box('users');
      await box.put(user.id, user);
      return;
    }
    final box = await Hive.openBox<AppUser>('users');
    await box.put(user.id, user);
  }

  //Meotodo para eliminar un usuario
  Future<void> deleteUser(AppUser user) async {
    if (Hive.isBoxOpen('users') == true) {
      final box = Hive.box('users');
      await box.delete(user.id);
      return;
    }
    final box = await Hive.openBox<AppUser>('users');
    await box.delete(user.id);
  }

  //Metodo para obtener un usuario por su id
  AppUser? getUserById(String id) {
    final box = Hive.box('users');

    AppUser? user = box.get(id);

    //Si user es null, intentar buscar en firestore y guardarlo en el box
    if (user == null) {
      FirestoreRepository().getUserById(id).then((value) {
        if (value != null) {
          user = value;
          saveUser(value);
        } else {
          return null;
        }
      });
    }

    return user;
  }

  //Metodo para guardar un mensaje
  Future<void> saveMessage(Message message) async {
    final box = await Hive.openBox<Message>('messages');
    await box.add(message);
  }

  //Guardar mensajes de un chat
  //Este metodo sirve para recibir los mensajes de firestore y guardarlos en el box
  //Solamente si los mensajes no estan ya guardados
  Future<void> saveMessages(String chatId, List<Message> messages) async {
    final box = await Hive.openBox<Message>('messages');
    for (var message in messages) {
      if (box.values.where((m) => m.id == message.id).isEmpty) {
        await box.add(message);
      }
    }
  }

  //Metodo para obtener todos los mensajes de un chat
  Future<List<Message>> getMessages(String chatId) async {
    final box = await Hive.openBox<Message>('messages');
    return box.values.where((m) => m.chatId == chatId).toList();
  }

  //Metodo para guardar los contactos
  Future<void> saveContacts(List<AppUser> contacts) async {
    final box = await Hive.openBox<AppUser>('contacts');
    await box.clear();
    for (var contact in contacts) {
      await box.put(contact.id, contact);
    }
  }

  //Metodo para obtener los contactos
  Future<List<AppUser>> getContacts() async {
    final box = await Hive.openBox<AppUser>('contacts');
    return box.values.toList();
  }

  //Metodo para buscar contactos por su nombre
  Future<List<AppUser>> searchContacts(String query) async {
    final box = await Hive.openBox<AppUser>('contacts');
    return box.values
        .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  //Metodo para obtener un contacto por su id
  AppUser? getContactById(String id) {
    final box = Hive.box('contacts');
    return box.get(id);
  }

  //Metodo para eliminar un contacto
  Future<void> deleteContact(AppUser contact) async {
    final box = await Hive.openBox<AppUser>('contacts');
    await box.delete(contact.id);
  }

  //Metodo para agregar un contacto
  Future<void> addContact(AppUser contact) async {
    final box = await Hive.openBox<AppUser>('contacts');
    await box.put(contact.id, contact);
  }
}
