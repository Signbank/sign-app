import 'package:flutter/material.dart';

class CustomColor {
  static const MaterialColor redImpactToLight = MaterialColor(
    0xffe3000b, // 0%
    <int, Color>{
      50 : Color(0xffe61a24),//10%
      100: Color(0xffe9333c),//20%
      200: Color(0xffeb4d54),//30%
      300: Color(0xffee666d),//40%
      400: Color(0xfff18085),//50%
      500: Color(0xfff4999d),//60%
      600: Color(0xfff7b3b6),//70%
      700: Color(0xfff9ccce),//80%
      800: Color(0xfffce6e7),//90%
      900: Color(0xffffffff),//100%
    },
  );

  static const MaterialColor redImpactToDark = MaterialColor(
    0xffe3000b, // 0%
    <int, Color>{
      50 : Color(0xffcc000a),//10%
      100: Color(0xffb60009),//20%
      200: Color(0xff9f0008),//30%
      300: Color(0xff880007),//40%
      400: Color(0xff720006),//50%
      500: Color(0xff5b0004),//60%
      600: Color(0xff440003),//70%
      700: Color(0xff2d0002),//80%
      800: Color(0xff170001),//90%
      900: Color(0xff000000),//100%
    },
  );
}