import 'dart:convert';

import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:prampracha_app/data/user_data.dart';
import 'package:prampracha_app/helper/dbhelper.dart';
import 'package:prampracha_app/model/user_model.dart';
import 'package:prampracha_app/myStyle/mystyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:prampracha_app/myStyle/normal_dialog_pls.dart';
import 'package:prampracha_app/myStyle/success_dialog.dart';
import 'package:prampracha_app/screens/ticketforpayment.dart';
import 'package:prampracha_app/screens/ticketforpayment.dart';
import 'comebooking.dart';

// ignore: must_be_immutable
class BookingDetailState extends StatefulWidget {
  String seatselect;
  var serviceIDt;
  var rID;
  var stpoint;
  var dtpoint;

  var floorID;
  DateTime dateTimeCome;
  String timeservice;
  BookingDetailState(
      {Key key,
      this.seatselect,
      this.serviceIDt,
      this.rID,
      this.stpoint,
      this.dtpoint,
      this.dateTimeCome,
      this.timeservice,
      this.floorID})
      : super(key: key);
  @override
  _BookingDetailState createState() => _BookingDetailState(serviceIDt, rID,
      stpoint, dtpoint, dateTimeCome, timeservice, seatselect, floorID);
}

class _BookingDetailState extends State<BookingDetailState> {
  List<User> user = new List<User>();
  List<Contact> _contacts = [];
  DatabaseHelper _dbHelper = DatabaseHelper.instance;

  String seatselect;
  var serviceIDt;
  var rID;
  var stpoint;
  var dtpoint;
  DateTime dateTimeCome;
  String chooseType;
  String name;
  String timeservice;
  var floorID;
  List userName = List();

  _BookingDetailState(this.serviceIDt, this.rID, this.stpoint, this.dtpoint,
      this.dateTimeCome, this.timeservice, this.seatselect, this.floorID);
  @override
  void initState() {
    super.initState();
    print(seatselect);
    print(serviceIDt);
    print(rID);
    print(stpoint);
    print(dtpoint);
    print(dateTimeCome);
    print(timeservice);
    print(floorID);
    getRouteName();
    _fatchData();
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
          _putbooking();
        },
        child: Text(
          'ดำเนินการจองตั๋ว',
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
          'ยกเลิก',
          style: TextStyle(fontSize: 22.0, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> litems = [
      "วันที่ : ",
      "เวลาเดินทาง : ",
      "เส้นทาง : ",
      "ชื่อ-นามสกุล : ",
      "ราคา : ",
    ];
    List<dynamic> litems_var = [
      serviceIDt,
      timeservice,
      routeNameInput,
      name,
      price.toString(),
    ];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: MyStyle().colorbg2(),
        centerTitle: true,
        title: Text(
          'รายการจองตั๋ว',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: SafeArea(
          top: true,
          maintainBottomViewPadding: true,
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  height: 550,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 5)),
                        height: 280.0,
                        width: 350.0,
                        //input data
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
                                trailing: Text("${timeservice}"),
                                dense: true,
                              ),
                              new ListTile(
                                title: Text(litems[2]),
                                trailing: Text("${routeNameInput}"),
                                dense: true,
                              ),
                              new ListTile(
                                title: Text(litems[3]),
                                trailing: Text("${name}" + "\t" + "${surname}"),
                                dense: true,
                              ),
                              new ListTile(
                                title: Text(litems[4]),
                                trailing: Text("${price.toString() + '\tบาท'}"),
                                dense: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      buttonConfirm(),
                      SizedBox(
                        height: 10.0,
                      ),
                      buttonCancle(),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int price = 0;
  _onPrice() async {
    final response = await http.get(
        'https://premprachatransports.com/flutter_app/booking/calprice2.php?startPointID=$stpoint&stopPointID=$dtpoint&sDate=$dateTimeCome');
    if (response.statusCode == 200) {
      var priceData = json.decode(response.body);
      setState(() {
        price = priceData;
      });
    }
  }

  String routeNameInput;
  List routeName = List();
  getRouteName() async {
    var url =
        "https://premprachatransports.com/flutter_app/booking/routename.php?routeID=$rID";
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      setState(() {
        _onPrice();
        routeName = jsonData;
        routeNameInput = routeName.first['thName'];
      });
    }
    print(routeName);
  }

  String surname;
  String tel;
  String email;
  String idNo;
  var fullname = '';
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
        surname = userName[0]["surname"];
        tel = userName[0]["tel"];
        email = userName[0]["email"];
        idNo = userName[0]["idNo"];
        fullname = name + surname;
        print(userName);
        print(name);
        print(surname);
        print(tel);
        print(email);
        print(idNo);
      });
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

  List dataBooking = List();
  var bookingNO;
  var bookingDATE;
  Future _putbooking() async {
    var url =
        'https://premprachatransports.com/flutter_app/booking/putbooking.php?sID=$serviceIDt&travelFrom=$stpoint&travelTo=$dtpoint&passengerName=$fullname&passengerTel=$tel&passengerCardID=$idNo&passengerEmail=$email&sDate=$dateTimeCome&seatName=$seatselect';
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var putData = json.decode(response.body);
      setState(() {
        dataBooking = putData;
        bookingNO = dataBooking[0]["bookingNo"];
        bookingDATE = dataBooking[0]["bookingDate"];
        insertlog();
      });
    }
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => TicketForPayment(
          putbookingsuccess: dataBooking,
          dateTimeCome: dateTimeCome,
          timeservice: timeservice,
          routeNameInput: routeNameInput,
        ),
      ),
      result: successDialog_C(context, "จองตั๋วสำเร็จ"),
    );
  }

  insertlog() async {
    var url =
        'https://premprachatransports.com/flutter_app/booking_log/mobile_log.php?bookingNo=$bookingNO&passengerName=$fullname&passengerCardID=$idNo&bookingDate=$bookingDATE';
    final response = await http.get(url);
    if (response.statusCode == 200) {
      json.decode(response.body);
    }
  }
}
