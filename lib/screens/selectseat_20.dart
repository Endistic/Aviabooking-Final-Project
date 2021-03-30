import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prampracha_app/helper/bookfee.dart';
import 'package:prampracha_app/myStyle/mystyle.dart';
import 'package:item_selector/item_selector.dart';
import 'package:prampracha_app/screens/bookingdetail.dart';
import 'package:prampracha_app/screens/detail.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:prampracha_app/screens/comebooking.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:prampracha_app/myStyle/normal_dialog_pls.dart';

import 'bookingComeTo.dart';

// ignore: must_be_immutable
class SelectSeatFromTo extends StatefulWidget {
  List seatf = List();
  List seatt = List();
  var serviceIDf;
  var serviceIDt;
  var rID_from;
  var rID_To;
  var stpoint_c;
  var stpoint_t;
  var dtpoint_c;
  var dtpoint_t;
  DateTime dateTimeCome;
  DateTime dateTimeOff;
  String timeserviceC;
  String timeserviceT;
  SelectSeatFromTo(
      {Key key,
      @required this.seatf,
      this.seatt,
      this.serviceIDf,
      this.serviceIDt,
      this.rID_from,
      this.rID_To,
      this.stpoint_c,
      this.stpoint_t,
      this.dtpoint_c,
      this.dtpoint_t,
      this.dateTimeCome,
      this.dateTimeOff,
      this.timeserviceC,
      this.timeserviceT})
      : super(key: key);

  @override
  _SelectSeatFromToState createState() => _SelectSeatFromToState(
        seatf,
        seatt,
        serviceIDf,
        serviceIDt,
        rID_from,
        rID_To,
        stpoint_c,
        stpoint_t,
        dtpoint_c,
        dtpoint_t,
        dateTimeCome,
        dateTimeOff,
        timeserviceC,
        timeserviceT,
      );
}

class _SelectSeatFromToState extends State<SelectSeatFromTo>
    with SingleTickerProviderStateMixin {
  List seatf = List();
  List seatt = List();
  var serviceIDf;
  var serviceIDt;
  var selectseatf;
  var selectseatt;
  var rID_from;
  var rID_To;
  var stpoint_c;
  var stpoint_t;
  var dtpoint_c;
  var dtpoint_t;
  DateTime dateTimeCome;
  DateTime dateTimeOff;
  String timeserviceC;
  String timeserviceT;
  _SelectSeatFromToState(
      this.seatf,
      this.seatt,
      this.serviceIDf,
      this.serviceIDt,
      this.rID_from,
      this.rID_To,
      this.stpoint_c,
      this.stpoint_t,
      this.dtpoint_c,
      this.dtpoint_t,
      this.dateTimeCome,
      this.dateTimeOff,
      this.timeserviceC,
      this.timeserviceT);
  TabController _tabController;

  startTime() async {
    var _duration = new Duration(seconds: 60);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    normalDialog_pls(context, 'กรุณาทำรายการใหม่');
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    // startTime();
    print('---------------------------------------');
    print(seatf);
    print(seatt);
    print("------------------Data Set-------------");
    print(rID_from);
    print(rID_To);
    print(stpoint_c);
    print(dtpoint_c);

    print(stpoint_t);
    print(dtpoint_t);
    print(dateTimeCome);
    print(dateTimeOff);
    print(timeserviceC);
    print(timeserviceT);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: MyStyle().colorbg2(),
        centerTitle: true,
        title: Text(
          'Select Seat',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[300],
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: MyStyle().colorsbg(),
                    ),
                    height: 30.0,
                    child: TabBar(
                      indicatorColor: Colors.white,
                      labelColor: Colors.black,
                      controller: _tabController,
                      tabs: <Widget>[
                        Tab(
                          text: 'เส้นทางไป',
                        ),
                        Tab(
                          text: 'เส้นทางกลับ',
                        ),
                      ],
                    ),
                  ),
                ),
                new Container(
                  height: 560,
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      new Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            new Container(
                              height: 485,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: WebView(
                                initialUrl:
                                    'https://premprachatransports.com/flutter_app/select-seat/selectseat.php?sID=$serviceIDf',
                              ),
                            ),
                            new Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                height: 25,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    color: Colors.white),
                                child: new DropdownButtonFormField(
                                  decoration: InputDecoration.collapsed(
                                      hintText: 'เลือกที่นั่ง'),
                                  focusColor: Colors.amber,
                                  value: selectseatf,
                                  items: seatf.map((route) {
                                    return DropdownMenuItem(
                                      value: route['seat_name'],
                                      child: Text(
                                          'Seat No : ' + route['seat_name']),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectseatf = value;
                                      print(selectseatf);
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      new Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            new Container(
                              height: 480,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: WebView(
                                initialUrl:
                                    'https://premprachatransports.com/flutter_app/select-seat/selectseat.php?sID=$serviceIDt',
                              ),
                            ),
                            new Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                height: 25,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    color: Colors.white),
                                child: new DropdownButtonFormField(
                                  decoration: InputDecoration.collapsed(
                                      hintText: 'เลือกที่นั่ง'),
                                  focusColor: Colors.amber,
                                  value: selectseatt,
                                  items: seatt.map((route) {
                                    return DropdownMenuItem(
                                      value: route['seat_name'],
                                      child: Text(
                                          'Seat No : ' + route['seat_name']),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectseatt = value;
                                      print(selectseatt);
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  child: Text(
                    "มีค่าบริการในการเลือกที่นั่ง ถ้าไม่ต้องการเลือกกดปุ่มถัดไป",
                    // "*Additional charge for select seat if don't want select press the confirm button",
                    style: TextStyle(fontSize: 9.5),
                    textAlign: TextAlign.center,
                  ),
                ),
                new Container(
                  child: buttonConfirm(),
                ),
                SizedBox(
                  height: 5.0,
                ),
                new Container(
                  child: buttonCancle(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buttonConfirm() {
    return Container(
      width: 300.0,
      height: 45.0,
      child: RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: MyStyle().colorsbg(),
        onPressed: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => BookingDetailComeTo(
              seatselectc: selectseatf,
              seatselectt: selectseatt,
              serviceIDc: serviceIDf,
              serviceIDt: serviceIDt,
              rIDc: rID_from,
              rIDt: rID_To,
              stpointC: stpoint_c,
              dtpointC: dtpoint_c,
              stpointT: stpoint_t,
              dtpointT: dtpoint_t,
              dateTimeCome: dateTimeCome,
              dateTimeTo: dateTimeOff,
              timeserviceC: timeserviceC,
              timeserviceT: timeserviceT,
            ),
          ));
        },
        child: Text(
          'ถัดไป',
          style: TextStyle(fontSize: 22.0, color: Colors.white),
        ),
      ),
    );
  }

  Widget buttonCancle() {
    return Container(
      width: 300.0,
      height: 45.0,
      child: RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: MyStyle().colorbg2(),
        onPressed: () {
          Navigator.pop(context);
          MaterialPageRoute cuper =
              MaterialPageRoute(builder: (value) => Booking());
          Navigator.pushReplacement(context, cuper);
        },
        child: Text(
          'กลับ',
          style: TextStyle(fontSize: 22.0, color: Colors.white),
        ),
      ),
    );
  }
}
