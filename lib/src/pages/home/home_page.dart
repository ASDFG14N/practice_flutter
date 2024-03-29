import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:ninja_otaku_app/src/data/list_classic.dart';
import 'package:ninja_otaku_app/src/data/list_movies.dart';
import 'package:ninja_otaku_app/src/models/anime_poster.dart';
import 'package:ninja_otaku_app/src/network/network_requets.dart';
import 'package:ninja_otaku_app/src/pages/home/controllers/home_page_controller.dart';
import 'package:ninja_otaku_app/src/utils/my_colors.dart';
import 'package:ninja_otaku_app/src/widgets/nothing_show.dart';
import 'package:ninja_otaku_app/src/widgets/sniper_custom.dart';

class HomePageNinjaOtaku extends StatefulWidget {
  const HomePageNinjaOtaku({super.key});

  @override
  State<HomePageNinjaOtaku> createState() => _HomePageNinjaOtakuState();
}

class _HomePageNinjaOtakuState extends State<HomePageNinjaOtaku> {
  final HomePageController _con = HomePageController();

  List<AnimePoster> fetchLatestEpisodes = [];
  List<AnimePoster> listRecentlyWatched = [];

  bool isDrawerCollapsed = true;
  bool isSwitched = false;

  //Valores de carga
  bool isLoading = true;
  bool error = false;

