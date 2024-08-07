
class Episode {

  final int identifier;
  final String name;
  final String airDate;
  final String episode;

  Episode({
    required this.identifier,
    required this.name,
    required this.airDate,
    required this.episode,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      identifier: json['id'],
      name: json['name'],
      airDate: json['air_date'],
      episode: json['episode']
    );
  }

  Map<String, dynamic> toJson() => {
    'id': identifier,
    'name': name,
    'air_date': airDate,
    'episode': episode,
  };
}