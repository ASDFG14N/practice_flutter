import 'package:flutter/material.dart';
import 'package:ninja_otaku_app/src/models/anime_poster.dart';

class AnimeCell extends StatelessWidget {
  const AnimeCell({super.key, required this.anime});
  final AnimePoster anime;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(anime.poster),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.black45,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              anime.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
