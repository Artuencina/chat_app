//AnimatedCrossfade que tiene un AppBar y un SearchBar que cambia al tocar el icono de busqueda

import 'package:flutter/material.dart';

class AnimatedSearchBar extends StatefulWidget {
  const AnimatedSearchBar(
      {super.key, required this.title, required this.onSearch});

  //TODO: Funcion de busqueda para cargar los elementos
  final String title;

  final Function(String) onSearch;

  @override
  State<AnimatedSearchBar> createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar> {
  bool isSearching = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      crossFadeState:
          isSearching ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 300),
      firstChild: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          widget.title,
          textAlign: TextAlign.center,
          key: ValueKey<String>(widget.title),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.search_outlined),
              onPressed: () {
                setState(
                  () {
                    isSearching = !isSearching;
                  },
                );
              })
        ],
      ),
      secondChild: Center(),
    );
  }
}
