import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:prampracha_app/screens/home.dart';
import 'package:prampracha_app/screens/login.dart';

import 'package:prampracha_app/screens/register.dart';
import 'package:prampracha_app/screens/userinfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:prampracha_app/helper/dbhelper.dart';
import 'package:prampracha_app/model/user_model.dart';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  TextEditingController nameController = TextEditingController();

  Contact _contact = Contact();
  List<Contact> _contacts = [];
  DatabaseHelper _dbHelper = DatabaseHelper.instance;

  startTime() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    _refreshContact();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    startTime();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Container(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                'images/logo-avia_0.png',
                width: 200,
                height: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _refreshContact() async {
    List<Contact> x = await _dbHelper.fetchContacts();
    setState(() {
      _contacts = x;
      if (_contacts.isNotEmpty) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Navigate()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginTo()));
      }
    });
  }
}
