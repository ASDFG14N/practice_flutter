class AnimeData {
  final String synopsis;
  final String? status;
  final String? year;
  final List<String> genres;
  final List episodes;
  final List<bool?> episodeChecked;

  AnimeData({
    required this.synopsis,
    required this.status,
    required this.year,
    required this.genres,
    required this.episodes,
    required this.episodeChecked,
  });
}
