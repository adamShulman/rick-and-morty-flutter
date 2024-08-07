
class Character {

  final int identifier;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final String imageUri;
  final List<dynamic>? episodes;

  Character({
    required this.identifier,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.imageUri,
    required this.episodes
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      identifier: json['id'],
      name: json['name'],
      status: json['status'],
      species: json['species'],
      type: json['type'],
      gender: json['gender'],
      imageUri: json['image'],
      episodes: json['episode'] as List<dynamic>
    );
  }

  Map<String, dynamic> toJson() => {
    'id': identifier,
    'name': name,
    'status': status,
    'species': species,
    'type': type,
    'gender': gender,
    'image': imageUri,
    'episode': episodes
  };
}