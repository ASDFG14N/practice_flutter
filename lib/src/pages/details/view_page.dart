import 'package:flutter/material.dart';
import 'package:ninja_otaku_app/src/models/anime_poster.dart';
import 'package:ninja_otaku_app/src/network/network_requets.dart';
import 'package:ninja_otaku_app/src/utils/my_colors.dart';
import 'package:ninja_otaku_app/src/widgets/sniper_custom.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewAnimePage extends StatefulWidget {
  final AnimePoster anime;

  const ViewAnimePage({
    super.key,
    required this.anime,
  });

  @override
  State<ViewAnimePage> createState() => _ViewAnimePageState();
}

class _ViewAnimePageState extends State<ViewAnimePage> {
  String synopsis = "";
  String? status = "";
  String year = "";
  List<String> genres = [];
  List episodes = [];
  List<bool?> episodeChecked = [];
  List<String> listWatchedEpisodes = [];
  Map<String, bool> listWatchedEpisodesMap = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    NetworkRequest.getAnimeData(widget.anime.title, widget.anime.href)
        .then((data) {
      setState(() {
        synopsis = data!.synopsis;
        status = data.status;
        year = data.year!;
        genres = data.genres;
        episodes = data.episodes;
        episodeChecked = data.episodeChecked;
        isLoading = false;
        _loadWatchedEpisodesList(widget.anime.title);
      });
    });
  }

  void _loadWatchedEpisodesList(String animeTitle) async {
    listWatchedEpisodesMap = await getWatchedEpisodesMap(animeTitle);
    listWatchedEpisodes.clear();

    for (var episodeTitle in listWatchedEpisodesMap.keys) {
      listWatchedEpisodes.add(episodeTitle);
    }
    _updateEpisodeCheckedFromMap();
  }

  void _updateEpisodeCheckedFromMap() {
    for (var index = 0; index < episodes.length; index++) {
      String episodeTitle = "Episodio ${episodes.length - index}";
      bool isWatched = listWatchedEpisodesMap.containsKey(episodeTitle) &&
          listWatchedEpisodesMap[episodeTitle] == true;
      episodeChecked[index] = isWatched;
    }
  }

  void _addMyList() async {
    await addToFavorites(widget.anime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF394988),
      body: _getBodyOfPage(),
    );
  }

  Widget _getBodyOfPage() {
    if (isLoading) {
      return Stack(
        children: [
          _allBody(),
          Container(
            width: double.infinity,
            color: Colors.black.withOpacity(0.7),
          ),
          Center(
            child: spinnerCustom(),
          )
        ],
      );
    } else {
      return _allBody();
    }
  }

  Widget _allBody() {
    return CustomScrollView(
      slivers: <Widget>[
        _appBarCustom(),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return _listEpisodes(
                  "Episodio ${episodes.length - index}", index);
            },
            childCount: episodes.length,
          ),
        ),
      ],
    );
  }

  Widget _appBarCustom() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: const Color.fromARGB(226, 0, 0, 0),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          decoration: const BoxDecoration(
            color: Color(0xFF000b31),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Episodios",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_up,
                color: Colors.white,
                size: 28,
              )
            ],
          ),
        ),
      ),
      expandedHeight: MediaQuery.of(context).size.height - 33,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.anime.poster),
              fit: BoxFit.cover,
              colorFilter: const ColorFilter.mode(
                Colors.black87,
                BlendMode.darken,
              ),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 185,
                      child: Image.network(widget.anime.poster),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        color: _colorStatus(),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            status!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "- ${widget.anime.title} -",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              _animeDetailRow(
                "95% match",
                widget.anime.type,
                year,
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 15),
                child: SizedBox(
                  height: 22,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: genres.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: const EdgeInsets.only(right: 15),
                        decoration: BoxDecoration(
                          color: MyColors.myCustomColorRed,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Text(
                              genres[index],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              //Descripcion del anime
              const SizedBox(height: 15),
              _animeDescription(synopsis),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(right: 15, left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Icon(
                          Icons.edit_note_rounded,
                          color: Colors.grey,
                          size: 30,
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Calificar",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Icon(
                          Icons.favorite_outline_rounded,
                          color: Colors.grey,
                          size: 30,
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Me Gusta",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Icon(
                          Icons.chat_rounded,
                          color: Colors.grey,
                          size: 30,
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Reseñas",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.star_outline_rounded),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                    ),
                    SizedBox(width: 15),
                    Text(
                      "Añadido a favoritos",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                backgroundColor: MyColors.myCustomPageColorPrimaryTwo,
                showCloseIcon: true,
                closeIconColor: Colors.white,
              ),
            );
            _addMyList();
          },
        ),
      ],
    );
  }

  Widget _animeDetailRow(String viewPercentage, String type, String anio) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          viewPercentage,
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        Row(
          children: [
            Container(
              width: 2,
              color: MyColors.myCustomColorRed,
              height: 10,
              margin: const EdgeInsets.only(right: 4),
            ),
            Text(
              type,
              style: TextStyle(
                color: MyColors.myCustomColorRed,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: Text(
              anio,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _animeDescription(String synopsis) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, left: 15),
      child: Text(
        maxLines: 9,
        overflow: TextOverflow.ellipsis,
        synopsis,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w300,
          wordSpacing: 1,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _listEpisodes(String episode, int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 10),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black38,
        ),
        child: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () async {
                  setState(() {
                    final animeTitle = widget.anime.title;
                    episodeChecked[index] = true;
                    listWatchedEpisodes.add(episode);
                    saveWatchedEpisodesList(animeTitle, listWatchedEpisodes);
                  });
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return Center(
                        child: spinnerCustom(),
                      );
                    },
                  );
                  try {
                    String? urlServer =
                        await NetworkRequest.getServerVideo(episodes[index]);
                    if (urlServer != null) {
                      Future.delayed(Duration.zero, () {
                        Navigator.of(context).pop();
                        launchUrl(
                          Uri.parse(urlServer),
                          mode: LaunchMode.platformDefault,
                        );
                      });
                    } else {
                      Future.delayed(Duration.zero, () {
                        Navigator.of(context).pop();
                      });
                    }
                  } catch (error) {
                    Future.delayed(Duration.zero, () {
                      Navigator.of(context).pop();
                    });
                  }
                },
                child: videoPlayer(),
              ),
              //# del capitulo
              _episodeNumber(episode),
              //checkbox
              _chekVideo(index)
            ],
          ),
        ),
      ),
    );
  }

  Widget _chekVideo(int index) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: Checkbox(
          fillColor: MaterialStateProperty.all(MyColors.myCustomColorRed),
          value: episodeChecked[index],
          onChanged: null,
        ),
      ),
    );
  }

  Widget videoPlayer() {
    return Stack(
      children: [
        SizedBox(
          height: 100,
          width: 150,
          child: Image.network(widget.anime.poster),
        ),
        Container(
          height: 100,
          width: 150,
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.4)),
        ),
        Positioned(
          top: 30,
          left: 57,
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.4),
              border: Border.all(
                width: 2,
                color: Colors.white,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _episodeNumber(String episode) {
    return SizedBox(
      width: 100,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Text(
          episode,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Color _colorStatus() {
    if (status!.toLowerCase() == "en emision") {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }
}
