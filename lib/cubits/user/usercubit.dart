//Cubit para manejar el usuario

import 'dart:io';

import 'package:chat_app/models/user.dart';
import 'package:chat_app/repository/firestorerepository.dart';
import 'package:chat_app/repository/hiverepository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'userstate.dart';

class UserCubit extends Cubit<UserState> {
  final HiveRepository hiveRepository;
  final FirestoreRepository firestoreRepository;

  UserCubit({required this.hiveRepository, required this.firestoreRepository})
      : super(UserInitial());

  //Metodo para obtener el usuario por el id
  Future<void> setUserById(String id) async {
    //Dentro de un try intentamos obtener el usuario de firebase
    //Se guarda en hive y se emite el estado UserReady
    //Si hay un error, se emite el estado UserError
    try {
      //Si el box de usuarios no esta abierto, lo abrimos
      await hiveRepository.openBox('users');
      //await hiveRepository.openBox('chats');

      final user = await firestoreRepository.getUserById(id);

      if (user == null) {
        //Borrar el usuario de Hive si no se encuentra en Firebase
        final hiveUser = hiveRepository.getUserById(id);

        if (hiveUser != null) {
          await hiveRepository.deleteUser(hiveUser);
        }
        emit(UserError(message: 'User not found'));
        return;
      }

      await hiveRepository.saveUser(user);
      await hiveRepository.setCurrentUser(user.id);
      emit(UserReady(currentUser: user));
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  //Quitar el usuario actual
  void signOut() async {
    await hiveRepository.deleteAllData(); //Borrar todos los datos de Hive
    emit(UserInitial());
  }

  //Metodo para actualizar el usuario
  Future<void> updateUser(AppUser user) async {
    try {
      await hiveRepository.saveUser(user);
      await hiveRepository.setCurrentUser(user.id);
      await firestoreRepository.addOrUpdateUser(user);
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
        .child('${state.currentUser!.id}.$extension');

    await storage.putFile(image);

    //Tambien vamos a actualizar el link de la imagen en la base de datos
    //para que se muestre en la pantalla de perfil
    //Obtener el link de la imagen
    await updateUser(
        state.currentUser!.copyWith(imageUrl: await storage.getDownloadURL()));
  }
}
