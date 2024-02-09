//Minitaura de perfil que abre un ProfileHero
//La imagen es un CircleAvatar con un Hero que es un CachedNetworkImage

import 'package:chat_app/models/user.dart';
import 'package:chat_app/widgets/profilehero.dart';
import 'package:flutter/material.dart';

class ProfileThumbnail extends StatelessWidget {
  const ProfileThumbnail({super.key, required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            pageBuilder: (BuildContext context, _, __) {
              return ProfileHero(user: user);
            },
          ),
        );
      },
      child: Hero(
        tag: user.id,
        child: CircleAvatar(
          radius: 30,
          backgroundImage: Image.network(
            user.imageUrl,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return const CircularProgressIndicator();
            },
          ).image,
        ),
      ),
    );
  }
}