  @override
  initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context);
      NetworkRequest.fetchLatestEpisodes().then((data) {
        setState(() {
          fetchLatestEpisodes = data;
          isLoading = false;
        });
      }).catchError((e) {
        setState(() {
          error = true;
          isLoading = false;
        });
      });
    });
    loadRecentlyWatchedList();
  }

  Future<void> loadRecentlyWatchedList() async {
    List<AnimePoster> recentlyWatched = await getRecentlyWatchedAnime();
    setState(() {
      listRecentlyWatched = recentlyWatched;
    });
  }

  void _addMyList() async {
    await addToFavorites(fetchLatestEpisodes[0]);
  }

  void _reloadData() {
    setState(() {
      isLoading = true;
      error = false;
    });
    NetworkRequest.fetchLatestEpisodes().then((data) {
      setState(() {
        fetchLatestEpisodes = data;
        isLoading = false;
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
      key: _con.key,
      backgroundColor: const Color(0xFF394988),
      drawer: SafeArea(
        child: _navigationDrawer(context, isDrawerCollapsed),
      ),
      body: loadBody(),
    );
  }

  Widget loadBody() {
    if (isLoading) {
      return Center(child: spinnerCustom());
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
      return _getBody();
    }
  }

  //====================
  //Widgets de la pagina
  //====================
  Widget _appBarr() {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.myCustomPageColorPrimaryOne,
      ),
      child: Container(
        margin: const EdgeInsets.only(top: 15, bottom: 15),
        child: Container(
          margin: const EdgeInsets.only(left: 15, top: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset(
                "assets/images/logo_ninja_otaku.png",
                width: 38,
                fit: BoxFit.cover,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      _con.goToMyList();
                    },
                    icon: const Icon(
                      Icons.star_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _con.openDrawerCustom();
                    },
                    icon: const Icon(
                      Icons.person_2_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getBody() {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Banner imagens principal
                        _mostViewedOfDay(size),
                        Container(
                          margin: const EdgeInsets.only(bottom: 25),
                          decoration: BoxDecoration(
                            color: MyColors.myCustomPageColorPrimaryOne,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 20,
                              bottom: 23,
                            ),
                            child: _threeButtons(),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Pimera fila de portadas
                            _scrollableRowOfAnimesTop(
                                "Top del Día", fetchLatestEpisodes),
                            const SizedBox(height: 30),
                            _scrollableRowOfAnimes(
                              "Últimos Episodios Añadidos",
                              fetchLatestEpisodes,
                            ),
                            const SizedBox(height: 30),
                            if (listRecentlyWatched.length >= 4)
                              _scrollableRowOfAnimesXD(),
                            if (listRecentlyWatched.isEmpty) const SizedBox(),
                            _scrollableRowOfAnimes("Clásicos", listsClassic),
                            const SizedBox(height: 30),
                            _scrollableRowOfAnimes("Películas", listFullMovies),
                            const SizedBox(height: 30),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              _appBarr(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mostViewedOfDay(Size size) {
    return Stack(
      children: [
        Container(
          height: 500,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(fetchLatestEpisodes[0].poster),
            ),
          ),
        ),
        Container(
          height: 500,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.black.withOpacity(0.5),
                Colors.black.withOpacity(0.8),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 500,
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  fetchLatestEpisodes[0].title,
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ],
    );
  }

  Widget _threeButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            _addMyList();
          },
          child: const Column(
            children: [
              Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 25,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Mi lista",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        //boton play
        GestureDetector(
          onTap: () {
            _con.goToViewAnime(fetchLatestEpisodes, 0);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Padding(
              padding: EdgeInsets.only(
                right: 13,
                left: 8,
                top: 2,
                bottom: 2,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.black,
                    size: 30,
                  ),
                  SizedBox(width: 5),
                  Text(
                    "Play",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            _con.goToViewAnime(fetchLatestEpisodes, 0);
          },
          child: const Column(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: Colors.white,
                size: 25,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Info",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  //Filas de animes
  Widget _scrollableRowOfAnimesTop(String title, List<AnimePoster> animeList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: List.generate(
                10,
                (index) {
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _con.addToRecentlyWatched(animeList, index);
                          _con.goToViewAnime(animeList, index);
                        },
                        child: Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              width: 130,
                              height: 180,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(animeList[index].poster),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(5),
                                  ),
                                  color: MyColors.myCustomColorRed,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromARGB(218, 0, 0, 0),
                                      offset: Offset(3, -3),
                                      blurRadius: 4,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 5,
                                    right: 5,
                                  ),
                                  child: Text(
                                    (index + 1).toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 45,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _scrollableRowOfAnimes(String title, List<AnimePoster> animeList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: List.generate(
                animeList.length,
                (index) {
                  return GestureDetector(
                    onTap: () {
                      _con.addToRecentlyWatched(animeList, index);
                      _con.goToViewAnime(animeList, index);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 130,
                      height: 180,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(animeList[index].poster),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _scrollableRowOfAnimesXD() {
    return Column(
      children: [
        _scrollableRowOfAnimes(
          "Continuar Viendo",
          listRecentlyWatched,
        ),
        const SizedBox(height: 30)
      ],
    );
  }

  Widget _navigationDrawer(BuildContext context, bool isColapsed) {
    return SizedBox(
      width: isColapsed ? MediaQuery.of(context).size.width * 0.18 : null,
      child: Drawer(
        child: Container(
          color: MyColors.myCustomPageColorPrimaryTwo,
          child: Column(
            children: [
              Container(
                color: Colors.white12,
                width: double.infinity,
                height: 120,
                child: buildHeader(isColapsed),
              ),
              Column(
                children: [
                  _buildItem(Icons.settings_rounded, "Ajustes", isColapsed),
                  _buildItem(Icons.cast_rounded, "Transmitir", isColapsed),
                  _buildItem(Icons.info_rounded, "Acerca de", isColapsed),
                  _buildItem(
                      Icons.comment_rounded, "Enviar comentarios", isColapsed),
                  _buildItem(Icons.code_rounded, "Apoyar", isColapsed),
                ],
              ),
              const Divider(color: Colors.white60),
              //boton de cerrrar sesion
              _buildItem(Icons.logout_rounded, "Cerrar sesión", isColapsed),
              const Spacer(),
              buildCollapseIcon(context, isColapsed),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader(bool isColapsed) {
    return isColapsed
        ? Image.asset("assets/images/user_profile_2.png")
        : Row(
            children: [
              const SizedBox(width: 24),
              Image.asset(
                "assets/images/user_profile_2.png",
              ),
              const SizedBox(width: 16),
              const Text("Usuario"),
            ],
          );
  }

  Widget buildCollapseIcon(BuildContext context, bool isColapsed) {
    const double size = 52;
    final icon = isColapsed
        ? Icons.arrow_forward_ios_rounded
        : Icons.arrow_back_ios_rounded;
    final alignmentCustom =
        isColapsed ? Alignment.center : Alignment.centerRight;
    final marginCustom = isColapsed ? null : const EdgeInsets.only(right: 12);
    final widthCustom = isColapsed ? double.infinity : size;
    return Container(
      alignment: alignmentCustom,
      margin: marginCustom,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              isDrawerCollapsed = !isDrawerCollapsed;
            });
          },
          //Sin colapsar
          child: SizedBox(
            width: widthCustom,
            height: size,
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(IconData icon, String description, bool isColapsed) {
    return isColapsed
        ? Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.all(10),
                width: double.infinity,
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ),
          )
        : Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 10,
                  bottom: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      icon,
                      color: Colors.white,
                      size: 35,
                    ),
                    Text(
                      description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
