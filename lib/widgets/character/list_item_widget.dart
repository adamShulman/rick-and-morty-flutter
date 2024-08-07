

import 'package:flutter/material.dart';
import 'package:indieflow/models/list_item.dart';
import 'package:transparent_image/transparent_image.dart';

class ListItemWidget extends StatelessWidget {

  final ListItem listItem;
  final BorderRadiusGeometry cardRadius;
  final EdgeInsetsGeometry cardMargin;
  final bool showGradient;
  final Color shadowColor;
  final void Function()? onTap;

  const ListItemWidget({
    super.key, 
    required this.listItem, 
    this.cardRadius = const BorderRadius.all(Radius.circular(12.0)),
    this.cardMargin = const EdgeInsets.all(12.0),
    this.showGradient = true,
    this.shadowColor = Colors.black,
    this.onTap, 
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap != null ? onTap!() : (),
      child: Card(
        margin: cardMargin,
        color: Colors.transparent,
        elevation: 10.0,
        shadowColor: shadowColor,
        child: Container(
          margin: const EdgeInsets.all(1.0),
          decoration: BoxDecoration(
            borderRadius: cardRadius,
            gradient: showGradient
            ? LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [
                0.01,
                0.29,
                0.48,
                0.67,
                0.98
              ],
              colors: listItem.colorScheme.gradientColors
            )
            : null
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: listItem.character.imageUri,
                        fit: BoxFit.cover,
                        fadeInDuration: const Duration(milliseconds: 300),
                        imageErrorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.broken_image,
                            size: 50.0,
                          );
                        },
                      ),
                    )
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _regularTextWidget(listItem.character.name, maxLines: 2, fontSize: 18.0, fontWeight: FontWeight.bold),
                      _regularTextWidget('gender: ${listItem.character.gender.toLowerCase()}'),
                      _regularTextWidget('species: ${listItem.character.species.toLowerCase()}'),
                      _regularTextWidget('status: ${listItem.character.status.toLowerCase()}')
                      
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _regularTextWidget(String text, {int maxLines = 1, double fontSize = 16.0, FontWeight fontWeight = FontWeight.w300}) {
    return Text(
      text,
      maxLines: maxLines,
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: fontWeight,
        shadows: const [
          Shadow(
            offset: Offset(2.0, 2.0),
            blurRadius: 3.0,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ],
      )
    );
  }
}