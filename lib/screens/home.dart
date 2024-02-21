import 'package:chat_app/cubits/chat/chatcubit.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/repository/firestorerepository.dart';
import 'package:chat_app/repository/hiverepository.dart';
import 'package:chat_app/widgets/chattiles.dart';
import 'package:chat_app/widgets/contacts.dart';
import 'package:chat_app/widgets/contacttile.dart';
import 'package:chat_app/widgets/settings.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  final SearchController searchController = SearchController();
  String query = '';

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
    searchController.dispose();
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
          index < 2
              ? IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
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
            Contacts(),
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
      floatingActionButton: index < 2
          ? FloatingActionButton(
              onPressed: null,
              child: SearchAnchor(
                searchController: searchController,
                builder: (context, controller) {
                  return IconButton(
                    icon: const Icon(Icons.add_outlined),
                    onPressed: () {
                      controller.clear();
                      controller.openView();
                    },
                  );
                },
                viewHintText: 'Buscar usuario',
                isFullScreen: true,
                suggestionsBuilder: (context, controller) async {
                  //Obtener los items de firestore
                  query = controller.text;

                  final userId = await HiveRepository().getCurrentUserId();

                  if (userId == null) return List<ContactTile>.empty();

                  if (index == 0) {
                    final List<AppUser> items =
                        await HiveRepository().searchContacts(query);

                    return List<ListTile>.generate(
                      items.length,
                      (index) => ListTile(
                        leading: CircleAvatar(
                          backgroundImage: Image.network(
                            items[index].imageUrl,
                          ).image,
                        ),
                        title: Text(items[index].name),
                        subtitle: Text(items[index].info),
                        onTap: () {
                          //Crear chat
                          controller.clear();
                          context
                              .read<ChatCubit>()
                              .addChat(userId, items[index].id);
                          //Cerrar el buscador
                          controller.closeView(null);
                          //TODO: Navegar directamente al chat
                        },
                      ),
                    );
                  }

                  final List<AppUser> items =
                      await FirestoreRepository().searchUsers(
                    query,
                    userId,
                  );

                  return List<ContactTile>.generate(
                      items.length,
                      (index) => ContactTile(
                            contact: items[index],
                            isContact: false,
                          ));
                },
              ))
          : null,
    );
  }
}
