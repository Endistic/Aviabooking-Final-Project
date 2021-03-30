import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:prampracha_app/data/user_data.dart';
import 'package:prampracha_app/helper/dbhelper.dart';
import 'package:prampracha_app/model/user_model.dart';
import 'package:prampracha_app/myStyle/mystyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class TicketList extends StatefulWidget {
  @override
  _TicketListState createState() => _TicketListState();
}

class _TicketListState extends State<TicketList> {
  List<User> user = new List<User>();
  List<Contact> _contacts = [];
  DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List userName = List();

  @override
  void initState() {
    super.initState();
    _fatchData();
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
          Text('ข้อมูลการเดินทาง',
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
  status(index) {
    var checkstatus = databooked[index]['bookingReserve'];
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
      itemCount: databooked.length,
      itemBuilder: (context, index) {
        return Container(
          height: MediaQuery.of(context).size.width * 0.70,
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
                    trailing: Text(databooked[index]['bookingNo']),
                    dense: true,
                  ),
                  new ListTile(
                    title: Text(litems[1]),
                    trailing: Text(databooked[index]['seatName']),
                    dense: true,
                  ),
                  new ListTile(
                    title: Text(litems[2]),
                    trailing: Text(databooked[index]['passengerName']),
                    dense: true,
                  ),
                  new ListTile(
                    title: Text(litems[3]),
                    trailing: Text(databooked[index]['netTotal']),
                    dense: true,
                  ),
                  new ListTile(
                    title: Text(litems[4]),
                    trailing: status(index),
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

  List<String> litems = [
    "รหัสตั๋ว : ",
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
              height: 600.0,
              color: Colors.grey[200],
              child: listTicket(),
            ),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }

  String name;
  String sername;
  String tel;
  String email;
  String idNo;
  var fullname;
  Future fetchUser() async {
    var id = _contacts[0].uId;
    print(id);
    final response = await http.get(
        'https://premprachatransports.com/flutter_app/userinfo/get_user.php?id=$id');
    if (response.statusCode == 200) {
      // print('ResponseStatusCode: $logResponse'); // Check Status Code = 200
      // print('ResponseBody: ' + response.body); // Read Data in Array
      var jsonDataUser = json.decode(response.body);
      setState(() {
        userName = jsonDataUser;
        name = userName[0]["name"];
        sername = userName[0]["surname"];
        tel = userName[0]["tel"];
        email = userName[0]["email"];
        idNo = userName[0]["idNo"];
        print(name);
        print(sername);
        print(tel);
        print(email);
        print(idNo);
        print(jsonDataUser);
      });
      _onbooked();
      return jsonDataUser;
    } else {
      throw Exception('error :(');
    }
  }

  _fatchData() async {
    List<Contact> data = await _dbHelper.fetchContacts();
    _contacts = data;
    setState(() {
      fetchUser();
    });
  }

  List databooked = List();
  _onbooked() async {
    final response = await http.get(
        'https://premprachatransports.com/flutter_app/history/history.php?passengerCardID=$idNo');
    if (response.statusCode == 200) {
      var jsonDataUser = json.decode(response.body);
      setState(() {
        databooked = jsonDataUser;
        print(databooked);
      });
    }
  }
}
