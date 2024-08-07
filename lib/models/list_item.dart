
import 'package:indieflow/models/list_item_color_scheme.dart';
import 'package:indieflow/models/character.dart';
import 'package:indieflow/utils/extensions.dart';

class ListItem {

  final int identifier;
  final Character character;
  final ListItemColorScheme colorScheme;

  ListItem({
    required this.identifier,
    required this.character,
    required this.colorScheme
  });

  ListItem.fromJson(Map<String, dynamic> json)
    : identifier = json['identifier'],
      character = json["character"].map((x) => Character.fromJson(x)),
      colorScheme = ColorSchemes.getColorSchemes().firstWhere(
        (element) => element.identifier == json['schemeId']);

  Map<String, dynamic> toJson() => {
    'identifier': identifier,
    'character': character.toJson(),
    'schemeId': colorScheme.identifier
  };

  factory ListItem.colored(Character character) {
    return ListItem(
      identifier: character.identifier, 
      character: character, 
      colorScheme: ColorSchemes.getColorSchemes().randomElement()!
    );
  }
}