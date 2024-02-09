import 'package:hive_flutter/hive_flutter.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class AppUser {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String info;
  @HiveField(4)
  String imageUrl;
  @HiveField(5)
  String phone;

  AppUser(
      {required this.id,
      required this.name,
      required this.email,
      required this.imageUrl,
      this.info = '',
      this.phone = ''});
}
