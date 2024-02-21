//Estados de un chat para el cubit ChatCubit

import 'package:chat_app/models/chat.dart';
import 'package:equatable/equatable.dart';

abstract class ChatsState extends Equatable {
  final List<Chat> chats;
  const ChatsState({required this.chats});
}

class ChatsInitial extends ChatsState {
  const ChatsInitial({required List<Chat> chats}) : super(chats: chats);

  @override
  List<Object?> get props => [chats];
}

class ChatsLoading extends ChatsState {
  const ChatsLoading({required List<Chat> chats}) : super(chats: chats);

  @override
  List<Object?> get props => [chats];
}

class ChatsLoaded extends ChatsState {
  const ChatsLoaded({required List<Chat> chats}) : super(chats: chats);

  @override
  List<Object?> get props => [chats];
}

class ChatsEmpty extends ChatsState {
  const ChatsEmpty({required List<Chat> chats}) : super(chats: chats);

  @override
  List<Object?> get props => [chats];
}

class ChatsError extends ChatsState {
  final String message;

  const ChatsError({required this.message, required List<Chat> chats})
      : super(chats: chats);

  @override
  List<Object?> get props => [message, chats];
}
