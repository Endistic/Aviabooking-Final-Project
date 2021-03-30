import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:prampracha_app/screens/comebooking.dart';
import 'package:prampracha_app/screens/home.dart';
import 'bookingComeTo.dart';

class Type extends StatefulWidget {
  Type({Key key}) : super(key: key);

  @override
  _TypeState createState() => _TypeState();
}

class _TypeState extends State<Type> {
  Widget comebutton() {
    return Container(
      width: 250.0,
      height: 50.0,
      child: RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Color.fromRGBO(204, 37, 44, 1.0),
        onPressed: () {
          Navigator.pop(context);
          MaterialPageRoute cuper =
              MaterialPageRoute(builder: (value) => BookingCome());
          Navigator.push(context, cuper);
        },
        child: Text(
          'เลือกตั๋วเที่ยวเดียว',
          style: TextStyle(fontSize: 22.0, color: Colors.white),
        ),
      ),
    );
  }

  Widget comeandbackbutton() {
    return Container(
      width: 250.0,
      height: 50.0,
      child: RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Color.fromRGBO(204, 37, 44, 1.0),
        onPressed: () {
          Navigator.pop(context);
          MaterialPageRoute cuper =
              MaterialPageRoute(builder: (value) => Booking());
          Navigator.push(context, cuper);
        },
        child: Text(
          'เลือกตั๋วไปและกลับ',
          style: TextStyle(fontSize: 22.0, color: Colors.white),
        ),
      ),
    );
  }
  Widget backhome() {
    return Container(
      width: 200.0,
      height: 50.0,
      child: RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Color.fromRGBO(204, 37, 44, 1.0),
        onPressed: () {
          Navigator.pop(context);
          MaterialPageRoute cuper =
              MaterialPageRoute(builder: (value) => Navigate());
          Navigator.push(context, cuper);
        },
        child: Text(
          'กลับหน้าแรก',
          style: TextStyle(fontSize: 22.0, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Stack(
      children: <Widget>[
        new Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("images/bc-3.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        new Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              comebutton(),
              SizedBox(
                height: 20.0,
              ),
              comeandbackbutton(),
              SizedBox(
                height: 20.0,
              ),
              backhome(),
            ],
          ),
        )
      ],
    ));
  }
}
