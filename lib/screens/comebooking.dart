import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:prampracha_app/myStyle/normal_dialog_pls.dart';
import 'dart:convert';
import 'package:prampracha_app/screens/home.dart';

import 'package:prampracha_app/screens/selectseat_14.dart';
import 'package:http/http.dart' as http;

class BookingCome extends StatefulWidget {
  @override
  _BookingComeState createState() => _BookingComeState();
}

class _BookingComeState extends State<BookingCome>
    with SingleTickerProviderStateMixin {
  DateTime dateTimeCome;
  DateTime dateTimeOff;
  int cindex = 0;
  int p_num = 0;
  TabController _tabController;
  TextEditingController _textController;

  var selectedValueFrom;
  String selectsID;
  String selectPlanId;
  String selectTime;
  int countPerson = 0;
  var stpoint;
  var dtpoint;
  String timeservice;

  @override
  void initState() {
    super.initState();
    getRouteFrom();
    // getRouteTo();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    dateTimeCome = DateTime.now();
    dateTimeOff = DateTime.now();
    _textController = TextEditingController(text: 'initial text');
  }

  void initNum(nNum) {
    setState(() {
      p_num = nNum;
    });
  }

  Future<void> chooseDateCome() async {
    DateTime chooseDateTime = await showRoundedDatePicker(
        context: context,
        initialDate: dateTimeCome,
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime(DateTime.now().year + 1),
        theme: ThemeData(primarySwatch: Colors.red));

    if (chooseDateTime != null) {
      setState(() {
        dateTimeCome = chooseDateTime;
        print("----Date Time----");
        print(dateTimeCome);
      });
    }
  }

  Widget showDateCome() {
    return ListTile(
      title: Text(
          '${dateTimeCome.day}-${dateTimeCome.month}-${dateTimeCome.year}'),
      trailing: Icon(Icons.calendar_today),
      onTap: () {
        chooseDateCome();
      },
    );
  }

  Widget buttonSearch() {
    return Container(
      width: 150.0,
      height: 50.0,
      child: RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Colors.black,
        onPressed: () {
          print("----- From : ");
          print(selectedValueFrom);
          _onService();
        },
        child: Text(
          'ค้นหา',
          style: TextStyle(fontSize: 22.0, color: Colors.white),
        ),
      ),
    );
  }

  bool rememberSelect = false;
  void _onRememberSelectChange(bool newValue) => setState(() {
        rememberSelect = newValue;

        if (rememberSelect) {
          _onbookingFree();
        } else {
          print("กรุณายืนยันการเลือก");
        }
      });
  Widget buttonConfirm() {
    return Container(
      height: 50,
      width: 125,
      child: RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Color.fromRGBO(204, 37, 44, 1.0),
        onPressed: () {
          if (bookingFree.isNotEmpty) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => SelectSeat(
                  seatx: bookingFree,
                  serviceIDt: selectsIDCon,
                  rID: selectedValueFrom,
                  stpoint: stpoint,
                  dtpoint: dtpoint,
                  dateTimeCome: dateTimeCome,
                  timeservice: timeservice,
                  floorID: floorIDselect),
            ));
          } else {
            print('กรุณายืนยันตั๋วที่เลือก');
          }
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
      width: 120.0,
      height: 35.0,
      child: RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Color.fromRGBO(54, 54, 54, 1.0),
        onPressed: () {
          Navigator.pop(context);
          MaterialPageRoute cuper =
              MaterialPageRoute(builder: (value) => Navigate());
          Navigator.push(context, cuper);
        },
        child: Text(
          'กลับ',
          style: TextStyle(fontSize: 22.0, color: Colors.white),
        ),
      ),
    );
  }

  Widget appbarcustom() {
    return Container(
      height: 60.0,
      width: double.infinity,
      color: Color.fromRGBO(54, 54, 54, 1.0),
      child: Column(
        children: [
          SizedBox(
            height: 10.0,
          ),
          Text('จองตั๋ว',
              style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  List routeItemListFrom = List();

  Future getRouteFrom() async {
    var url =
        "https://premprachatransports.com/flutter_app/booking/booking_select.php";
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      setState(() {
        routeItemListFrom = jsonData;
      });
    }
    print("-----Route------");
    print(routeItemListFrom);
  }

  List routepoint = List();
  Future getRoutePoint() async {
    var url =
        "https://premprachatransports.com/flutter_app/booking/route_point.php?routeID=$selectedValueFrom";
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      setState(() {
        routepoint = jsonData;
        if (selectedValueFrom != null) {
          stpoint = routepoint[0]['sourcePointID'];
          dtpoint = routepoint[0]['destinationPointID'];
          print("-----Route Point-----");
          print(stpoint);
          print(dtpoint);
        }
      });
    }
  }

  List serviceData = List();
  _onService() async {
    var url =
        "https://premprachatransports.com/flutter_app/booking/service.php?routeID=$selectedValueFrom&sDate=$dateTimeCome";
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        serviceData = jsonData;
        print("----Service ID-----");
        print(serviceData);
      });
    }
  }

  List floorID = List();
  var floorIDselect;
  _onfloor() async {
    var url =
        "https://premprachatransports.com/flutter_app/booking/floor.php?plan_id=$planIDCon";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        floorID = jsonData;
        floorIDselect = floorID.first["floor_id"];
        print("-----Floor ID-----");
        print(floorIDselect);
      });
    }
  }

  List bookingFree = List();
  _onbookingFree() async {
    var url =
        "https://premprachatransports.com/flutter_app/booking/booking_fee.php?floor_id=$floorIDselect&sID=$selectsIDCon";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        bookingFree = jsonData;
        if (bookingFree.isEmpty) {
          normalDialog_pls(context, 'ที่นั่งเต็ม');
        } else {
          print("----Seat-----");
          print(bookingFree);
        }
      });
    }
  }

  Widget getService(String service) {
    return Padding(
      padding: EdgeInsets.only(bottom: 25.0),
      child: Text(service,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
    );
  }

  Widget getTime(String time) {
    return Text(
      time,
      style: TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
    );
  }

  Widget getTextCheckbox(String checkbox) {
    return Text(
      checkbox,
      style: TextStyle(
          fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black),
    );
  }

  Widget CheckBox() {
    return Checkbox(
      value: rememberSelect,
      onChanged: _onRememberSelectChange,
    );
  }

  bool checkValue = false;
  var selectsIDCon;
  String planIDCon;
  int selectedList = -1;
  Widget listTicket() {
    return Container(
      height: 350.0,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: serviceData.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              setState(() {
                selectedList = index;
                if (selectedList != -1) {
                  selectsIDCon = serviceData[index]["sID"];
                  planIDCon = serviceData[index]["plan_id"];
                  timeservice = serviceData[index]["sTime"];
                  print("---Select-----");
                  print(selectsIDCon);
                  print(planIDCon);
                  print(timeservice);
                  _onfloor();
                } else {
                  print("Please Select");
                }
              });
            },
            child: Container(
              padding: EdgeInsets.all(10.0),
              height: MediaQuery.of(context).size.width * 0.45,
              child: Card(
                shape: (selectedList == index)
                    ? RoundedRectangleBorder(
                        side: BorderSide(
                            width: 10.0,
                            color: Color.fromRGBO(204, 37, 44, 1.0),
                            style: BorderStyle.solid),
                      )
                    : null,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage('images/bc-ticket-f.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      //col1
                      Expanded(
                        flex: 7,
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              getService('Avaliable Ticket'),
                              ListTile(
                                leading: Icon(
                                  Icons.airport_shuttle,
                                  color: Colors.orange,
                                ),
                                title: getTime(serviceData[index]['sTime']),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                elevation: 10,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              appbarcustom(),
              Container(
                child: Column(
                  children: [
                    Container(
                      color: Color.fromRGBO(204, 37, 44, 1.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Container(
                                  width: 310.0,
                                  height: 35.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      color: Colors.white),
                                  child: new DropdownButtonFormField(
                                    isExpanded: false,
                                    decoration: InputDecoration.collapsed(
                                      hintText: 'เลือกเส้นทาง',
                                      hintStyle: TextStyle(fontSize: 16),
                                    ),
                                    value: selectedValueFrom,
                                    items: routeItemListFrom.map((route) {
                                      return DropdownMenuItem(
                                        value: route['routeID'],
                                        child: Text(
                                          route['thName'],
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedValueFrom = value;
                                        print(selectedValueFrom);
                                        if (selectedValueFrom.isNotEmpty) {
                                          getRoutePoint();
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  '                    ',
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                child: Text(
                                  'เลือกวันที่',
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.white),
                                ),
                              ),
                              Container(
                                child: Text(
                                  '                                                          ',
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: 170.0,
                                height: 45.0,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    color: Colors.white),
                                child: showDateCome(),
                              ),
                              Container(
                                width: 150.0,
                                height: 50.0,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                child: Text(
                                  '                                              ',
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.white),
                                ),
                              ),
                              buttonSearch(),
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Center(
                            child: Column(
                              children: [
                                SizedBox(height: 10.0),
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: listTicket(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  new Container(
                    child: getTextCheckbox("ยืนยันการเลือกตั๋ว :"),
                  ),
                  new Container(
                    child: CheckBox(),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 50.0,
                    child: buttonConfirm(),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Container(
                    height: 50.0,
                    child: buttonCancle(),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
