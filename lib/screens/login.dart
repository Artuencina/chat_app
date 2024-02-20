//Pantalla de login

import 'package:chat_app/cubits/user/usercubit.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/repository/hiverepository.dart';
import 'package:chat_app/widgets/cardform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  //Para el paquete Wave
  final _backgroundColor = const Color.fromARGB(255, 2, 84, 226);

  final lightcolors = [
    const Color.fromARGB(255, 31, 109, 255),
    Colors.white,
  ];

  final darkcolors = [
    const Color.fromARGB(255, 0, 42, 120),
    Colors.black87,
  ];

  final durations = [7240, 8000];

  final _heights = [0.15, 0.80];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //El body es un stack con una card y un container.
      //Dentro de la card esta el form de login.
      //En el container, abajo esta el boton de registro, olvide mi contraseña
      //Debajo esta para iniciar sesion con google
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 400,
                child: Stack(
                  children: [
                    WaveWidget(
                      config: CustomConfig(
                          durations: durations,
                          colors:
                              Theme.of(context).brightness == Brightness.light
                                  ? lightcolors
                                  : darkcolors,
                          heightPercentages: _heights),
                      size: const Size(double.infinity, double.infinity),
                      waveAmplitude: 0,
                      backgroundColor: _backgroundColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 100,
                          ),
                          Text(
                            'Bienvenido!',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                  color: Colors.white,
                                ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Chat App es una aplicación de mensajería instantánea y privada que te permite comunicarte con tus amigos y familiares.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Colors.white,
                                ),
                            textAlign: TextAlign.justify,
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: 60,
                      left: 180,
                      child: Image.asset(
                        'assets/Icon.png',
                        fit: BoxFit.cover,
                        height: 56,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Divider(),
                    const Text('¿No tienes una cuenta?'),
                    ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                                  useSafeArea: true,
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) => const RegisterDialog())
                              .then(
                            (value) {
                              final userId = value as String?;

                              //Si el userId no es null, ir a la pantalla de edicion de perfil
                              if (userId != null) {
                                Navigator.of(context).pop();

                                Navigator.pushReplacementNamed(
                                    context, '/usercreate/$userId');
                              }
                            },
                          );
                        },
                        child: const Text('Registrarse')),
                    const SizedBox(
                      height: 36,
                    ),
                    const Text(
                      'También puedes iniciar sesión con:',
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'assets/images/Google_logo.png',
                          height: 44,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Positioned(top: 250, child: LoginForm()),
        ],
      ),
    );
  }
}

//SingleChildScrollView con form para registrarse
//Se muestra en un bottomdialog
class RegisterDialog extends StatefulWidget {
  const RegisterDialog({super.key});

  @override
  State<RegisterDialog> createState() => _RegisterDialogState();
}

class _RegisterDialogState extends State<RegisterDialog> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();

  //Funcion de registro
  Future<bool> _register(String email, String password) async {
    try {
      await _firebase.createUserWithEmailAndPassword(
          email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
      } else if (e.code == 'email-already-in-use') {}
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text('Registrarse', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(
            height: 16,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Correo electrónico',
                    hintText: 'ejemplo@ejemplo.com',
                    icon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor ingrese su correo electrónico';
                    }
                    if (!value.contains('@')) {
                      return 'Por favor ingrese un correo electrónico válido';
                    }

                    return null;
                  },
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  controller: emailController,
                  textCapitalization: TextCapitalization.none,
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    hintText: '********',
                    icon: Icon(Icons.lock),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor ingrese su contraseña';
                    }

                    //Validar que la contraseña tenga al menos 6 caracteres
                    if (value.length < 6) {
                      return 'La contraseña debe tener al menos 6 caracteres';
                    }

                    return null;
                  },
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  controller: passwordController,
                  textCapitalization: TextCapitalization.none,
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirmar contraseña',
                    hintText: '********',
                    icon: Icon(Icons.lock),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor confirme su contraseña';
                    }
                    if (value != passwordController.text) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                  onEditingComplete: () => FocusScope.of(context).unfocus(),
                  controller: confirmPasswordController,
                  textCapitalization: TextCapitalization.none,
                ),
                //Numero de telefono
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Número de teléfono',
                    hintText: '097...',
                    icon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor ingrese su número de teléfono';
                    }
                    return null;
                  },
                  onEditingComplete: () => FocusScope.of(context).unfocus(),
                  textCapitalization: TextCapitalization.none,
                ),
                const SizedBox(
                  height: 16,
                ),
                //Boton de cancelar o registarse
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _register(
                                  emailController.text, passwordController.text)
                              .then((value) {
                            if (value) {
                              final AppUser user = AppUser(
                                  id: _firebase.currentUser!.uid,
                                  email: emailController.text,
                                  name: emailController.text.split('@')[0],
                                  phone: phoneController.text,
                                  imageUrl:
                                      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png');

                              //Guardar el usuario
                              context.read<UserCubit>().updateUser(user);

                              //Iniciar sesion
                              _firebase.signInWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passwordController.text);

                              //Guardar los datos de inicio de sesion
                              HiveRepository().saveLoginData(
                                  emailController.text,
                                  passwordController.text);

                              //Ir a la pantalla de edicion de perfil con el id del usuario
                              Navigator.of(context).pop(user.id);
                            }
                          });
                        }
                      },
                      child: const Text('Registrarse'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
