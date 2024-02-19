//Estados para el cubit de contactos

import 'package:chat_app/models/user.dart';
import 'package:equatable/equatable.dart';

abstract class ContactState extends Equatable {
  final List<AppUser> contacts;
  const ContactState({required this.contacts});
}

class ContactInitial extends ContactState {
  const ContactInitial({required List<AppUser> contacts})
      : super(contacts: contacts);

  @override
  List<Object?> get props => [contacts];
}

class ContactLoading extends ContactState {
  const ContactLoading({required List<AppUser> contacts})
      : super(contacts: contacts);

  @override
  List<Object?> get props => [contacts];
}

class ContactReady extends ContactState {
  const ContactReady({required List<AppUser> contacts})
      : super(contacts: contacts);

  @override
  List<Object?> get props => [contacts];
}

class ContactError extends ContactState {
  final String message;

  const ContactError({required this.message, required List<AppUser> contacts})
      : super(contacts: contacts);

  @override
  List<Object?> get props => [message, contacts];
}
