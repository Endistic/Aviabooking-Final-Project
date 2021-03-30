import 'package:flutter/cupertino.dart';

class MyStyle {
  Container showAppBarLogo() {
    return Container(
      height: 50,
      child: Image.asset('images/logo-avia-แนวนอน.png'),
    );
  }

  Color colorsbg() {
    return Color.fromRGBO(204, 37, 44, 1.0);
  }

  Color colorbg2() {
    return Color.fromRGBO(54, 54, 54, 1.0);
  }

  MyStyle();
}
