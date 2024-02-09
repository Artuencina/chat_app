//Cubit para manejar el usuario

import 'dart:io';

import 'package:chat_app/models/user.dart';
import 'package:chat_app/repository/hiverepository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'userstate.dart';

class UserCubit extends Cubit<UserState> {
  final HiveRepository hiveRepository;

  UserCubit({required this.hiveRepository}) : super(UserInitial());

  //Metodo para obtener el usuario por el id
  Future<void> getUserById(String id) async {
    try {
      final user = hiveRepository.getUserById(id);

      if (user == null) {
        emit(UserError(message: 'User not found'));
        return;
      }
      emit(UserReady(currentUser: user));
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  //Metodo para actualizar el usuario
  Future<void> updateUser(AppUser user) async {
    try {
      await hiveRepository.saveUser(user);
      emit(UserReady(currentUser: user));
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  //Metodo para elegir la imagen de perfil
  void pickImage() async {
    File? image;

    final pickedImage = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxWidth: 200);

    if (pickedImage == null) {
      return;
    }

    image = File(pickedImage.path);

    //Subir la imagen a Firebase Storage, con la extension del archivo
    final extension = image.path.split('.').last;
    final storage = FirebaseStorage.instance
        .ref()
        .child('user_images')
        .child('${state.currentUser}.$extension');

    await storage.putFile(image);

    //Tambien vamos a actualizar el link de la imagen en la base de datos
    //para que se muestre en la pantalla de perfil
    //Obtener el link de la imagen
    final AppUser newUser = AppUser(
        id: state.currentUser!.id,
        email: state.currentUser!.email,
        phone: state.currentUser!.phone,
        imageUrl: await storage.getDownloadURL(),
        name: state.currentUser!.name);

    await updateUser(newUser);
  }
}
