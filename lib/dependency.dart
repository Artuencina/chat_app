//Get_it para inyeccion de dependencias

import 'package:chat_app/cubits/chat/chatcubit.dart';
import 'package:chat_app/cubits/user/usercubit.dart';
import 'package:chat_app/repository/firestorerepository.dart';
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

  final firestoreRepository = FirestoreRepository();

  sl.registerSingleton(hiveRepository);

  sl.registerSingleton(firestoreRepository);

  //Cubits
  sl.registerSingleton(ChatCubit(hiveRepository: sl()));
  //sl.registerSingleton(MessageCubit(hiveRepository: sl()));
  sl.registerSingleton(
      UserCubit(hiveRepository: sl(), firestoreRepository: sl()));
}
