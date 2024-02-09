import 'package:chat_app/widgets/chattiles.dart';
import 'package:chat_app/widgets/settings.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();

  int index = 0;
  List<String> titles = ['Chats', 'Contactos', 'Ajustes'];

  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      setState(() {
        index = _pageController.page!.round();
      });
    });
  }

  //Cuando se cierra la aplicacion, cerrar el pagecontroller
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          titles[index],
          textAlign: TextAlign.center,
          key: ValueKey<String>(titles[index]),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          index == 0
              ? IconButton(
                  onPressed: () {
                    //Buscar chat
                  },
                  icon: const Icon(Icons.search_rounded),
                )
              : const SizedBox.shrink(),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          //El color depende del tema
          color: EasyDynamicTheme.of(context).themeMode == ThemeMode.dark
              ? Colors.black
              : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: PageView(
          controller: _pageController,
          onPageChanged: (i) {
            setState(() {
              index = i;
            });
          },
          children: const [
            Chats(),
            Center(child: Text('Contactos')),
            SettingsScreen(),
          ],
        ),
      ),
      bottomNavigationBar: SalomonBottomBar(
        itemPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        backgroundColor: Theme.of(context).primaryColor,
        currentIndex: index,
        curve: Curves.easeOutExpo,
        duration: const Duration(seconds: 1),
        onTap: (i) {
          setState(() {
            index = i;
            _pageController.jumpToPage(i);
          });
        },
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.chat_rounded),
            title: const Text('Chats'),
            selectedColor: Colors.blueAccent,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.people_alt_rounded),
            title: const Text('Contactos'),
            selectedColor: Colors.redAccent,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.settings_rounded),
            title: const Text('Ajustes'),
            selectedColor: Colors.purpleAccent,
          ),
        ],
      ),
      floatingActionButton: index == 0
          ? FloatingActionButton(
              onPressed: () {
                //Abrir chat
              },
              child: const Icon(Icons.add_rounded),
            )
          : null,
    );
  }
}
