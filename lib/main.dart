import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData theme = ThemeData(
  primaryColor: Colors.blue[100],
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue[100]!),
  textTheme: GoogleFonts.workSansTextTheme(),
  fontFamily: GoogleFonts.workSans().fontFamily,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Routes.configureRoutes();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MaterialApp(
      initialRoute: '/login',
      theme: theme,
      onGenerateRoute: Routes.router.generator,
    ),
  );
}
