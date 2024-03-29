import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:ninja_otaku_app/src/models/anime_poster.dart';
import 'package:ninja_otaku_app/src/pages/home/controllers/home_page_controller.dart';
import 'package:ninja_otaku_app/src/utils/my_colors.dart';
import 'package:ninja_otaku_app/src/widgets/nothing_show.dart';

class MyList extends StatefulWidget {
  const MyList({super.key});

  @override
  State<MyList> createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  final HomePageController _con = HomePageController();
  List<AnimePoster> listAnimeFavorite = [];

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context);
    });
    loadFavoriteAnimeList();
  }

  Future<void> loadFavoriteAnimeList() async {
    List<AnimePoster> favorites = await getFavorites();
    setState(() {
      listAnimeFavorite = favorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColors.myCustomPageColorPrimaryTwo,
        appBar: AppBar(
          title: const Row(
            children: [
              Text("Mis favoritos"),
            ],
          ),
          backgroundColor: MyColors.myCustomPageColorPrimaryOne,
          leading: const Icon(
            Icons.star_rounded,
            color: Colors.amber,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: listAnimeFavorite.isNotEmpty
            ? Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: ListView.builder(
                  itemCount: listAnimeFavorite.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _animeFavorite(listAnimeFavorite[index], index);
                  },
                ),
              )
            : nothingToShow(
                Icons.star_rounded,
                "Animes, OVAS y películas que agreges a tu lista, aparecerán aquí",
              ),
      ),
    );
  }

  Widget _animeFavorite(AnimePoster anime, int index) {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.myCustomPageColorPrimaryOne,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(
        left: 15,
        right: 15,
        top: 15,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              child: Container(
                width: 100,
                height: 140, //anime.poster
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(anime.poster),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              onTap: () {
                _con.goToViewAnime(listAnimeFavorite, index);
              },
            ),
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  width: 140,
                  child: Text(
                    anime.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      width: 2,
                      color: MyColors.myCustomColorRed,
                      height: 10,
                      margin: const EdgeInsets.only(right: 4),
                    ),
                    Text(
                      anime.type,
                      style: TextStyle(
                        color: MyColors.myCustomColorRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  setState(() {
                    listAnimeFavorite.removeAt(index);
                    removeAnimeFromFavorites(index);
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: Icon(
                    Icons.delete_rounded,
                    color: MyColors.myCustomColorRed,
                    size: 25,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
