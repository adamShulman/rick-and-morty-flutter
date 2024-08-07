

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:indieflow/models/character.dart';
import 'package:indieflow/models/list_item_color_scheme.dart';

extension RandomListItem<T> on List<T> {

  T? randomElement() {
    return this[Random().nextInt(length)];
  }

}

extension CharacterEpisodeParser on Character {

  List<int>? episodeIds() {
    return episodes?.map((episodeUrl) => int.parse(episodeUrl.split('episode/').last)).toList();
  } 

}

extension AppColors on Color {

  static const Color primary = Color(0xFF50E4FF);
  static const Color secondaryColor =  Color(0xFF495057);
  static const Color primaryTextColor = Colors.white;
  static const Color itemsBackground = Color(0xFF1B2339);
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorYellow = Color(0xFFFFC300);
  static const Color contentColorGreen = Color(0xFF3BFF49);
  static const Color contentColorCyan = Color(0xFF50E4FF);
  static const Color contentColorP = Color.fromARGB(255, 233, 204, 244);
  static const Color contentColorR = Color.fromARGB(255, 210, 107, 53);

}

extension ColorSchemes on Colors {
  
  static List<ListItemColorScheme> getColorSchemes() {
    return [
      ListItemColorScheme(gradientColors: [
        const Color(0xFF22577A),
        const Color(0xFF38A3A5),
        const Color(0xFF57CC99),
        const Color(0xFF80ED99),
        const Color(0xFFC7F9CC),
      ], 
        mainTextColor: Colors.white, 
        secondaryTextColor: Colors.white,
        identifier: 1
      ),
      ListItemColorScheme(gradientColors: [
        const Color(0xFFCCD5AE),
        const Color(0xFFE9EDC9),
        const Color(0xFFFEFAE0),
        const Color(0xFFFAEDCD),
        const Color(0xFFD4A373),
      ],
        mainTextColor: Colors.white, 
        secondaryTextColor: Colors.white,
        identifier: 2
      ),
      ListItemColorScheme(gradientColors: [
        const Color(0xFF264653),
        const Color(0xFF2A9D8F),
        const Color(0xFFE9C46A),
        const Color(0xFFF4A261),
        const Color(0xFFE76F51),
      ],
        mainTextColor: Colors.white, 
        secondaryTextColor: Colors.white,
        identifier: 3
      ),
      ListItemColorScheme(gradientColors: [
        const Color(0xFFFFCDB2),
        const Color(0xFFFFB4A2),
        const Color(0xFFE5989B),
        const Color(0xFFB5838D),
        const Color(0xFF6D6875),
      ],
        mainTextColor: Colors.white, 
        secondaryTextColor: Colors.white,
        identifier: 4
      ),
      ListItemColorScheme(gradientColors: [
        const Color(0xFF344e41),
        const Color(0xFF3a5a40),
        const Color(0xFF588157),
        const Color(0xFFa3b18a),
        const Color(0xFFdad7cd),
      ],
        mainTextColor: Colors.white, 
        secondaryTextColor: Colors.white,
        identifier: 5
      ),
      ListItemColorScheme(gradientColors: [
        const Color(0xFF003049),
        const Color(0xFFd62828),
        const Color(0xFFf77f00),
        const Color(0xFFfcbf49),
        const Color(0xFFeae2b7),
      ],
        mainTextColor: Colors.white, 
        secondaryTextColor: Colors.white,
        identifier: 6
      ),
      ListItemColorScheme(gradientColors: [
        const Color(0xFF22577a),
        const Color(0xFF38a3a5),
        const Color(0xFF57cc99),
        const Color(0xFF80ed99),
        const Color(0xFFc7f9cc),
      ],
        mainTextColor: Colors.white, 
        secondaryTextColor: Colors.white,
        identifier: 7
      ),
       ListItemColorScheme(gradientColors: [
        const Color(0xFF0081a7),
        const Color(0xFF00afb9),
        const Color(0xFFfdfcdc),
        const Color(0xFFfed9b7),
        const Color(0xFFf07167),
      ],
        mainTextColor: Colors.white, 
        secondaryTextColor: Colors.white,
        identifier: 8
      ),
    ];
  }
}
