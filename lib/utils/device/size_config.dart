import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';

class SizeConfig {
  static double? _screenWidth;
  static double? _screenHeight;
  static double _blockWidth = 0;
  static double _blockHeight = 0;

  static double? textMultiplier;
  static double? imageSizeMultiplier;
  static double? heightMultiplier;
  static double ?widthMultiplier;
  static bool isPortrait = true;
  static bool isMobile = false;
  static bool isMobilePortrait = false;

  void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      _screenWidth = constraints.maxWidth;
      _screenHeight = constraints.maxHeight;
      isPortrait = true;
      if (_screenWidth! < 450) {
        isMobilePortrait = true;
      }
    } else {
      _screenWidth = constraints.maxHeight;
      _screenHeight = constraints.maxWidth;
      isPortrait = false;
      isMobilePortrait = false;
    }
    double? _minValue = [_screenWidth, _screenHeight].reduce(
  (value, element) => value != null ? min(value, element!) : element
);;
    if (_minValue! < 600) {
      _blockWidth = _screenWidth! / 100;
      _blockHeight = _screenHeight! / 100;
      isMobile = true;
    } else {
      _blockWidth = _screenWidth! / 150;
      _blockHeight = _screenHeight! / 150;
    }

    textMultiplier = _blockHeight;
    imageSizeMultiplier = _blockWidth;
    heightMultiplier = _blockHeight;
    widthMultiplier = _blockWidth;

    // print('screen Width: $_screenWidth');
  }
}
class TextSizeConfig {
  static double? scaleFactor;
  static double referenceScreenHeight = 812; // Chiều cao màn hình mẫu
  static double referenceFontSize = 16; // Kích thước chữ mẫu

  static void init(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    scaleFactor = screenHeight / referenceScreenHeight;
  }

  static double getAdjustedFontSize(double fontSize) {
    print(fontSize * scaleFactor!);
    return fontSize * scaleFactor!;
  }
}