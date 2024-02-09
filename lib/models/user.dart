import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class AppUser extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String info;
  @HiveField(4)
  final String imageUrl;
  @HiveField(5)
  final String phone;

  const AppUser(
      {required this.id,
      required this.name,
      required this.email,
      required this.imageUrl,
      this.info = '',
      this.phone = ''});

  @override
  List<Object?> get props => [id, name, email, imageUrl, info, phone];
}
