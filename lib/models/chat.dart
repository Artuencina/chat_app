//Modelo de chat entre dos usuarios

// ignore_for_file: must_be_immutable

import 'package:chat_app/models/user.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'chat.g.dart';

@HiveType(typeId: 2)
class Chat extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final AppUser user;
  @HiveField(2)
  final AppUser otherUser;
  @HiveField(3)
  String lastMessage;
  @HiveField(4)
  DateTime? lastMessageTime;
  @HiveField(5)
  int unreadMessages = 0;

  Chat(
      {required this.id,
      required this.user,
      required this.lastMessage,
      required this.otherUser,
      this.lastMessageTime});

  @override
  List<Object?> get props =>
      [id, user, lastMessage, otherUser, lastMessageTime, unreadMessages];
}
