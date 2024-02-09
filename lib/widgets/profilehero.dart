//Imagen de perfil con Hero que se abre y se ubica en el medio de la pantalla
//Solo aparece la foto, el nombre, descripcion y telefono. El resto es transparente

import 'package:chat_app/models/user.dart';
import 'package:flutter/material.dart';

class ProfileHero extends StatelessWidget {
  const ProfileHero({super.key, required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        color: Colors.black.withOpacity(0.8),
        constraints: const BoxConstraints.expand(),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.9),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 30,
                ),
                Hero(
                  tag: user.id,
                  child: CircleAvatar(
                    //backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(user.imageUrl),
                    radius: 100,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  user.info,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  user.phone,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
