import 'package:flutter/material.dart';
import 'package:prampracha_app/myStyle/mystyle.dart';
import 'package:prampracha_app/screens/home.dart';

import 'comebooking.dart';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  String chooseType;
  Widget buttonConfirm() {
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
              MaterialPageRoute(builder: (value) => Navigate());
          Navigator.pushReplacement(context, cuper);
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
              MaterialPageRoute(builder: (value) => BookingCome());
          Navigator.push(context, cuper);
        },
        child: Text(
          'กลับ',
          style: TextStyle(fontSize: 22.0, color: Colors.white),
        ),
      ),
    );
  }

  Row debitRadio() => Row(
        children: <Widget>[
          Radio(
            value: 'Debit',
            groupValue: chooseType,
            onChanged: (value) {
              setState(() {
                chooseType = value;
                print(chooseType);
              });
            },
          ),
          Text(
            'เลือกชำระผ่านบัตร',
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      );
  Row serviceRadio() => Row(
        children: <Widget>[
          Radio(
            value: 'Service',
            groupValue: chooseType,
            onChanged: (value) {
              setState(() {
                chooseType = value;
                print(chooseType);
              });
            },
          ),
          Text(
            'เลือกชำระผ่านเคาน์เตอร์เซอร์วิส',
            style: TextStyle(fontSize: 18.0),
          ),
          Container(),
        ],
      );
  Row paypalRadio() => Row(
        children: <Widget>[
          Radio(
            value: 'Paypal',
            groupValue: chooseType,
            onChanged: (value) {
              setState(() {
                chooseType = value;
                print(chooseType);
              });
            },
          ),
          Text(
            'เลือกชำระผ่านเพย์แพล',
            style: TextStyle(fontSize: 18.0),
          ),
          Container(),
        ],
      );

  Widget appbarcustom() {
    return Container(
      color: MyStyle().colorbg2(),
      height: 60.0,
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            height: 10.0,
          ),
          Text('จ่ายเงิน',
              style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(100.0),
      //   child: appbarcustom(),
      // ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              child: appbarcustom(),
            ),
            Container(
              height: 550.0,
              padding: EdgeInsets.all(40.0),
              child: Column(
                children: <Widget>[
                  new Container(
                    height: 40.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.orange[700],
                    ),
                    child: Container(
                      width: 400.0,
                      child: Text(
                        'เลือกช่องทางชำระเงิน',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22.0, color: Colors.white),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      new Container(
                        child: debitRadio(),
                      ),
                      Container(
                        height: 40,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 50.0,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: MyStyle().colorsbg(),
                              ),
                              child: Image.asset(
                                'images/logo-visa.png',
                                scale: 1.0,
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: MyStyle().colorsbg()),
                              child: Image.asset(
                                'images/logo-mastercard.png',
                                scale: 1.0,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      new Container(
                        child: serviceRadio(),
                      ),
                      Container(
                        height: 40,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 50.0,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: MyStyle().colorsbg(),
                              ),
                              child: Image.asset(
                                'images/logo-เซเว่น.png',
                                scale: 1.0,
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: MyStyle().colorsbg(),
                              ),
                              child: Image.asset(
                                'images/logo-เคาน์เตอร์เซวิส.png',
                                scale: 1.0,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      new Container(
                        child: paypalRadio(),
                      ),
                      Container(
                        height: 40,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 50.0,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: MyStyle().colorsbg(),
                              ),
                              child: Image.asset(
                                'images/logo-paypal.png',
                                scale: 1.0,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 50.0),
                  Container(
                    child: buttonConfirm(),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    child: buttonCancle(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
