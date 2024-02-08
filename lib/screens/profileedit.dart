//Screen para editar el perfil del usuario

import 'package:chat_app/chats.dart';
import 'package:flutter/material.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key, required this.userId});

  final String userId;

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late User? user;
  @override
  void initState() {
    //Obtener los datos del usuario
    user = getUser(widget.userId);
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
              backgroundImage: const AssetImage(
                'assets/images/profile.png',
              ),
              foregroundImage: NetworkImage(user?.imageUrl ?? ''),

              radius: 100,
            ),
            TextButton.icon(
                icon: const Icon(Icons.camera),
                label: const Text('Cambiar foto'),
                onPressed: () {}),
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
          ],
        ));
  }
}
