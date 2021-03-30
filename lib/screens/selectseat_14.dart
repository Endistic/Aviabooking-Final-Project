import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prampracha_app/myStyle/normail_dialog.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:prampracha_app/screens/bookingdetail.dart';
import 'package:prampracha_app/screens/home.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:prampracha_app/myStyle/normal_dialog_pls.dart';

class SelectSeat extends StatefulWidget {
  List seatx = List();
  var serviceIDt;
  var rID;
  var stpoint;
  var dtpoint;
  DateTime dateTimeCome;
  String timeservice;
  var floorID;
  SelectSeat(
      {Key key,
      this.seatx,
      this.serviceIDt,
      this.rID,
      this.stpoint,
      this.dtpoint,
      this.dateTimeCome,
      this.timeservice,
      this.floorID})
      : super(key: key);
  @override
  _SelectSeatState createState() => _SelectSeatState(seatx, serviceIDt, rID,
      stpoint, dtpoint, dateTimeCome, timeservice, floorID);
}

class _SelectSeatState extends State<SelectSeat> {
  var serviceIDt;
  DateTime dateTimeCome;
  List seatx = List();
  var rID;
  var stpoint;
  var dtpoint;
  String timeservice;
  var floorID;
  _SelectSeatState(this.seatx, this.serviceIDt, this.rID, this.stpoint,
      this.dtpoint, this.dateTimeCome, this.timeservice, this.floorID);
  var selectSeat;
  var randomSeat = 'random';
  AnimationController controller;
  startTime() async {
    var _duration = new Duration(seconds: 60);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    normalDialog(context, 'กรุณาทำรายการใหม่');
  }

  @override
  void initState() {
    super.initState();
    print(seatx);
    print(serviceIDt);
    print(rID);
    print(stpoint);
    print(dtpoint);
    print(dateTimeCome);
    print(timeservice);
    print(floorID);
    print(selectSeat);
    // startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(204, 37, 44, 1.0),
        centerTitle: true,
        title: Text(
          'เลือกที่นั่ง',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.grey[300],
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: 470.0,
                  child: Container(
                    child: WebView(
                      initialUrl:
                          'https://premprachatransports.com/flutter_app/select-seat/selectseat.php?sID=$serviceIDt',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      color: Colors.white),
                  child: new DropdownButtonFormField(
                    decoration:
                        InputDecoration.collapsed(hintText: 'เลือกที่นั่ง'),
                    focusColor: Colors.amber,
                    value: selectSeat,
                    items: seatx.map((route) {
                      return DropdownMenuItem(
                        value: route['seat_name'],
                        child: Text('Seat No : ' + route['seat_name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      selectSeat = value;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(
                        child: Text(
                          "มีค่าบริการในการเลือกที่นั่ง ถ้าไม่ต้องการเลือกกดปุ่มถัดไป",
                          // "*Additional charge for select seat if don't want select press the confirm button",
                          style: TextStyle(fontSize: 9.5),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      buttonConfirm(),
                      SizedBox(
                        height: 5.0,
                      ),
                      buttonCancle(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buttonConfirm() {
    return Container(
      width: 300.0,
      height: 40.0,
      child: RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Color.fromRGBO(204, 37, 44, 1.0),
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => BookingDetailState(
                  rID: rID,
                  serviceIDt: serviceIDt,
                  stpoint: stpoint,
                  dtpoint: dtpoint,
                  dateTimeCome: dateTimeCome,
                  timeservice: timeservice,
                  seatselect: selectSeat,
                  floorID: floorID),
            ),
          );
        },
        child: Text(
          'ถัดไป',
          style: TextStyle(fontSize: 22.0, color: Colors.white),
        ),
      ),
    );
  }

  buttonCancle() {
    return Container(
      width: 300.0,
      height: 40.0,
      child: RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Color.fromRGBO(54, 54, 54, 1.0),
        onPressed: () {
          Navigator.pop(context);
          MaterialPageRoute cuper =
              MaterialPageRoute(builder: (value) => Navigate());
          Navigator.push(context, cuper);
        },
        child: Text(
          'ยกเลิก',
          style: TextStyle(fontSize: 22.0, color: Colors.white),
        ),
      ),
    );
  }
}
