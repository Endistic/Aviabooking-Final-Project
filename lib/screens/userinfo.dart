import 'dart:convert';

import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:prampracha_app/data/user_data.dart';
import 'package:prampracha_app/helper/dbhelper.dart';
import 'package:prampracha_app/myStyle/mystyle.dart';
import 'package:flutter/cupertino.dart';
import 'home.dart';
import 'package:prampracha_app/model/user_model.dart';

class UserInfo extends StatefulWidget {
  String email;

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  List<User> user = new List<User>();

  List<Contact> _contacts = [];
  DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Widget buttoncancle() {
    return Container(
      width: 350.0,
      height: 50.0,
      child: RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: MyStyle().colorbg2(),
        onPressed: () {
          Navigator.pop(context);
          MaterialPageRoute cuper =
              MaterialPageRoute(builder: (value) => Navigate());
          Navigator.pushReplacement(context, cuper);
        },
        child: Text(
          'กลับ',
          style: TextStyle(fontSize: 22.0, color: Colors.white),
        ),
      ),
    );
  }

  // Widget editbutton() {
  //   return Container(
  //     width: 350.0,
  //     height: 50.0,
  //     child: RaisedButton(
  //       shape:
  //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
  //       color: Colors.orange[400],
  //       onPressed: () {
  //         MaterialPageRoute cuper =
  //             MaterialPageRoute(builder: (value) => Edit());
  //         Navigator.pushReplacement(context, cuper);
  //       },
  //       child: Text(
  //         'แก้ไข',
  //         style: TextStyle(fontSize: 22.0, color: Colors.white),
  //       ),
  //     ),
  //   );
  // }

  Widget blox() {
    return Container(
      height: 100.0,
      width: double.infinity,
      color: MyStyle().colorsbg(),
      child: Column(
        children: [
          Image.asset(
            'images/icon-8.png',
            scale: 10.0,
            color: Colors.white,
          ),
          SizedBox(height: 10.0),
          Text('ข้อมูลผู้ใช้',
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fatchData();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(255, 255, 255, 0.8),
        title: MyStyle().showAppBarLogo(),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            blox(),
            Container(
              height: 300.0,
              child: new FutureBuilder<List<User>>(
                future: fetchUser(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List<User> user = snapshot.data;
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: user.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          alignment: Alignment.topCenter,
                          width: screenWidth,
                          child: ListView(
                            children: <Widget>[
                              ListTile(
                                title: Text('ชื่อ : '),
                                trailing: Text(
                                  user[index].name,
                                ),
                              ),
                              SizedBox(
                                height: 2.0,
                                child: Container(
                                  color: Colors.grey,
                                ),
                              ),
                              ListTile(
                                title: Text('นามสกุล : '),
                                trailing: Text(
                                  user[index].surname,
                                ),
                              ),
                              SizedBox(
                                height: 2.0,
                                child: Container(
                                  color: Colors.grey,
                                ),
                              ),
                              ListTile(
                                title: Text('อีเมล : '),
                                trailing: Text(
                                  user[index].email,
                                ),
                              ),
                              SizedBox(
                                height: 2.0,
                                child: Container(
                                  color: Colors.grey,
                                ),
                              ),
                              ListTile(
                                title: Text('เบอร์โทรศัพท์ : '),
                                trailing: Text(
                                  user[index].tel,
                                ),
                              ),
                              SizedBox(
                                height: 2.0,
                                child: Container(
                                  color: Colors.grey,
                                ),
                              ),
                              ListTile(
                                title: Text('เลขบัตรประชาชน : '),
                                trailing: Text(
                                  user[index].idNo,
                                ),
                              ),
                              SizedBox(
                                height: 2.0,
                                child: Container(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                  return CircularProgressIndicator();
                },
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            buttoncancle(),
          ],
        ),
      ),
    );
  }

  Future<List<User>> fetchUser() async {
    var id = _contacts[0].uId;
    print(id);
    final response = await http.get(
        'https://premprachatransports.com/flutter_app/userinfo/get_user.php?id=$id');
    String logResponse = response.statusCode.toString();
    if (response.statusCode == 200) {
      print('ResponseStatusCode: $logResponse'); // Check Status Code = 200
      print('ResponseBody: ' + response.body); // Read Data in Array
      List<dynamic> responseJson = json.decode(response.body);
      return responseJson.map((m) => new User.fromJson(m)).toList();
    } else {
      throw Exception('error :(');
    }
  }

  _fatchData() async {
    List<Contact> data = await _dbHelper.fetchContacts();
    setState(() {
      _contacts = data;
      print(_contacts);
      fetchUser();
    });
  }
}
