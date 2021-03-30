import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:prampracha_app/myStyle/mystyle.dart';
import 'package:prampracha_app/screens/oneway.dart';
import 'package:prampracha_app/screens/rebooking.dart';
import 'package:prampracha_app/screens/setting.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

int index = 0;
Widget mySizebox() {
  return SizedBox(height: 10.0);
}

Widget mySizebox2() {
  return SizedBox(width: 10.0);
}

final String booking = 'จองตั๋ว';
final String rebooking = 'เลื่อนตั๋ว';
final String checkbooking = 'เช็คตั๋ว';

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    double screenHight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: MyStyle().showAppBarLogo(),
        backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.settings,
                color: Color.fromRGBO(204, 37, 44, 1.0),
              ),
              onPressed: () {
                CupertinoPageRoute cuper =
                    CupertinoPageRoute(builder: (value) => Setting());
                Navigator.push(context, cuper);
              })
        ],
      ),
      body: Container(
        height: screenHight,
        child: new SafeArea(
            child: Column(
          children: <Widget>[
            
            Container(
              height: 200.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/11365.jpg"),
                  fit: BoxFit.fitWidth,
                ),
              ),
              child: Column(
                children: <Widget>[
                  mySizebox(),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new CircleAvatar(
                        radius: 70.0,
                        backgroundColor: Color.fromRGBO(236, 77, 82, 1.0),
                        child: IconButton(
                          icon: Image.asset(
                            'images/icon-จองตั๋ว.png',
                          ),
                          iconSize: 170.0,
                          onPressed: () {
                            MaterialPageRoute cuper =
                                MaterialPageRoute(builder: (value) => Type());
                            Navigator.pushReplacement(context, cuper);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 50.0,
                      ),
                      new CircleAvatar(
                        radius: 70.0,
                        backgroundColor: Color.fromRGBO(236, 77, 82, 1.0),
                        child: IconButton(
                            icon: Image.asset('images/icon-เลื่อนตั๋ว.png'),
                            iconSize: 170.0,
                            onPressed: () {
                              MaterialPageRoute cuper = MaterialPageRoute(
                                  builder: (value) => ReBooking());
                              Navigator.pushReplacement(context, cuper);
                            }),
                      ),
                      // SizedBox(
                      //   height: 10.0,
                      // )
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Center(
                  child: Text(
                    'ประกาศสำคัญ',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                Container(
                  color: Colors.grey[300],
                  height: 410.0,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      color: Colors.white70,
                      child: listcard1(),
                    ),
                  ),
                ),
              ],
            ),
            // Container(
            //   height: 7.0,
            //   color: Colors.orange,
            // ),
            // Container(
            //   height: 3.0,
            //   color: Color.fromRGBO(254, 137, 42, 0.5),
            // )
          ],
        )),
      ), //Block
    );
  }
}

class listcard1 extends StatefulWidget {
  const listcard1({
    Key key,
  }) : super(key: key);

  @override
  _listcard1State createState() => _listcard1State();
}

// ignore: camel_case_types
class _listcard1State extends State<listcard1> {
  @override
  Widget build(BuildContext context) {
    double screenHight = MediaQuery.of(context).size.height;
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          height: MediaQuery.of(context).size.width * 0.45,
          child: Card(
            color: Colors.white70,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 8,
            child: InkWell(
              highlightColor: Colors.orange,
              splashColor: Colors.orange,
              borderRadius: BorderRadius.circular(12.0),
              //input data
              onTap: () {},
              child: Center(),
            ),
          ),
        );
      },
    );
  }
}
