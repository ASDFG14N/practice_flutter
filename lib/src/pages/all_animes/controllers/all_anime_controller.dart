import 'package:flutter/material.dart';
import 'package:ninja_otaku_app/src/models/anime_poster.dart';
import 'package:ninja_otaku_app/src/pages/details/view_page.dart';

class AllAnimeController {
  BuildContext? context;

  Future? init(BuildContext context) {
    this.context = context;
    return null;
  }

  void goToDetail(BuildContext context, AnimePoster anime) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ViewAnimePage(anime: anime),
      ),
    );
  }

  void addToRecentlyWatched(List<AnimePoster> animeList, int index) async {
    await addToRecentlyWatchedAnime(animeList[index]);
  }
}
