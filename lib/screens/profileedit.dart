//Screen para editar el perfil del usuario

import 'package:chat_app/cubits/chat/chatcubit.dart';
import 'package:chat_app/cubits/user/usercubit.dart';
import 'package:chat_app/cubits/user/userstate.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen(
      {super.key, required this.userId, this.firstTime = false});

  final String userId;

  final bool firstTime;

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(builder: (context, state) {
      if (state is UserLoading || state is UserInitial) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      if (state is UserError) {
        return Scaffold(
          body: Center(
            child: Text(state.message),
          ),
        );
      }
      if (state is UserReady) {
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
                  state.currentUser!.imageUrl,
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
                  icon: const Icon(Icons.image_rounded),
                  label: const Text('Cambiar foto'),
                  onPressed: () {
                    //Llamar al cubit para cambiar la foto
                    context.read<UserCubit>().pickImage();
                  }),
              //Nombre con icono para editar y cambiar que
              //abre un modalbotomsheet
              ListTile(
                leading: const Icon(Icons.person_rounded),
                title: const Text('Nombre'),
                subtitle: Text(state.currentUser?.name ?? ''),
                trailing: IconButton(
                  icon: const Icon(Icons.edit_rounded),
                  onPressed: () {
                    //Abrir modalbottomsheet para editar el nombre

                    TextEditingController controller = TextEditingController(
                        text: state.currentUser?.name ?? '');

                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
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
                                          //Actualizar el nombre

                                          context.read<UserCubit>().updateUser(
                                              state.currentUser!.copyWith(
                                                  name: controller.text));
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
                subtitle: Text(state.currentUser?.info ?? ''),
                trailing: IconButton(
                  icon: const Icon(Icons.edit_rounded),
                  onPressed: () {
                    //Mostrar modal para editar la info
                    TextEditingController controller = TextEditingController(
                        text: state.currentUser?.info ?? '');

                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
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
                                          //Guardar la info
                                          context.read<UserCubit>().updateUser(
                                              state.currentUser!.copyWith(
                                                  info: controller.text));
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
                subtitle: Text(state.currentUser?.phone.isEmpty ?? true
                    ? 'No disponible'
                    : state.currentUser?.phone ?? ''),
              ),
              if (widget.firstTime)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<ChatCubit>().loadChats();
                          Navigator.pushReplacementNamed(context, '/');
                        },
                        child: const Text('Continuar'),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      } else {
        return const Scaffold(
          body: Center(
            child: Text('Error inesperado'),
          ),
        );
      }
    });
  }
}
