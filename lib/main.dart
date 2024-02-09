import 'package:chat_app/cubits/chat/chatcubit.dart';
import 'package:chat_app/cubits/user/usercubit.dart';
import 'package:chat_app/dependency.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/router.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

final ThemeData theme = ThemeData(
  primaryColor: Colors.blue[100],
  colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue[100]!,
      brightness: Brightness.light,
      background: Colors.white),
  textTheme: GoogleFonts.workSansTextTheme(),
  fontFamily: GoogleFonts.workSans().fontFamily,
);

//Tema oscuro
final ThemeData darkTheme = ThemeData(
  primaryColor: const Color.fromARGB(255, 0, 42, 106),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 0, 29, 74),
    brightness: Brightness.dark,
    background: Colors.black,
  ),
  textTheme: GoogleFonts.workSansTextTheme()
      .apply(bodyColor: Colors.white, displayColor: Colors.white),
  fontFamily: GoogleFonts.workSans().fontFamily,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 0, 42, 106),
      foregroundColor: Colors.white,
    ),
  ),
);

String initialRoute = '/';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  Routes.configureRoutes();

  await initializeDependencies();

  var box = await Hive.openBox('settings');
  await Hive.openBox('users');

  final email = box.get('email');
  final password = box.get('password');

  bool darkthemeMode = box.get('themeMode', defaultValue: false);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  initialRoute = await autoLogin(email, password);

  //Esperar un segundo para que se muestre el splash screen

  await Future.delayed(const Duration(seconds: 1));

  FlutterNativeSplash.remove();

  runApp(
    EasyDynamicThemeWidget(
      initialThemeMode: darkthemeMode ? ThemeMode.dark : ThemeMode.light,
      child: const MyApp(),
    ),
  );
}

//Funcion para obtener la ruta inicial dependiendo si el usuario esta logeado
//Para ello verifica en el box settings el valor user y password,
//Si user es null, entonces el usuario no esta logeado y se redirige a la pantalla de login
//Si user no es null, entonces con firebase lo intenta logear automaticamente
//y si lo logra, redirige a la pantalla de home
Future<String> autoLogin(String? email, String? password) async {
  if (email == null || password == null) {
    return '/login';
  } else {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return '/';
    } on FirebaseAuthException catch (e) {
      print(e);
      return '/login';
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserCubit>(
          create: (context) =>
              sl()..getUserById(FirebaseAuth.instance.currentUser!.uid),
        ),
        BlocProvider<ChatCubit>(
          create: (context) => sl()..loadChats(),
        ),
      ],
      child: MaterialApp(
        initialRoute: initialRoute,
        theme: theme,
        darkTheme: darkTheme,
        themeMode: EasyDynamicTheme.of(context).themeMode,
        onGenerateRoute: Routes.router.generator,
      ),
    );
  }
}
