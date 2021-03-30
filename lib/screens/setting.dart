import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prampracha_app/myStyle/mystyle.dart';

import 'package:prampracha_app/screens/routeinfo.dart';
import 'package:prampracha_app/screens/ticketforpayment.dart';
import 'package:prampracha_app/screens/ticketforpaymentCT.dart';
import 'package:prampracha_app/screens/ticketlis.dart';

import 'package:prampracha_app/screens/userinfo.dart';
import 'package:prampracha_app/screens/usertesting.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  List<String> routes = [
    'ข้อมูลผู้ใช้งาน',
    'ข้อมูลการเดินทาง',
    'รายการจองตั๋วไปล่าสุด',
    'รายการจองตั๋วไป-กลับล่าสุด'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        backgroundColor: MyStyle().colorsbg(),
        title: Text(
          'จัดการข้อมูล',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            //ListView Menu
            Container(
              height: 300.0,
              color: Colors.grey,
              child: Card(
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage('images/icon-8.png'),
                        radius: 15.0,
                      ),
                      title: Text(
                        routes[0],
                        style:
                            TextStyle(fontSize: 18.0, color: Colors.grey[700]),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        CupertinoPageRoute cuper =
                            CupertinoPageRoute(builder: (value) => UserInfo());
                        Navigator.push(context, cuper);
                      },
                    ),
                    SizedBox(
                      height: 2.0,
                      child: Container(
                        color: Colors.grey,
                      ),
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage('images/bus-2.png'),
                        radius: 15.0,
                      ),
                      title: Text(
                        routes[1],
                        style:
                            TextStyle(fontSize: 18.0, color: Colors.grey[700]),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        MaterialPageRoute cuper =
                            MaterialPageRoute(builder: (value) => RouteInfo());
                        Navigator.push(context, cuper);
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                      child: Container(
                        color: Colors.grey,
                      ),
                    ),
                    // ListTile(
                    //   leading: CircleAvatar(
                    //     backgroundColor: Colors.white,
                    //     backgroundImage: AssetImage('images/bus-2.png'),
                    //     radius: 15.0,
                    //   ),
                    //   title: Text(
                    //     routes[2],
                    //     style:
                    //         TextStyle(fontSize: 18.0, color: Colors.grey[700]),
                    //   ),
                    //   onTap: () {
                    //     Navigator.pop(context);
                    //     MaterialPageRoute cuper = MaterialPageRoute(
                    //         builder: (value) => TicketForPayment());
                    //     Navigator.push(context, cuper);
                    //   },
                    // ),
                    // SizedBox(
                    //   height: 2.0,
                    //   child: Container(
                    //     color: Colors.grey,
                    //   ),
                    // ),
                    // ListTile(
                    //   leading: CircleAvatar(
                    //     backgroundColor: Colors.white,
                    //     backgroundImage: AssetImage('images/bus-2.png'),
                    //     radius: 15.0,
                    //   ),
                    //   title: Text(
                    //     routes[3],
                    //     style:
                    //         TextStyle(fontSize: 18.0, color: Colors.grey[700]),
                    //   ),
                    //   onTap: () {
                    //     Navigator.pop(context);
                    //     MaterialPageRoute cuper = MaterialPageRoute(
                    //         builder: (value) => TicketForPaymentCT());
                    //     Navigator.push(context, cuper);
                    //   },
                    // ),
                    // SizedBox(
                    //   height: 2.0,
                    //   child: Container(
                    //     color: Colors.grey,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[300],
    );
  }
}
