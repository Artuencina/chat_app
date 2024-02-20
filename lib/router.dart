import 'package:chat_app/screens/chat.dart';
import 'package:chat_app/screens/home.dart';
import 'package:chat_app/screens/login.dart';
import 'package:chat_app/screens/profileedit.dart';
import 'package:fluro/fluro.dart';

class Routes {
  static FluroRouter router = FluroRouter();

  static void configureRoutes() {
    router.define('/login',
        handler: Handler(
          handlerFunc: (context, parameters) => LoginScreen(),
        ));

    router.define('/',
        handler: Handler(
          handlerFunc: (context, parameters) => const HomeScreen(),
        ));

    router.define('/chat/:id',
        transitionType: TransitionType.inFromRight,
        handler: Handler(
          handlerFunc: (context, parameters) => ChatScreen(
            chatId: parameters['id']![0],
          ),
        ));
    router.define(
      '/useredit/:id',
      handler: Handler(
        handlerFunc: (context, parameters) => ProfileEditScreen(
          userId: parameters['id']![0],
        ),
      ),
    );
    router.define(
      '/usercreate/:id',
      handler: Handler(
        handlerFunc: (context, parameters) => ProfileEditScreen(
          userId: parameters['id']![0],
          firstTime: true,
        ),
      ),
    );
  }
}
