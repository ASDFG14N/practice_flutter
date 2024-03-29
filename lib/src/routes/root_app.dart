import 'package:flutter/material.dart';
import 'package:ninja_otaku_app/src/pages/home/home_page.dart';
import 'package:ninja_otaku_app/src/pages/notifications/notifications_page.dart';
import 'package:ninja_otaku_app/src/pages/all_animes/all_anime_page.dart';
import 'package:ninja_otaku_app/src/widgets/bottom_item.dart';

class RootApp extends StatefulWidget {
  const RootApp({super.key});

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int activeTap = 0;
  final List<IconData> items = [
    Icons.home,
    Icons.search_rounded,
    Icons.notifications
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: getBottomNavigationBar(),
        body: getBody(),
      ),
    );
  }

  Widget getBody() {
    return IndexedStack(
      index: activeTap,
      children: const [
        HomePageNinjaOtaku(),
        AllAnimePage(),
        NotificationsPage(),
      ],
    );
  }

  Widget getBottomNavigationBar() {
    return Container(
      height: 80,
      decoration: const BoxDecoration(color: Color(0xFF000b31)),
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            items.length,
            (index) {
              final IconData icon = items[index];
              return BottomItem(
                icon: icon,
                isActive: index == activeTap,
                onPressed: () {
                  setState(() {
                    activeTap = index;
                  });
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
