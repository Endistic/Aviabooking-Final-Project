import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prampracha_app/helper/dbhelper.dart';
import 'package:prampracha_app/model/uid_model.dart';
import 'package:prampracha_app/model/user_model.dart';
import 'package:prampracha_app/myStyle/mystyle.dart';
import 'package:prampracha_app/myStyle/normail_dialog.dart';
import 'package:prampracha_app/screens/home.dart';
import 'package:prampracha_app/screens/login.dart';

import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String name, surname, tel, noId, email, password;

  Contact _contact = Contact();
  List<Contact> _contacts = [];
  DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Widget nameForm() {
    return Container(
      width: 350.0,
      child: TextField(
        onChanged: (value) => name = value.trim(),
        decoration: InputDecoration(
          labelText: 'Name (ชื่อ): ',
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
        ),
      ),
    );
  }

  Widget surnameForm() {
    return Container(
      width: 350.0,
      child: TextField(
        onChanged: (value) => surname = value.trim(),
        decoration: InputDecoration(
          labelText: 'Surname (นามสกุล): ',
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
        ),
      ),
    );
  }

  Widget telForm() {
    return Container(
      width: 350.0,
      child: TextField(
        onChanged: (value) => tel = value.trim(),
        decoration: InputDecoration(
          labelText: 'Tel. (เบอร์โทร): ',
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
        ),
      ),
    );
  }

  Widget emailForm() {
    return Container(
      width: 350.0,
      child: TextField(
        onChanged: (value) {
          email = value.trim();
          setState(() {
            _contact.email = email;
          });
        },
        decoration: InputDecoration(
          labelText: 'Email (อีเมลล์): ',
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
        ),
      ),
    );
  }

  Widget idcardForm() {
    return Container(
      width: 350.0,
      child: TextField(
        onChanged: (value) => noId = value.trim(),
        decoration: InputDecoration(
          labelText: 'ID No. (เลขบัตรประชาชน): ',
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
        ),
      ),
    );
  }

  Widget passwordForm() {
    return Container(
      width: 350.0,
      child: TextField(
        onChanged: (value) {
          password = value.trim();
          setState(() {
            _contact.password = email;
          });
        },
        decoration: InputDecoration(
          labelText: 'Password (รหัสผ่าน): ',
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
        ),
      ),
    );
  }

  Widget blox() {
    return Container(
      height: 100.0,
      width: double.infinity,
      color: MyStyle().colorsbg(),
      child: Column(
        children: [
          Text('ลงทะเบียน',
              style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          SizedBox(height: 10.0),
          Text('เพื่อรับสิทธิในการจองตั๋วผ่านแอพเปรมประชา',
              style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget buttonregistor() {
    return Container(
      width: 350.0,
      height: 80.0,
      child: RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: MyStyle().colorsbg(),
        onPressed: () {
          print(
              'name = $name, surname $surname, tel = $tel, email = $email, idNo = $noId, password = $password');
          if (name == null ||
              surname == null ||
              tel == null ||
              email == null ||
              noId == null ||
              password == null) {
            print('Have Space');
            normalDialog(context, 'กรุณากรอกให้ครบทุกช่อง');
          } else {
            registerThread();
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => Navigate()));
          }
        },
        child: Text(
          'Register\nลงทะเบียน',
          style: TextStyle(fontSize: 22.0, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future registerThread() async {
    var url =
        "https://premprachatransports.com/flutter_app/register/register_index.php?isAdd=true&name=$name&surname=$surname&tel=$tel&email=$email&idNo=$noId&password=$password";

    final response = await http.get(url);

    print(response.body);

    var message = json.decode(response.body);

    if (message.toString() == 'true') {
      _onRegister();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginTo()));
    } else {
      normalDialog(context, 'กรุณาลองใหม่');
    }
  }

  Widget buttoncancle() {
    return Container(
      width: 350.0,
      height: 80.0,
      child: RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Colors.grey[300],
        onPressed: () {
          Navigator.pop(context);
          CupertinoPageRoute cuper =
              CupertinoPageRoute(builder: (value) => LoginTo());
          Navigator.push(context, cuper);
        },
        child: Text(
          'Cancel\nยกเลิก',
          style: TextStyle(fontSize: 22.0, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  String dropdownValue = 'EN';
  Widget dropdownLang() {
    return Container(
      height: 40.0,
      width: 50.0,
      child: DropdownButton(
        value: dropdownValue,
        onChanged: (String newValue) {
          setState(() {
            dropdownValue = newValue;
            print(dropdownValue);
          });
        },
        items:
            <String>['EN', 'TH'].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          children: <Widget>[
            blox(),
            SizedBox(height: 20.0),
            new Container(
              margin: new EdgeInsets.only(left: 20.0, right: 20.0),
              decoration: new BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  border: new Border.all(width: 1.2, color: Colors.black12),
                  borderRadius: BorderRadius.all(const Radius.circular(10.0))),
              child: nameForm(),
            ),
            SizedBox(height: 10.0),
            new Container(
              margin: new EdgeInsets.only(left: 20.0, right: 20.0),
              decoration: new BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  border: new Border.all(width: 1.2, color: Colors.black12),
                  borderRadius: BorderRadius.all(const Radius.circular(10.0))),
              child: surnameForm(),
            ),
            SizedBox(height: 10.0),
            new Container(
              margin: new EdgeInsets.only(left: 20.0, right: 20.0),
              decoration: new BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  border: new Border.all(width: 1.2, color: Colors.black12),
                  borderRadius: BorderRadius.all(const Radius.circular(10.0))),
              child: telForm(),
            ),
            SizedBox(height: 10.0),
            new Container(
              margin: new EdgeInsets.only(left: 20.0, right: 20.0),
              decoration: new BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  border: new Border.all(width: 1.2, color: Colors.black12),
                  borderRadius: BorderRadius.all(const Radius.circular(10.0))),
              child: emailForm(),
            ),
            SizedBox(height: 10.0),
            new Container(
              margin: new EdgeInsets.only(left: 20.0, right: 20.0),
              decoration: new BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  border: new Border.all(width: 1.2, color: Colors.black12),
                  borderRadius: BorderRadius.all(const Radius.circular(10.0))),
              child: idcardForm(),
            ),
            SizedBox(height: 10.0),
            new Container(
              margin: new EdgeInsets.only(left: 20.0, right: 20.0),
              decoration: new BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  border: new Border.all(width: 1.2, color: Colors.black12),
                  borderRadius: BorderRadius.all(const Radius.circular(10.0))),
              child: passwordForm(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                dropdownLang(),
                Container(
                  child: Text(
                    'Select Language\t(เลือกภาษา)',
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.0),
            buttonregistor(),
            SizedBox(height: 10.0),
            buttoncancle(),
            SizedBox(height: 10.0),
            // _list(),
          ],
        )),
      ),
    );
  }

  _onRegister() async {
    var url_get =
        "https://premprachatransports.com/flutter_app/register/register_select.php?email=$email&password=$password";
    final response_get = await http.get(url_get);
    var jsonResponse = json.decode(response_get.body);
    print(jsonResponse);

    _contact.uId = jsonResponse['id'].toString();
    if (_contact.id == null)
      await _dbHelper.insertContact(_contact);
    else
      normalDialog(context, 'กรุณาลองใหม่');
    setState(() {
      _contacts.add(_contact);
    });
  }
}
