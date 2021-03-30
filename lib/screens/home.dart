import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:prampracha_app/screens/map.dart';
import 'package:prampracha_app/screens/homepage.dart';
import 'package:prampracha_app/screens/ticketlis.dart';

class Navigate extends StatefulWidget {
  @override
  _NavigateState createState() => _NavigateState();
}

class _NavigateState extends State<Navigate> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    Home(),
    TicketList(),
    MapRoute(),
  ];

  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: new BottomNavigationBar(
        onTap: onTappedBar,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.shifting,
        backgroundColor: Color.fromRGBO(255, 255, 255, 0.5),
        items: [
          BottomNavigationBarItem(
            icon: new Icon(
              Icons.home,
              color: Color.fromRGBO(204, 37, 44, 1.0),
              size: 40.0,
            ),
            title: new Text(
              'หน้าแรก',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          BottomNavigationBarItem(
            icon: new Image.asset(
              'images/coupon.png',
              scale: 15.0,
              color: Color.fromRGBO(204, 37, 44, 1.0),
            ),
            title: new Text(
              'รายการตั๋ว',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          BottomNavigationBarItem(
            icon: new Icon(
              Icons.location_on,
              size: 40.0,
              color: Color.fromRGBO(204, 37, 44, 1.0),
            ),
            title: new Text(
              'แผนที่',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
