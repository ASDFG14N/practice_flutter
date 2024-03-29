import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:ninja_otaku_app/src/data/all_animes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnimePoster {
  final String title;
  final String poster;
  final String href;
  final String type;

  AnimePoster({
    required this.title,
    required this.poster,
    required this.href,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'poster': poster,
      'href': href,
      'type': type,
    };
  }

  factory AnimePoster.fromJson(Map<String, dynamic> json) {
    return AnimePoster(
      title: json['title'],
      poster: json['poster'],
      href: json['href'],
      type: json['type'],
    );
  }
}

Future<void> loadJson() async {
  String jsonString = await rootBundle.loadString('assets/animes.json');
  List<dynamic> jsonList = jsonDecode(jsonString);

  for (var item in jsonList) {
    AnimePoster animePoster = AnimePoster(
      title: item['title'],
      poster: item['poster'],
      href: item['href'],
      type: item['type'],
    );
    allAnimes.add(animePoster);
  }
}

/*
=============================================================================== 
=============================================================================== 
*/

Future<void> addToFavorites(AnimePoster newItem) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<String> favoritesJson = prefs.getStringList('favorites') ?? [];

  String newItemJson = jsonEncode(newItem.toJson());

  favoritesJson.add(newItemJson);

  await prefs.setStringList('favorites', favoritesJson);
}

Future<List<AnimePoster>> getFavorites() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<String> favoritesJson = prefs.getStringList('favorites') ?? [];

  List<AnimePoster> favorites = favoritesJson.map((json) {
    Map<String, dynamic> itemMap = jsonDecode(json);
    return AnimePoster.fromJson(itemMap);
  }).toList();

  return favorites;
}

Future<void> removeAnimeFromFavorites(int index) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Obtén la lista actual de favoritos desde SharedPreferences
  List<AnimePoster> favorites = await getFavorites();

  if (index >= 0 && index < favorites.length) {
    favorites.removeAt(index);

    List<String> favoritesJson =
        favorites.map((anime) => jsonEncode(anime.toJson())).toList();

    // Guarda la lista actualizada en SharedPreferences
    await prefs.setStringList('favorites', favoritesJson);
  }
}

/*
=============================================================================== 
=============================================================================== 
*/

Future<void> addToRecentlyWatchedAnime(AnimePoster newItem) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<String> recentlyWatchedAnimeJson =
      prefs.getStringList('recentlyViewed') ?? [];

  final newItemJson = jsonEncode(newItem.toJson());
  if (recentlyWatchedAnimeJson.contains(newItemJson)) {
    return;
  }

  recentlyWatchedAnimeJson.add(newItemJson);

  if (recentlyWatchedAnimeJson.length > 10) {
    recentlyWatchedAnimeJson.removeAt(0);
  }

  await prefs.setStringList('recentlyViewed', recentlyWatchedAnimeJson);
}

Future<List<AnimePoster>> getRecentlyWatchedAnime() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<String> recentlyWatchedAnimeJson =
      prefs.getStringList('recentlyViewed') ?? [];

  List<AnimePoster> recentlyWatchedAnime = recentlyWatchedAnimeJson.map((json) {
    Map<String, dynamic> itemMap = jsonDecode(json);
    return AnimePoster.fromJson(itemMap);
  }).toList();

  return recentlyWatchedAnime;
}

/*
=============================================================================== 
=============================================================================== 
*/

Future<void> saveWatchedEpisodesList(
    String animeTitle, List<String> listWatchedEpisodes) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<String> stringValues = listWatchedEpisodes;

  await prefs.setStringList(animeTitle, stringValues);
}

Future<Map<String, bool>> getWatchedEpisodesMap(String animeTitle) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<String> stringValues = prefs.getStringList(animeTitle) ?? [];

  Map<String, bool> watchedEpisodesMap = {};
  for (String episodeTitle in stringValues) {
    watchedEpisodesMap[episodeTitle] = true;
  }
  return watchedEpisodesMap;
}
