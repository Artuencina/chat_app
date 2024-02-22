//Widget para administrar las configuraciones de la aplicación

import 'package:chat_app/cubits/chat/chatcubit.dart';
import 'package:chat_app/cubits/user/usercubit.dart';
import 'package:chat_app/cubits/user/userstate.dart';
import 'package:chat_app/widgets/profilehero.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

final _firebase = FirebaseAuth.instance;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  //Tema
  late bool darkMode;

  //Notificaciones
  bool notifications = true;

  Future<void> signOut() async {
    //Eliminar los datos de inicio de sesión
    await _firebase.signOut();
  }

  @override
  Widget build(BuildContext context) {
    darkMode = EasyDynamicTheme.of(context).themeMode == ThemeMode.dark;

    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserReady) {
          return SingleChildScrollView(
            //Configuraciones
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              //Primero mostrar un listtile con el usuario actual
              children: [
                ListTile(
                  leading: Hero(
                    tag: state.currentUser!.id,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        state.currentUser!.imageUrl,
                      ),
                    ),
                  ),
                  title: Text(state.currentUser!.name),
                  subtitle: const Text('Ver perfil'),
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        opaque: false,
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        pageBuilder: (context, _, __) {
                          return ProfileHero(user: state.currentUser!);
                        },
                      ),
                    );
                  },
                ),
                const Divider(
                  indent: 20,
                  endIndent: 20,
                ),
                //Tema
                SwitchListTile(
                  secondary: const Icon(Icons.nightlight_round),
                  title: const Text('Modo oscuro'),
                  value: darkMode,
                  onChanged: (value) {
                    setState(() {
                      darkMode = value;
                    });

                    //Cambiar el tema
                    EasyDynamicTheme.of(context).changeTheme(dark: darkMode);

                    //Guardar en el box settings el valor del tema
                    Hive.openBox('settings').then((value) {
                      value.put('themeMode', darkMode);
                    });
                  },
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text(
                    'Perfil',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),

                //Editar perfil
                ListTile(
                  leading: const Icon(Icons.person_rounded),
                  title: const Text('Editar perfil'),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed('/useredit/${state.currentUser!.id}');
                  },
                ),

                //Cambiar contraseña
                ListTile(
                  leading: const Icon(Icons.lock_rounded),
                  title: const Text('Cambiar contraseña'),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  onTap: () {
                    //Cambiar contraseña
                  },
                ),

                //Notificaciones
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    'Notificaciones',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),

                SwitchListTile(
                  secondary: const Icon(Icons.notifications_rounded),
                  title: const Text('Activar notificaciones'),
                  value: notifications,
                  onChanged: (value) {
                    setState(() {
                      notifications = value;
                    });
                  },
                ),

                //Lenguaje
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    'Lenguaje',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.language_rounded),
                  title: const Text('Cambiar lenguaje'),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  onTap: () {
                    //Cambiar lenguaje
                  },
                ),

                //Borrar cuenta
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    'Cuenta',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.block_rounded),
                  title: const Text('Usuarios bloqueados'),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  onTap: () {
                    //Usuarios bloqueados
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.delete_rounded, color: Colors.red),
                  title: const Text('Borrar cuenta',
                      style: TextStyle(color: Colors.red)),
                  onTap: () {
                    //Borrar cuenta
                  },
                ),
                //Cerrar sesión
                ListTile(
                  leading: const Icon(Icons.exit_to_app_rounded),
                  title: const Text('Cerrar sesión'),
                  onTap: () {
                    //Mostrar dialogo de confirmación
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Cerrar sesión'),
                          content: const Text(
                              '¿Está seguro que desea cerrar sesión?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<UserCubit>().signOut();
                                //Cerrar sesión
                                signOut();
                                Navigator.pushReplacementNamed(
                                    context, '/login');
                              },
                              child: const Text('Cerrar sesión'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),

                //Al fondo mostrar la version de la app
                const Center(
                  child: Text('Versión 1.0.0'),
                ),
              ],
            ),
          );
        } else if (state is UserError) {
          return Center(
            child: Text(state.message),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
