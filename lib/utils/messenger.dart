
import 'package:flutter/material.dart';
import 'package:indieflow/utils/constants.dart';

mixin SnackBarMessengerMixin {
  final Messenger messenger = SnackBarMessenger();
}

abstract class Messenger {
  void showSnackBar({required Widget content});
}

class SnackBarMessenger implements Messenger {
  @override
  void showSnackBar({required Widget content}) {
    AppConstants.scaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        content: content, behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          top: 100.0,
          bottom: AppConstants.layout.getScreenDimensions().height - 100.0,
          right: 20,
          left: 20
        ),
      )
    );
  }
}