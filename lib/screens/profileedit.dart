//Screen para editar el perfil del usuario

import 'dart:io';

import 'package:chat_app/models/user.dart';
import 'package:chat_app/repository/hiverepository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen(
      {super.key, required this.userId, this.firstTime = false});

  final String userId;

  final bool firstTime;

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  File? _image;

  void _pickImage() async {
    final pickedImage = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxWidth: 200);

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _image = File(pickedImage.path);
    });

    //Subir la imagen a Firebase Storage, con la extension del archivo
    final extension = _image!.path.split('.').last;
    final storage = FirebaseStorage.instance
        .ref()
        .child('user_images')
        .child('${widget.userId}.$extension');

    await storage.putFile(_image!);

    //Tambien vamos a actualizar el link de la imagen en la base de datos
    //para que se muestre en la pantalla de perfil
    //Obtener el link de la imagen
    user?.imageUrl = await storage.getDownloadURL();
  }

  AppUser? user;

  @override
  void initState() {
    user = HiveRepository().getUserById(widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Perfil'),
        ),
        body: Column(
          children: [
            const SizedBox(
              width: double.infinity,
              height: 30,
            ),
            CircleAvatar(
              //backgroundColor: Colors.grey,
              backgroundColor: Colors.grey,
              foregroundImage: Image.network(
                user!.imageUrl,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return const CircularProgressIndicator();
                },
              ).image,

              radius: 100,
            ),
            TextButton.icon(
                icon: const Icon(Icons.camera),
                label: const Text('Cambiar foto'),
                onPressed: () {
                  _pickImage();
                }),
            //Nombre con icono para editar y cambiar que
            //abre un modalbotomsheet
            ListTile(
              leading: const Icon(Icons.person_rounded),
              title: const Text('Nombre'),
              subtitle: Text(user?.name ?? ''),
              trailing: IconButton(
                icon: const Icon(Icons.edit_rounded),
                onPressed: () {
                  //Abrir modalbottomsheet para editar el nombre

                  TextEditingController controller =
                      TextEditingController(text: user?.name ?? '');

                  showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: const Text('Nombre'),
                                subtitle: TextField(
                                  autofocus: true,
                                  controller: controller,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancelar')),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Guardar')),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        );
                      });
                },
              ),
            ),
            //Info
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Info'),
              subtitle: Text(user?.info ?? ''),
              trailing: IconButton(
                icon: const Icon(Icons.edit_rounded),
                onPressed: () {
                  //Mostrar modal para editar la info
                  TextEditingController controller =
                      TextEditingController(text: user?.info ?? '');

                  showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: const Text('Info'),
                                subtitle: TextField(
                                  autofocus: true,
                                  maxLines: 3,
                                  controller: controller,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancelar')),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Guardar')),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        );
                      });
                },
              ),
            ),
            //Telefono (no editable)
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Telefono'),
              subtitle: Text(user?.phone.isEmpty ?? true
                  ? 'No disponible'
                  : user?.phone ?? ''),
            ),
            if (widget.firstTime)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/');
                      },
                      child: const Text('Continuar'),
                    ),
                  ),
                ],
              ),
          ],
        ));
  }
}
