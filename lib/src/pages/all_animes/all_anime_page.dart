import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:ninja_otaku_app/src/data/all_animes.dart';
import 'package:ninja_otaku_app/src/models/anime_poster.dart';
import 'package:ninja_otaku_app/src/network/network_requets.dart';
import 'package:ninja_otaku_app/src/pages/all_animes/controllers/all_anime_controller.dart';
import 'package:ninja_otaku_app/src/pages/all_animes/grid_cell.dart';
import 'package:ninja_otaku_app/src/utils/my_colors.dart';
import 'package:ninja_otaku_app/src/widgets/load_animes.dart';
import 'package:ninja_otaku_app/src/widgets/nothing_show.dart';

class AllAnimePage extends StatefulWidget {
  const AllAnimePage({super.key});

  @override
  State<AllAnimePage> createState() => _AllAnimePageState();
}

class _AllAnimePageState extends State<AllAnimePage> {
  final AllAnimeController _con = AllAnimeController();

  final controllerText = TextEditingController();

  List<AnimePoster> allAnimesList = [];
  List<AnimePoster> originalAllAnimesList = [];

  bool isLoading = true;
  bool error = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context);
      NetworkRequest.fetchAllAnimes().then((data) async {
        await loadJson(); //agregamos esta linea se puede borrar luego
        setState(() {
          allAnimesList = data;
          allAnimesList.addAll(allAnimes);
          isLoading = false;
          originalAllAnimesList = allAnimesList;
        });
      }).catchError((e) {
        setState(() {
          error = true;
          isLoading = false;
        });
      });

      // NetworkRequest.fetchAllAnimesBlock().then((data) {
      //   NetworkRequest.fetchAllAnimesBlock().then((data) {
      //     final jsonData = jsonEncode(data);

      //     // Parsea la cadena JSON en una lista de mapas.
      //     final jsonList = jsonDecode(jsonData) as List;

      //     // Itera sobre la lista de mapas e imprime cada mapa por separado.
      //     for (final jsonMap in jsonList) {
      //       final segment = jsonEncode(jsonMap);
      //       debugPrint("$segment,");
      //     }
      //   }).catchError((e) {
      //     print(e);
      //   });
      // }).catchError((e) {
      //   print(e);
      // });
    });
  }

  void filterAnimes(String query) {
    setState(() {
      if (query.isEmpty) {
        allAnimesList = originalAllAnimesList;
      } else {
        allAnimesList = originalAllAnimesList
            .where((anime) =>
                anime.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _reloadData() {
    setState(() {
      isLoading = true;
      error = false;
    });

    NetworkRequest.fetchAllAnimes().then((data) {
      setState(() {
        allAnimesList = data;
        isLoading = false;
        originalAllAnimesList = allAnimesList;
      });
    }).catchError((e) {
      setState(() {
        error = true;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColors.myCustomPageColorPrimaryTwo,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(109),
        child: SafeArea(
          child: AppBar(
            elevation: 15,
            backgroundColor: const Color(0xFF000b31),
            flexibleSpace: Column(
              children: [
                const SizedBox(height: 28),
                _textFieldSearch(context),
              ],
            ),
          ),
        ),
      ),
      body: _getBodyOfPage(),
    );
  }

  //====================
  //Widgets de la pagina
  //====================
  Widget _textFieldSearch(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 25, right: 25),
      child: TextField(
        controller: controllerText,
        onChanged: filterAnimes,
        onSubmitted: (search) {
          setState(() {
            isLoading = true;
          });
          NetworkRequest.searchAnimeWriting(search).then((data) {
            setState(() {
              if (search.isEmpty) {
                allAnimesList = originalAllAnimesList;
              } else {
                allAnimesList = data.toList();
              }
              isLoading = false;
            });
          });
        },
        autofocus: false,
        cursorColor: Colors.white,
        style: const TextStyle(color: Colors.white, fontSize: 17),
        decoration: InputDecoration(
          hintText: "Buscar",
          prefixIcon: const Icon(Icons.search, color: Colors.white),
          hintStyle: const TextStyle(fontSize: 17, color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.white),
          ),
          contentPadding: const EdgeInsets.all(15),
        ),
      ),
    );
  }

  Widget _getBodyOfPage() {
    if (isLoading) {
      return loadAnimes();
    } else if (error) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          nothingToShow(
              Icons.wifi_off_rounded, "Verifica tu conexión a internet"),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors.myCustomColorRed,
              //redondear el boton
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              _reloadData();
            },
            child: const Text(
              "Recargar",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      );
    } else {
      return _gridView(allAnimesList);
    }
  }

  Widget _gridView(List<AnimePoster> allAnimesList) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 180,
                  child: Text(
                    allAnimesList.isNotEmpty
                        ? "Cantidad de animes: ${allAnimesList.length}"
                        : "Sigue escribiendo, encontraremos el anime que buscas 😉",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                childAspectRatio: 0.8,
                crossAxisSpacing: 15,
              ),
              itemCount: allAnimesList.length,
              itemBuilder: (BuildContext context, int index) {
                final anime = allAnimesList[index];
                return GestureDetector(
                  child: AnimeCell(anime: anime),
                  onTap: () {
                    _con.addToRecentlyWatched(allAnimesList, index);
                    _con.goToDetail(context, anime);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
