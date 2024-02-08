//Datos de prueba para cargar los chats temporalmente
class User {
  final String id;
  final String name;
  final String info;
  //Imagen de perfil
  final String imageUrl;
  String phone;

  User(
      {required this.id,
      required this.name,
      required this.imageUrl,
      this.info = '',
      this.phone = ''});
}

class Message {
  final Chat chat;
  final String text;
  final DateTime time;

  const Message({required this.chat, required this.text, required this.time});
}

User? getUser(String id) {
  for (var user in users) {
    if (user.id == id) {
      return user;
    }
  }
  return null;
}

//Genera una lista de mensajes de prueba
List<User> users = [
  User(
      id: '1',
      name: 'Juan',
      info: 'Estoy usando chat app',
      imageUrl:
          'https://i.pinimg.com/474x/97/aa/84/97aa847d061a14894178805f1d551500.jpg'),
  User(
      id: '2',
      name: 'Pedro',
      info: 'Ideas are bulletproof',
      imageUrl:
          'https://i.pinimg.com/474x/97/aa/84/97aa847d061a14894178805f1d551500.jpg'),
  User(
      id: '3',
      name: 'Maria',
      info: 'Hola',
      imageUrl:
          'https://i.pinimg.com/474x/97/aa/84/97aa847d061a14894178805f1d551500.jpg'),
  User(
      id: '4',
      name: 'Ana',
      imageUrl:
          'https://i.pinimg.com/474x/97/aa/84/97aa847d061a14894178805f1d551500.jpg'),
  User(
      id: '5',
      name: 'Luis',
      imageUrl:
          'https://i.pinimg.com/474x/97/aa/84/97aa847d061a14894178805f1d551500.jpg'),
  User(
      id: '6',
      name: 'Carlos',
      imageUrl:
          'https://i.pinimg.com/474x/97/aa/84/97aa847d061a14894178805f1d551500.jpg'),
];

class Chat {
  final User user;
  final User otherUser;
  String lastMessage;
  DateTime? lastMessageTime;

  Chat(
      {required this.user,
      required this.lastMessage,
      required this.otherUser,
      this.lastMessageTime});
}

//Generar lista de chats, todos los usuarios tienen un chat con el usuario 0
final _chats = [
  Chat(user: users[0], lastMessage: 'Hola, ¿cómo estás?', otherUser: users[1]),
  Chat(user: users[0], lastMessage: 'Hola, ¿cómo estás?', otherUser: users[2]),
  Chat(user: users[0], lastMessage: 'Hola, ¿cómo estás?', otherUser: users[3]),
  Chat(user: users[1], lastMessage: 'Hola, ¿cómo estás?', otherUser: users[4]),
  Chat(user: users[0], lastMessage: 'Hola, ¿cómo estás?', otherUser: users[5]),
];

//Mensajes
final mensajes = [
  Message(
      chat: _chats[0],
      text: 'Hola, ¿cómo estás?',
      time: DateTime.now().subtract(const Duration(minutes: 5))),
  Message(
      chat: _chats[0],
      text: 'Bien, gracias. ¿Y tú?',
      time: DateTime.now().subtract(const Duration(minutes: 3))),
  Message(
      chat: _chats[1],
      text: 'También bien, gracias.',
      time: DateTime.now().subtract(const Duration(minutes: 2))),
  Message(
      chat: _chats[2],
      text: '¿Qué has hecho hoy?',
      time: DateTime.now().subtract(const Duration(minutes: 1))),
  Message(
      chat: _chats[3],
      text: 'He estado trabajando.',
      time: DateTime.now().subtract(const Duration(seconds: 30))),
  Message(
      chat: _chats[4],
      text: 'Vaya, yo he estado en casa.',
      time: DateTime.now().subtract(const Duration(seconds: 10))),
  Message(
      chat: _chats[2],
      text: '¿Qué has hecho hoy?',
      time: DateTime.now().subtract(const Duration(minutes: 1))),
  Message(
      chat: _chats[1],
      text: 'He estado trabajando.',
      time: DateTime.now().subtract(const Duration(seconds: 30))),
  Message(
      chat: _chats[0],
      text: 'Vaya, yo he estado en casa.',
      time: DateTime.now().subtract(const Duration(seconds: 10))),
  Message(
      chat: _chats[0],
      text: '¿Qué has hecho hoy?',
      time: DateTime.now().subtract(const Duration(minutes: 1))),
  Message(
      chat: _chats[1],
      text: 'He estado trabajando.',
      time: DateTime.now().subtract(const Duration(seconds: 30))),
  Message(
    chat: _chats[0],
    text: 'Vaya, yo he estado en casa.',
    time: DateTime.now().subtract(const Duration(seconds: 10)),
  ),
];

//Funcion para obtener los chats de un usuario
List<Chat> getChats(int index) {
  List<Chat> chats = [];
  for (var chat in _chats) {
    if (chat.user == users[index]) {
      //Para facilitar el manejo de los chats, el primer usuario siempre sera
      //el que se pasa por parametro
      Message message = getLastMessage(chat);
      chat.lastMessage = message.text;
      chat.lastMessageTime = message.time;

      chats.add(chat);
    } else if (chat.otherUser == users[index]) {
      Message message = getLastMessage(chat);

      Chat newChat = Chat(
        user: chat.otherUser,
        lastMessage: chat.lastMessage = message.text,
        lastMessageTime: message.time,
        otherUser: chat.user,
      );
      chats.add(newChat);
    }
  }
  return chats;
}

//Funcion para obtener el ultimo mensaje de un chat
Message getLastMessage(Chat chat) {
  for (var message in mensajes) {
    if (message.chat == chat) {
      return message;
    }
  }
  return Message(
      chat: chat,
      text: 'No hay mensajes',
      time: DateTime.now().subtract(const Duration(days: 1)));
}

User getCurrentUser() {
  return users[0];
}
