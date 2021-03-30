import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:prampracha_app/myStyle/mystyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:prampracha_app/screens/home.dart';
import 'package:prampracha_app/screens/homepage.dart';
import 'package:prampracha_app/screens/payment.dart';

class TicketForPayment extends StatefulWidget {
  List putbookingsuccess = List();
  DateTime dateTimeCome;
  String timeservice;
  String routeNameInput;
  TicketForPayment(
      {Key key,
      this.putbookingsuccess,
      this.dateTimeCome,
      this.timeservice,
      this.routeNameInput})
      : super(key: key);

  @override
  _TicketForPaymentState createState() => _TicketForPaymentState(
      putbookingsuccess, dateTimeCome, timeservice, routeNameInput);
}

class _TicketForPaymentState extends State<TicketForPayment> {
  List putbookingsuccess = List();
  DateTime dateTimeCome;
  String timeservice;
  String routeNameInput;
  _TicketForPaymentState(this.putbookingsuccess, this.dateTimeCome,
      this.timeservice, this.routeNameInput);
  @override
  void initState() {
    super.initState();
    print(putbookingsuccess);
    print(dateTimeCome);
    print(timeservice);
    print(routeNameInput);
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

  String checkedStatus = '';
  status() {
    var checkstatus = putbookingsuccess[0]['bookingReserve'];
    if (checkstatus != 0) {
      checkedStatus = 'ยังไม่ได้ชำระเงิน';
      print(checkstatus);
      return Text(checkedStatus);
    } else if (checkstatus == 1) {
      checkedStatus = 'ชำระเงินเสร็จสิ้น';
      print(checkstatus);
      return Text(checkedStatus);
    }
  }

  Widget listTicket() {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) {
        return Container(
          height: MediaQuery.of(context).size.width * 0.90,
          child: Card(
            color: Colors.white70,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 8,
            child: Container(
              child: Column(
                children: [
                  new ListTile(
                    title: Text(litems[0]),
                    trailing: Text(
                        "${dateTimeCome.day}-${dateTimeCome.month}-${dateTimeCome.year}"),
                    dense: true,
                  ),
                  new ListTile(
                    title: Text(litems[1]),
                    trailing: Text(timeservice),
                    dense: true,
                  ),
                  new ListTile(
                    title: Text(litems[2]),
                    trailing: Text(routeNameInput),
                    dense: true,
                  ),
                  new ListTile(
                    title: Text(litems[3]),
                    trailing: Text(putbookingsuccess[0]['seatName']),
                    dense: true,
                  ),
                  new ListTile(
                    title: Text(litems[4]),
                    trailing: Text(putbookingsuccess[0]['passengerName']),
                    dense: true,
                  ),
                  new ListTile(
                    title: Text(litems[5]),
                    trailing: Text(putbookingsuccess[0]['netTotal']),
                    dense: true,
                  ),
                  new ListTile(
                    title: Text(litems[6]),
                    trailing: status(),
                    dense: true,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buttonPayment() {
    return Container(
      width: 300.0,
      height: 45.0,
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

  List<String> litems = [
    "วันที่ : ",
    "เวลาเดินทาง : ",
    "เส้นทาง : ",
    "ชื่อ-นามสกุล : ",
    "ที่นั่ง : ",
    "ราคา : ",
    "สถานะ : ",
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
              height: 370.0,
              color: Colors.grey[200],
              child: listTicket(),
            ),
            SizedBox(height: 10.0),
            Container(
              child: buttonPayment(),
            ),
            SizedBox(height: 10.0),
            Container(
              child: buttonCancle(),
            ),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
