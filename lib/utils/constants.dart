
import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppConstants {

  static RoutesPath routesPath = const RoutesPath();
  static LayoutConstants layout = const LayoutConstants();
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

}

class RoutesPath {

  const RoutesPath();

  String get characters => '/characters';

  String get charts => '/charts';

  String get characterDetails => 'details';

  String get filter => 'filter';
  
}

class LayoutConstants {

  const LayoutConstants();

  bool get isMobileDevice => !kIsWeb && (Platform.isIOS || Platform.isAndroid);
  bool get isDesktopDevice => !kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux);
  bool get isMobileDeviceOrWeb => kIsWeb || isMobileDevice;
  bool get isDesktopDeviceOrWeb => kIsWeb || isDesktopDevice;

   Size getScreenDimensions() {

    FlutterView view = PlatformDispatcher.instance.views.first;

    double physicalWidth = view.physicalSize.width;
    double physicalHeight = view.physicalSize.height;

    double devicePixelRatio = view.devicePixelRatio;

    double screenWidth = physicalWidth / devicePixelRatio;
    double screenHeight = physicalHeight / devicePixelRatio;

    return Size(screenWidth, screenHeight);

  }

}