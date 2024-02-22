//Modelo para los mensajes

// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

part 'message.g.dart';

const uuid = Uuid();

//Enum para estado del mensaje
enum MessageStatus { noEnviado, enviado, recibido, leido }

@HiveType(typeId: 1)
class Message extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(0)
  final String chatId;
  @HiveField(1)
  final String text;
  @HiveField(2)
  final DateTime time;
  @HiveField(3)
  MessageStatus status;
  @HiveField(4)
  final String senderId;

  Message(
      {required this.chatId,
      required this.text,
      required this.time,
      required this.senderId,
      this.status = MessageStatus.noEnviado})
      : id = uuid.v4();

  Message.exists(
      {required this.id,
      required this.chatId,
      required this.text,
      required this.time,
      required this.senderId,
      required this.status});

  @override
  List<Object?> get props => [chatId, text, time];

  //Mapear de un mapa a un mensaje
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message.exists(
      id: map['id'],
      chatId: map['chat'],
      text: map['text'],
      senderId: map['senderId'],
      time: (map['time'] as Timestamp).toDate(),
      status: MessageStatus.values[map['status']],
    );
  }

  //Mapear de un mensaje a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chat': chatId,
      'text': text,
      'time': time,
      'senderId': senderId,
      'status': status.index,
    };
  }
}
