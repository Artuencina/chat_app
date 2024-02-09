import 'package:chat_app/cubits/user/usercubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

final _firebase = FirebaseAuth.instance;

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool recordarme = false;

  //Funciones de login
  Future<bool> _login(String email, String password) async {
    try {
      await _firebase.signInWithEmailAndPassword(
          email: email, password: password);

      //Utilizando Hive, vamos a guardar si el usuario marco el checkbox de recordar
      if (recordarme) {
        var box = Hive.box('settings');
        box.put('email', email);
        box.put('password', password);
      } else {
        await Hive.openBox('settings').then((value) {
          value.delete('email');
          value.delete('password');
        });
      }

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
      } else if (e.code == 'wrong-password') {}
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.84,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Iniciar Sesión',
                    style: Theme.of(context).textTheme.titleLarge),
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
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    hintText: '********',
                    icon: Icon(Icons.lock),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor ingrese su contraseña';
                    }
                    return null;
                  },
                ),

                const SizedBox(
                  height: 16,
                ),
                //Recordarme
                CheckboxListTile(
                  secondary: const Icon(Icons.remember_me),
                  value: recordarme,
                  onChanged: (value) {
                    setState(() {
                      recordarme = value!;
                    });
                  },
                  title: const Text(
                    'Recordarme',
                  ),
                ),

                //Texto con link a la pantalla de recuperar contraseña
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/forgotpassword');
                  },
                  child: const Text('Olvidé mi contraseña'),
                ),

                //Boton de inicio de sesion
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _login(emailController.text, passwordController.text)
                          .then((value) => {
                                if (value)
                                  {
                                    //TODO: obtener datos de usuario desde firebase

                                    Navigator.pushReplacementNamed(context, '/')
                                  }
                                else
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Usuario o contraseña incorrectos'),
                                      ),
                                    )
                                  }
                              });
                    }
                  },
                  child: const Text('Iniciar Sesión'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
