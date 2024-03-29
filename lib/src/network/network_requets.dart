import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:ninja_otaku_app/src/models/anime_data.dart';
import 'package:ninja_otaku_app/src/models/anime_poster.dart';

class NetworkRequest {
  static final episodesHomeUrl = Uri.parse("https://animeflv.mom/home/");
  static final baseUrl = Uri.parse("https://animeflv.mom/directorio");

  static final keywordUrlTio = Uri.parse("https://tioanime.com/directorio?q=");
  static final baseUrlTio = Uri.parse("https://tioanime.com/directorio?p=");

  //Funcion que retorna todos los animes que se veran en all_anime_page
  static Future<List<AnimePoster>> fetchAllAnimes() async {
    int pageNumber = 1;
    final List<AnimePoster> allPosters = [];

    while (pageNumber <= 2) {
      var url = Uri.parse("https://tioanime.com/directorio?p=$pageNumber");

      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final html = dom.Document.html(response.body);

          final titles = html
              .querySelectorAll('main > ul > li > article > a > h3')
              .map((element) => element.text.toString())
              .toList();

          final posters = html
              .querySelectorAll(
                  'main > ul > li > article > a > div > figure > img')
              .map((element) =>
                  "https://tioanime.com${element.attributes['src']!}")
              .toList();

          final hrefs = html
              .querySelectorAll('main > ul > li > article > a')
              .map((element) =>
                  "https://tioanime.com${element.attributes['href']!}")
              .toList();

          final animesForPage = List.generate(
            posters.length,
            (index) => AnimePoster(
              title: titles[index],
              poster: posters[index],
              href: hrefs[index],
              type: "Anime",
            ),
          );

          allPosters.addAll(animesForPage);
          pageNumber++;
        }
      } catch (error) {
        throw Exception(
            "Ocurrió un error durante la obtención de datos: $error");
      }
    }
    return allPosters;
  }

  static Future<List<Map<String, String>>> fetchAllAnimesBlock() async {
    int pageNumber = 121;
    final List<Map<String, String>> allData = [];

    while (pageNumber <= 130) {
      var url = Uri.parse("https://tioanime.com/directorio?p=$pageNumber");
      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final html = dom.Document.html(response.body);

          final titles = html
              .querySelectorAll('main > ul > li > article > a > h3')
              .map((element) => element.text.toString())
              .toList();

          final posters = html
              .querySelectorAll(
                  'main > ul > li > article > a > div > figure > img')
              .map((element) =>
                  "https://tioanime.com${element.attributes['src']!}")
              .toList();

          final hrefs = html
              .querySelectorAll('main > ul > li > article > a')
              .map((element) =>
                  "https://tioanime.com${element.attributes['href']!}")
              .toList();

          final animesForPage = List.generate(
            titles.length,
            (index) => {
              'title': titles[index],
              'poster': posters[index],
              'href': hrefs[index],
              'type': 'Anime',
            },
          );

          allData.addAll(animesForPage);
          pageNumber++;
        }
      } catch (error) {
        throw Exception(
            "Ocurrió un error durante la obtención de datos: $error");
      }
    }
    return allData;
  }

  //Funcion que obtiene los ultimos episodios agregados
  static Future<List<AnimePoster>> fetchLatestEpisodes() async {
    List<AnimePoster> latestEpisodesPosters;
    const int maxAnimes = 10;
    try {
      final response = await http.get(episodesHomeUrl);
      if (response.statusCode == 200) {
        dom.Document html = dom.Document.html(response.body);
        final titles = html
            .querySelectorAll('main > ul > li > article > a > h3')
            .map((element) => element.text.toString())
            .toList();

        final posters = html
            .querySelectorAll(
                'main > ul > li > article > a > div > figure > img')
            .map((element) => element.attributes['data-src']!)
            .toList();

        final hrefs = html
            .querySelectorAll('main > ul > li > article > a')
            .map((element) => element.attributes['href']!)
            .toList();

        final types = html
            .querySelectorAll('main > ul > li > article > a > div > span')
            .map((element) => element.innerHtml.toString())
            .toList();

        latestEpisodesPosters = List.generate(
          maxAnimes,
          (index) => AnimePoster(
            title: titles[index],
            poster: posters[index],
            href: hrefs[index],
            type: types[index],
          ),
        );
        return latestEpisodesPosters;
      } else {
        throw Exception("Error en la solicitud HTTP: ${response.statusCode}");
      }
    } catch (error) {
      throw Exception("Ocurrió un error durante la obtención de datos: $error");
    }
  }

  static Future<AnimeData?> getAnimeData(String title, String href) async {
    try {
      String resultado =
          title.toLowerCase().replaceAll(RegExp(r'[^a-zA-Z0-9]+'), '-');

      final url = Uri.parse(href);
      final response = await http.get(url);
      final document = dom.Document.html(response.body);
      var url2 = Uri.parse("https://animeflv.mom/movie/$resultado");
      final response2 = await http.get(url2);
      final document2 = dom.Document.html(response2.body);

      final descriptionElement = document.querySelector('aside > p.sinopsis');

      final synopsis = descriptionElement?.text ?? 'Sin descripción por ahora';

      final genres = document
          .querySelectorAll('p.genres > span > a')
          .map((a) => a.text)
          .toList();

      final String? status = document.querySelector("aside > div > a")?.text;
      final String? year = document.querySelector("span.year")?.text;

      final episodes = document2
          .querySelectorAll('#episodeList > li > a')
          .map((a) => a.attributes['href'])
          .toList();

      final episodeChecked =
          List<bool?>.generate(episodes.length, (index) => false);

      return AnimeData(
        synopsis: synopsis,
        status: status,
        year: year,
        genres: genres,
        episodes: episodes,
        episodeChecked: episodeChecked,
      );
    } catch (e) {
      return null;
    }
  }

  //Obtener el link del servicio de streaming
  static Future<String?> getServerVideo(String urlOfEpisode) async {
    final url = Uri.parse(urlOfEpisode);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        dom.Document document = dom.Document.html(response.body);
        String? urlServer =
            document.getElementById('frame1')!.attributes['src'];
        return urlServer;
      }
    } catch (error) {
      throw Exception("Ocurrió un error durante la obtención de datos: $error");
    }
    return null;
  }

  static Future<List<AnimePoster>> searchAnimeWriting(String search) async {
    List<AnimePoster> allPostersSearch = [];
    String resultado =
        search.toLowerCase().replaceAll(RegExp(r'[^a-zA-Z0-9]+'), '+');
    var url = Uri.parse("$keywordUrlTio$resultado");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final html = dom.Document.html(response.body);

        final titles = html
            .querySelectorAll('main > ul > li > article > a > h3')
            .map((element) => element.text.toString())
            .toList();

        final posters = html
            .querySelectorAll(
                'main > ul > li > article > a > div > figure > img')
            .map((element) =>
                "https://tioanime.com${element.attributes['src']!}")
            .toList();

        final hrefs = html
            .querySelectorAll('main > ul > li > article > a')
            .map((element) =>
                "https://tioanime.com${element.attributes['href']!}")
            .toList();

        allPostersSearch = List.generate(
          titles.length,
          (index) => AnimePoster(
            title: titles[index],
            poster: posters[index],
            href: hrefs[index],
            type: "Anime",
          ),
        );
        return allPostersSearch;
      } else {
        throw Exception("Error en la solicitud HTTP: ${response.statusCode}");
      }
    } catch (error) {
      throw Exception("Ocurrió un error durante la obtención de datos: $error");
    }
  }
}
