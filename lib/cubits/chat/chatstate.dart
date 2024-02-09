//Estados de un chat para el cubit ChatCubit

import 'package:chat_app/models/chat.dart';
import 'package:equatable/equatable.dart';

abstract class ChatsState extends Equatable {}

class ChatsInitial extends ChatsState {
  @override
  List<Object?> get props => [];
}

class ChatsLoading extends ChatsState {
  @override
  List<Object?> get props => [];
}

class ChatsLoaded extends ChatsState {
  final List<Chat> chats;

  ChatsLoaded({required this.chats});

  @override
  List<Object?> get props => [chats];
}

//Estado de chat vacio
class ChatsEmpty extends ChatsState {
  @override
  List<Object?> get props => [];
}

class ChatsError extends ChatsState {
  final String message;

  ChatsError({required this.message});

  @override
  List<Object?> get props => [message];
}
