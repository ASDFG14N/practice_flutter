import 'package:flutter/material.dart';
import 'package:ninja_otaku_app/src/models/anime_poster.dart';
import 'package:ninja_otaku_app/src/pages/details/my_list.dart';
import 'package:ninja_otaku_app/src/pages/details/view_page.dart';

class HomePageController {
  BuildContext? context;
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  Future? init(BuildContext context) {
    this.context = context;
    return null;
  }

  void openDrawerCustom() {
    key.currentState!.openDrawer();
  }

  void goToViewAnime(List<AnimePoster> animeList, int index) {
    Navigator.push(
      context!,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            ViewAnimePage(anime: animeList[index]),
      ),
    );
  }

  void goToMyList() {
    Navigator.push(
      context!,
      MaterialPageRoute(
        builder: (context) => const MyList(),
      ),
    );
  }

  void addToRecentlyWatched(List<AnimePoster> animeList, int index) async {
    await addToRecentlyWatchedAnime(animeList[index]);
  }
}
