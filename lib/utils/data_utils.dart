
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:indieflow/models/character.dart';
import 'package:indieflow/models/charts/bar_chart_data_item.dart';
import 'package:indieflow/models/charts/pie_chart_data_item.dart';
import 'package:indieflow/utils/extensions.dart';

class DataUtils {

  DataUtils._(); 

  static List<String> speciesData(List<Character> characters) {
    return characters.map((character) => character.species).toList();
  }

  static List<String> genderData(List<Character> characters) {
    return characters.map((character) => character.gender).toList();
  }

  static List<String> statusData(List<Character> characters) {
    return characters.map((character) => character.status).toList();
  }

  static List<BarChartDataItem> barChartSpeciesData(List<Character> characters) {

    List<String> species = speciesData(characters);
    List<BarChartDataItem> barDataItems = [];
    
    for (int index = 0; index < species.length; index++) {
      int indexOfItem = barDataItems.indexWhere((chart) => chart.title == species[index]);
      if (indexOfItem != -1) {
        barDataItems[indexOfItem].y = barDataItems[indexOfItem].y + 1.0;

      } else {
        var dataItem = BarChartDataItem(x: max(barDataItems.length, 0), y: 1, title: species[index]);
        barDataItems.add(dataItem);
      }
    }

    return barDataItems;
  }

  static List<PieChartDataItem> pieChartStatusData(List<Character> characters) {

    List<String> statusList = statusData(characters);
    List<PieChartDataItem> pieDataItems = [];
    
    for (int index = 0; index < statusList.length; index++) {
      int indexOfItem = pieDataItems.indexWhere((chart) => chart.title == statusList[index]);
      if (indexOfItem != -1) {
        pieDataItems[indexOfItem].value = pieDataItems[indexOfItem].value + 1;

      } else {
        var dataItem = PieChartDataItem(value: max(pieDataItems.length.toDouble(), 0), title: statusList[index], color: Colors.primaries.randomElement()!);
        pieDataItems.add(dataItem);
      }

      if (index == statusList.length - 1) {
        for (int index = 0; index < pieDataItems.length; index++) {
          pieDataItems[index].value = pieDataItems[index].value * 100 / 20;
        }
      }
    }
    return pieDataItems;
    
  }
}