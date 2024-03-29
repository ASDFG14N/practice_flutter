import 'package:flutter/material.dart';
import 'package:ninja_otaku_app/src/utils/my_colors.dart';
import 'package:ninja_otaku_app/src/widgets/nothing_show.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColors.myCustomPageColorPrimaryTwo,
        appBar: AppBar(
          title: const Text("Notificaciones"),
          backgroundColor: MyColors.myCustomPageColorPrimaryOne,
        ),
        body: nothingToShow(
          Icons.notifications,
          "Por ahora no tienes notificaciones",
        ),
      ),
    );
  }
}
