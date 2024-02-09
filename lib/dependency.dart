//Get_it para inyeccion de dependencias

import 'package:chat_app/cubits/chat/chatcubit.dart';
import 'package:chat_app/cubits/chat/chatstate.dart';
//import 'package:chat_app/cubits/message/messagecubit.dart';
//import 'package:chat_app/cubits/message/messagestate.dart';
//import 'package:chat_app/cubits/user/usercubit.dart';
//import 'package:chat_app/cubits/user/userstate.dart';
import 'package:chat_app/repository/hiverepository.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  final dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);
  //Repositorio
  final hiveRepository = HiveRepository();
  hiveRepository.registerAdapters();

  sl.registerSingleton(hiveRepository);

  //Cubits
  sl.registerSingleton(ChatCubit(hiveRepository: sl()));
  //sl.registerSingleton(MessageCubit(hiveRepository: sl()));
  //sl.registerSingleton(UserCubit(hiveRepository: sl()));

  //Estados
  //sl.registerFactory<ChatsState>(() => ChatsInitial());
  //sl.registerFactory<MessageState>(() => MessageInitial());
  //sl.registerFactory<UserState>(() => UserInitial());
}
