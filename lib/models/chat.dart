//Modelo de chat entre dos usuarios

// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'chat.g.dart';

@HiveType(typeId: 2)
class Chat extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final String otherUserId;
  @HiveField(3)
  String lastMessage;
  @HiveField(4)
  DateTime? lastMessageTime;
  @HiveField(5)
  int unreadMessages = 0;

  Chat(
      {required this.id,
      required this.userId,
      required this.lastMessage,
      required this.otherUserId,
      this.lastMessageTime,
      this.unreadMessages = 0});

  @override
  List<Object?> get props =>
      [id, userId, lastMessage, otherUserId, lastMessageTime, unreadMessages];

  //Mapear de un mapa a un chat
  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'],
      userId: map['userId'],
      otherUserId: map['otherUserId'],
      lastMessage: map['lastMessage'],
      lastMessageTime: (map['lastMessageTime'] as Timestamp).toDate(),
      unreadMessages: map['unreadMessages'],
    );
  }

  //Mapear de un chat a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'otherUserId': otherUserId,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'unreadMessages': unreadMessages,
    };
  }
}
