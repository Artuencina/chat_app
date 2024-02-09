//Modelo para los mensajes

import 'package:chat_app/models/chat.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'message.g.dart';

@HiveType(typeId: 1)
class Message extends Equatable {
  @HiveField(0)
  final Chat chat;
  @HiveField(1)
  final String text;
  @HiveField(2)
  final DateTime time;

  const Message({required this.chat, required this.text, required this.time});

  @override
  List<Object?> get props => [chat, text, time];
}
