//Estados de mensajes para cubit

import 'package:chat_app/models/message.dart';
import 'package:equatable/equatable.dart';

abstract class MessageState extends Equatable {
  final List<Message> messages;
  const MessageState({required this.messages});
}

class MessagesLoading extends MessageState {
  const MessagesLoading({required List<Message> messages})
      : super(messages: messages);

  @override
  List<Object> get props => [messages];
}

class MessagesLoaded extends MessageState {
  const MessagesLoaded({required List<Message> messages})
      : super(messages: messages);

  @override
  List<Object> get props => [messages];
}

class MessagesError extends MessageState {
  const MessagesError({required List<Message> messages})
      : super(messages: messages);

  @override
  List<Object> get props => [messages];
}
