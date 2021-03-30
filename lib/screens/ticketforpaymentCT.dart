import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:prampracha_app/myStyle/mystyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:prampracha_app/screens/home.dart';
import 'package:prampracha_app/screens/homepage.dart';
import 'package:prampracha_app/screens/payment.dart';

class TicketForPaymentCT extends StatefulWidget {
  List putbookingsuccessC = List();
  List putbookingsuccessT = List();
  DateTime dateTimeCome;
  DateTime dateTimeTo;

  String timeserviceC;
  String timeserviceT;
  String routeNameInputC;
  String routeNameInputT;
  TicketForPaymentCT(
      {Key key,
      this.putbookingsuccessC,
      this.putbookingsuccessT,
      this.dateTimeCome,
      this.dateTimeTo,
      this.timeserviceC,
      this.timeserviceT,
      this.routeNameInputC,
      this.routeNameInputT})
      : super(key: key);

  @override
  _TicketForPaymentCTState createState() => _TicketForPaymentCTState(
      putbookingsuccessC,
      putbookingsuccessT,
      dateTimeCome,
      dateTimeTo,
      timeserviceC,
      timeserviceT,
      routeNameInputC,
      routeNameInputT);
}

class _TicketForPaymentCTState extends State<TicketForPaymentCT> {
  List putbookingsuccessC = List();
  List putbookingsuccessT = List();
  DateTime dateTimeCome;
  DateTime dateTimeTo;

  String timeserviceC;
  String timeserviceT;
  String routeNameInputC;
  String routeNameInputT;
  _TicketForPaymentCTState(
      this.putbookingsuccessC,
      this.putbookingsuccessT,
      this.dateTimeCome,
      this.dateTimeTo,
      this.timeserviceC,
      this.timeserviceT,
      this.routeNameInputC,
      this.routeNameInputT);

  @override
  void initState() {
    super.initState();
    print(putbookingsuccessC);
    print(putbookingsuccessT);
  }

  Widget appbarcustom() {
    return Container(
      height: 75.0,
      width: double.infinity,
      color: MyStyle().colorsbg(),
      child: Column(
        children: [
          SizedBox(
            height: 10.0,
          ),
          new Image.asset(
            'images/bus.png',
            scale: 20,
            color: Colors.white,
          ),
          Text('รายการจองตั๋ว',
              style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  String checkedStatusC = '';
  statusC() {
    var checkstatusC = putbookingsuccessC[0]['bookingReserve'];
    if (checkstatusC != 0) {
      checkedStatusC = 'ยังไม่ได้ชำระเงิน';
      print(checkstatusC);
      return Text(checkedStatusC);
    } else if (checkstatusC == 1) {
      checkedStatusC = 'ชำระเงินเสร็จสิ้น';
      print(checkstatusC);
      return Text(checkedStatusC);
    }
  }

  String checkedStatusT = '';
  statusT() {
    var checkstatusT = putbookingsuccessT[0]['bookingReserve'];
    if (checkstatusT != 0) {
      checkedStatusC = 'ยังไม่ได้ชำระเงิน';
      print(checkstatusT);
      return Text(checkedStatusT);
    } else if (checkstatusT == 1) {
      checkedStatusC = 'ชำระเงินเสร็จสิ้น';
      print(checkstatusT);
      return Text(checkedStatusT);
    }
  }

  Widget listbookedTicketC() {
    return Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: MediaQuery.of(context).size.width * 0.80,
            child: Card(
              color: Colors.white70,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 8,
              child: Column(
                children: [
                  ListTile(
                    title: Text(litems[0]),
                    trailing: Text(
                        "${dateTimeCome.day}-${dateTimeCome.month}-${dateTimeCome.year}"),
                    dense: true,
                  ),
                  ListTile(
                    title: Text(litems[1]),
                    trailing: Text(timeserviceC),
                    dense: true,
                  ),
                  ListTile(
                    title: Text(litems[2]),
                    trailing: Text(routeNameInputC),
                    dense: true,
                  ),
                  ListTile(
                    title: Text(litems[3]),
                    trailing: Text(putbookingsuccessC[0]['passengerName']),
                    dense: true,
                  ),
                  ListTile(
                    title: Text(litems[4]),
                    trailing: Text(putbookingsuccessC[0]['seatName']),
                    dense: true,
                  ),
                  ListTile(
                    title: Text(litems[5]),
                    trailing: Text(putbookingsuccessC[0]['netTotal']),
                    dense: true,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget listbookedTicketT() {
    return Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: MediaQuery.of(context).size.width * 0.80,
            child: Card(
              color: Colors.white70,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 8,
              child: Column(
                children: [
                  ListTile(
                    title: Text(litems[0]),
                    trailing: Text(
                        "${dateTimeTo.day}-${dateTimeTo.month}-${dateTimeTo.year}"),
                    dense: true,
                  ),
                  ListTile(
                    title: Text(litems[1]),
                    trailing: Text(timeserviceT),
                    dense: true,
                  ),
                  ListTile(
                    title: Text(litems[2]),
                    trailing: Text(routeNameInputT),
                    dense: true,
                  ),
                  ListTile(
                    title: Text(litems[3]),
                    trailing: Text(putbookingsuccessT[0]['passengerName']),
                    dense: true,
                  ),
                  ListTile(
                    title: Text(litems[4]),
                    trailing: Text(putbookingsuccessT[0]['seatName']),
                    dense: true,
                  ),
                  ListTile(
                    title: Text(litems[5]),
                    trailing: Text(putbookingsuccessT[0]['netTotal']),
                    dense: true,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buttonPayment() {
    return Container(
      width: 300.0,
      height: 35.0,
      child: RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: MyStyle().colorsbg(),
        onPressed: () {
          Navigator.pop(context);
          MaterialPageRoute cuper =
              MaterialPageRoute(builder: (value) => Payment());
          Navigator.push(context, cuper);
        },
        child: Text(
          'ชำระเงิน',
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
      ),
    );
  }

  Widget buttonCancle() {
    return Container(
      width: 300.0,
      height: 35.0,
      child: RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: MyStyle().colorbg2(),
        onPressed: () {
          Navigator.pop(context);
          MaterialPageRoute cuper =
              MaterialPageRoute(builder: (value) => Navigate());
          Navigator.push(context, cuper);
        },
        child: Text(
          'ยกเลิก',
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
      ),
    );
  }

  List<String> litems = [
    "วันที่ : ",
    "เวลาเดินทาง : ",
    "เส้นทาง : ",
    "ชื่อ-นามสกุล : ",
    "ที่นั่ง : ",
    "ราคา : "
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              child: appbarcustom(),
            ),
            Container(
              height: 322.0,
              color: Colors.grey[200],
              child: listbookedTicketC(),
            ),
             SizedBox(
              height: 2.0,
            ),
            Container(
              height: 321.0,
              color: Colors.grey[200],
              child: listbookedTicketT(),
            ),
            SizedBox(
              height: 3.0,
            ),
            Container(
              child: buttonPayment(),
            ),
            SizedBox(
              height: 2.0,
            ),
            Container(
              child: buttonCancle(),
            ),
          ],
        ),
      ),
    );
  }
}
