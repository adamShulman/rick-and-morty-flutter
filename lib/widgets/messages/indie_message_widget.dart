
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:indieflow/utils/extensions.dart';

class IndieMessageWidget extends StatefulWidget {

  final IconData image; 
  final String title;
  final String subTitle; 
  final TextStyle? subtitleTextStyle;
  final TextStyle? titleTextStyle; 
  final bool? hideBackgroundAnimation;
  final void Function() onTap;

  const IndieMessageWidget({
    super.key, 
    required this.title,
    required this.subTitle,
    required this.image,
    this.subtitleTextStyle,
    this.titleTextStyle,
    this.hideBackgroundAnimation = false, 
    required this.onTap,
  });

  

  @override
  State createState() => _IndieMessageWidgetState();
}

class _IndieMessageWidgetState extends State<IndieMessageWidget> with TickerProviderStateMixin {

  late AnimationController _backgroundController;
  late AnimationController _imageController;

  late final AnimationController _fadeAnimationController = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
    lowerBound: 0.3,
    upperBound: 1.0
  )..repeat(reverse: true);
  late final Animation<double> _fadeAnimation = CurvedAnimation(
    parent: _fadeAnimationController,
    curve: Curves.easeInOut,
  );
  
  
  @override
  void dispose() {
    _backgroundController.dispose();
    _imageController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _backgroundController = AnimationController(
        duration: const Duration(minutes: 1),
        vsync: this,
        lowerBound: 0,
        upperBound: 20)
      ..repeat();

    _imageController = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _imageController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            alignment: Alignment.center,
            color: Colors.transparent,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                if (!widget.hideBackgroundAnimation!)
                  RotationTransition(
                  turns: _backgroundController,
                  child: Container(
                    width: min(constraints.maxWidth / 1.5, 300.0),
                    // height: min(constraints.maxWidth / 2, 300.0),
                    decoration: const BoxDecoration(boxShadow: <BoxShadow>[
                      BoxShadow(
                        offset: Offset(0, 0),
                        color: Colors.transparent,
                      ),
                      BoxShadow(
                        blurRadius: 30,
                        offset: Offset(20, 0),
                        color: AppColors.secondaryColor,
                        spreadRadius: -5),
                    ],  shape: BoxShape.circle),
                  ),
                ),
                Container(
                  width: min(constraints.maxWidth / 1.5, 300.0),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Flexible(
                        fit: FlexFit.loose,
                        flex: 3,
                        child: ScaleTransition(
                          scale: Tween(begin: 0.75, end: 1.2)
                            .animate(
                              CurvedAnimation(
                                parent: _imageController, 
                                curve: Curves.elasticOut
                              )
                            ),
                            child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: FittedBox(
                              child: Icon(
                                color: Colors.white,
                                widget.image,
                                size: 60.0,
                              )
                            )
                          ),
                        ),
                      ),
                      Flexible(
                        child: FittedBox(
                          child: Text(
                            widget.title,
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            ), 
                          ),
                        ),
                      ),
                      Text(
                        widget.subTitle,
                        // overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.white
                        ), 
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.black,
                          foregroundColor: AppColors.primaryTextColor, 
                          padding: const EdgeInsets.all(8.0),
                          backgroundColor: const Color.fromARGB(218, 32, 49, 64),
                          minimumSize: const Size(88, 36),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        onPressed: () => widget.onTap(),
                        child: Text(
                          'Try again',
                          maxLines: 1,
                          style: TextStyle(
                            color: AppColors.primaryTextColor,
                            fontSize: max(min(constraints.maxWidth * 0.03, 14.0), 6.0),
                            fontWeight: FontWeight.bold
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
      },
    );
  }
}
