//Estados de usuario para el cubit
//Los estados son:
//Initial: Estado inicial
//Loading: Estado de carga
//Ready: Estado de listo
//Error: Estado de error

// ignore_for_file: must_be_immutable

import 'package:chat_app/models/user.dart';
import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {
  AppUser? currentUser;
  UserState({required this.currentUser});
}

class UserInitial extends UserState {
  UserInitial() : super(currentUser: null);

  @override
  List<Object?> get props => [currentUser];
}

class UserLoading extends UserState {
  UserLoading({required AppUser currentUser}) : super(currentUser: currentUser);

  @override
  List<Object?> get props => [currentUser];
}

class UserReady extends UserState {
  UserReady({required AppUser currentUser}) : super(currentUser: currentUser);

  @override
  List<Object?> get props => [currentUser];
}

class UserError extends UserState {
  final String message;

  UserError({required this.message}) : super(currentUser: null);

  @override
  List<Object?> get props => [message];
}
