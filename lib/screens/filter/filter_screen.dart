
import 'package:flutter/material.dart';
import 'package:indieflow/utils/extensions.dart';

class FilterChipDisplay extends StatefulWidget {
  const FilterChipDisplay({super.key});

  @override
  State<StatefulWidget> createState() => _FilterChipDisplayState();
}

class _FilterChipDisplayState extends State<FilterChipDisplay> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter", style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Card(
              margin: const EdgeInsets.all(12.0),
              color: Colors.white,
              elevation: 10.0,
              shadowColor: Colors.black,
              child: Container(
                margin: const EdgeInsets.all(1.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [
                      0.01,
                      0.29,
                      0.48,
                      0.67,
                      0.98
                    ],
                    colors: ColorSchemes.getColorSchemes().randomElement()!.gradientColors
                  )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _titleContainer("By Status"),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left:8.0),
                  child: Align
                    (
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      spacing: 5.0,
                      runSpacing: 3.0,
                      children: <Widget>[
                        FilterChipWidget(chipName: 'Alive'),
                        FilterChipWidget(chipName: 'Dead'),
                        FilterChipWidget(chipName: 'Unknown'),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _titleContainer('By Species'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left:8.0),
                  child: Align
                    (
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      spacing: 5.0,
                      runSpacing: 5.0,
                      children: <Widget>[
                        FilterChipWidget(chipName: 'Human'),
                        FilterChipWidget(chipName: 'Alien'),
                        FilterChipWidget(chipName: 'Humanoid'),
                        FilterChipWidget(chipName: 'Poopybutthole'),
                        FilterChipWidget(chipName: 'Other'),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _titleContainer('By Gender'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left:8.0),
                  child: Align
                    (
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      spacing: 5.0,
                      runSpacing: 5.0,
                      children: <Widget>[
                        FilterChipWidget(chipName: 'Male'),
                        FilterChipWidget(chipName: 'Female'),
                        FilterChipWidget(chipName: 'Other'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ),
          ],
        )
      ),
    );
  }
}

Widget _titleContainer(String title) {
  return Text(
    title,
    maxLines: 1,
    style: const TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      shadows: [
        Shadow(
          offset: Offset(2.0, 2.0),
          blurRadius: 3.0,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
      ],
    )
  );
}

class FilterChipWidget extends StatefulWidget {
  final String chipName;

  const FilterChipWidget({super.key, required this.chipName});

  @override
  State<StatefulWidget> createState() => _FilterChipWidgetState();
}

class _FilterChipWidgetState extends State<FilterChipWidget> {

  var _isSelected = true;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.chipName),
      labelStyle: const TextStyle(color: Colors.black,fontSize: 16.0, fontWeight: FontWeight.w300),
      selected: _isSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0)
      ),
      backgroundColor: const Color(0xffededed),
      onSelected: (isSelected) {
        setState(() {
          _isSelected = isSelected;
        });
      },
      checkmarkColor: Colors.black,
      selectedColor: AppColors.contentColorR);
  }
}