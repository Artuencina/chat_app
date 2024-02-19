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
  @HiveField(6)
  final String imagePath; //Ruta de la imagen local

  const AppUser(
      {required this.id,
      required this.name,
      required this.email,
      required this.imageUrl,
      this.imagePath = '',
      this.info = '',
      this.phone = ''});

  @override
  List<Object?> get props =>
      [id, name, email, imageUrl, info, phone, imagePath];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'info': info,
      'imageUrl': imageUrl,
      'phone': phone,
      'imagePath': imagePath,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      info: map['info'],
      imageUrl: map['imageUrl'],
      phone: map['phone'],
      imagePath: map['imagePath'],
    );
  }

  //Metodo copyWith para actualizar el usuario
  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    String? info,
    String? imageUrl,
    String? phone,
    String? imagePath,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      info: info ?? this.info,
      imageUrl: imageUrl ?? this.imageUrl,
      phone: phone ?? this.phone,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
