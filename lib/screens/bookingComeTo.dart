import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:meta/meta.dart';
import 'package:prampracha_app/myStyle/mystyle.dart';
import 'package:prampracha_app/myStyle/normal_dialog_pls.dart';
import 'package:prampracha_app/screens/home.dart';
import 'package:prampracha_app/screens/selectseat_14.dart';

import 'package:http/http.dart' as http;
import 'package:prampracha_app/screens/selectseat_20.dart';

class Booking extends StatefulWidget {
  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<Booking> with SingleTickerProviderStateMixin {
  DateTime dateTimeCome;
  DateTime dateTimeOff;
  int cindex = 0;
  TextEditingController numController = new TextEditingController();
  TabController _tabController;
  final number = TextEditingController();

  var stpoint_c;
  var dtpoint_c;
  var stpoint_t;
  var dtpoint_t;
  String timeserviceC;
  String timeserviceT;

  @override
  void initState() {
    super.initState();
    getRouteFrom();
    getRouteTo();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    dateTimeCome = DateTime.now();
    dateTimeOff = DateTime.now();
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
        print("----Date Time------");
        dateTimeCome = chooseDateTime;
        print(dateTimeCome);
        print("----------------------------");
      });
    }
  }

  Future<void> chooseDateOff() async {
    DateTime chooseDateTime = await showRoundedDatePicker(
        context: context,
        initialDate: dateTimeOff,
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime(DateTime.now().year + 1),
        theme: ThemeData(primarySwatch: Colors.red));

    if (chooseDateTime != null) {
      setState(() {
        print("---------Date Time--------");
        dateTimeOff = chooseDateTime;
        print(dateTimeOff);
        print("----------------------------");
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

  Widget showDateOff() {
    return ListTile(
      title:
          Text('${dateTimeOff.day}-${dateTimeOff.month}-${dateTimeOff.year}'),
      trailing: Icon(Icons.calendar_today),
      onTap: () {
        chooseDateOff();
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
          print("-------------Service ID----------");
          _onServiceFrom();
          print(selectedValueFrom);
          if (serviceDataFrom != null) {
            _onServiceTo();
            print(selectedValueTo);
            print("----------------------------");
          } else {
            print("กรุณาเลือกปลายทาง");
          }
          // Navigator.pop(context);
          // CupertinoPageRoute cuper =
          //     CupertinoPageRoute(builder: (value) => Booking());
          // Navigator.push(context, cuper);
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
          _onbookingFreefrom();
          _onbookingFreeto();
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
        color: MyStyle().colorsbg(),
        onPressed: () {
          // send Data to next page //
          print(
              "-------------------------------------------------------------");
          if (bookingFreeFrom.isNotEmpty && bookingFreeTo.isNotEmpty) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => SelectSeatFromTo(
                  seatf: bookingFreeFrom,
                  seatt: bookingFreeTo,
                  serviceIDf: selectsIDConFrom,
                  serviceIDt: selectsIDConTo,
                  rID_from: selectedValueFrom,
                  rID_To: selectedValueTo,
                  stpoint_c: stpoint_c,
                  dtpoint_c: dtpoint_c,
                  stpoint_t: stpoint_t,
                  dtpoint_t: dtpoint_t,
                  dateTimeCome: dateTimeCome,
                  dateTimeOff: dateTimeOff,
                  timeserviceC: timeserviceC,
                  timeserviceT: timeserviceT,
                ),
              ),
            );
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
        color: MyStyle().colorbg2(),
        onPressed: () {
          Navigator.pop(context);
          CupertinoPageRoute cuper =
              CupertinoPageRoute(builder: (value) => Navigate());
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
      color: MyStyle().colorbg2(),
      height: 60.0,
      width: double.infinity,
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

  var selectedValueFrom;
  List routeItemList = List();

  Future getRouteFrom() async {
    var url =
        "https://premprachatransports.com/flutter_app/booking/booking_select.php";
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      setState(() {
        routeItemList = jsonData;
      });
    }
    print("------Route ID----------");
    print(routeItemList);
  }

  var selectedValueTo;
  List routeItemListTo = List();
  Future getRouteTo() async {
    var url =
        "https://premprachatransports.com/flutter_app/booking/booking_select.php";
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      setState(() {
        routeItemListTo = jsonData;
      });
    }
    print("------Route ID----------");
    print(routeItemListTo);
  }

  List routepointcome = List();
  Future getRoutePointCome() async {
    var url =
        "https://premprachatransports.com/flutter_app/booking/route_point.php?routeID=$selectedValueFrom";
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      setState(() {
        routepointcome = jsonData;
        if (selectedValueFrom.isNotEmpty) {
          stpoint_c = routepointcome[0]['sourcePointID'];
          dtpoint_c = routepointcome[0]['destinationPointID'];
          timeserviceC = routepointcome[0]['sTime'];
          print("------- Route Point --------");
          print(stpoint_c);
          print(dtpoint_c);
          print(timeserviceC);
        }
      });
    }
  }

  List routepointto = List();
  Future getRoutePointTo() async {
    var url =
        "https://premprachatransports.com/flutter_app/booking/route_point2.php?routeID=$selectedValueTo";
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      setState(() {
        routepointto = jsonData;
        if (selectedValueTo.isNotEmpty) {
          stpoint_t = routepointto[0]['sourcePointID'];
          dtpoint_t = routepointto[0]['destinationPointID'];
          timeserviceT = routepointto[0]['sTime'];
          print("------- Route Point --------");
          print(stpoint_t);
          print(dtpoint_t);
          print(timeserviceT);
        }
      });
    }
  }

  List serviceDataFrom = List();
  _onServiceFrom() async {
    var url =
        "https://premprachatransports.com/flutter_app/booking/service.php?routeID=$selectedValueFrom&sDate=$dateTimeCome";
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        print("------- Service ID -----------");
        serviceDataFrom = jsonData;
        print(serviceDataFrom);
      });
    }
  }

  List serviceDataTo = List();
  _onServiceTo() async {
    var url =
        "https://premprachatransports.com/flutter_app/booking/service.php?routeID=$selectedValueTo&sDate=$dateTimeOff";
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        print("------- Service ID -----------");
        serviceDataTo = jsonData;
        print(serviceDataTo);
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
  var selectsIDConFrom;
  var planIDConFrom;
  int selectedListFrom = -1;
  Widget listTicketfrom() {
    return Container(
      height: 400.0,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: serviceDataFrom.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              setState(() {
                selectedListFrom = index;
                if (selectedListFrom != -1) {
                  selectsIDConFrom = serviceDataFrom[index]["sID"];
                  planIDConFrom = serviceDataFrom[index]["plan_id"];
                  timeserviceC = serviceDataFrom[index]["sTime"];
                  print("---------- Select Data ----------------");
                  print(selectsIDConFrom);
                  print(planIDConFrom);
                  _onfloorfrom();
                } else {
                  print("Please Select");
                }
              });
            },
            child: Container(
              height: MediaQuery.of(context).size.width * 0.45,
              child: Card(
                shape: (selectedListFrom == index)
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
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              getService('Available Ticket'),
                              ListTile(
                                leading: Icon(
                                  Icons.airport_shuttle,
                                  color: Colors.orange,
                                ),
                                title: getTime(serviceDataFrom[index]['sTime']),
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

  var selectsIDConTo;
  var planIDConTo;
  int selectedListTo = -1;
  Widget listTicketto() {
    return Container(
      height: 400.0,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: serviceDataTo.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              setState(() {
                selectedListTo = index;
                if (selectedListTo != -1) {
                  selectsIDConTo = serviceDataTo[index]["sID"];
                  planIDConTo = serviceDataTo[index]["plan_id"];
                  timeserviceT = serviceDataTo[index]["sTime"];
                  print("---------- Select Data ----------------");
                  print(selectsIDConTo);
                  print(planIDConTo);
                  _onfloorto();
                } else {
                  print("Please Select");
                }
              });
            },
            child: Container(
              height: MediaQuery.of(context).size.width * 0.45,
              child: Card(
                shape: (selectedListTo == index)
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
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              getService('Available Ticket'),
                              ListTile(
                                leading: Icon(
                                  Icons.airport_shuttle,
                                  color: Colors.orange,
                                ),
                                title: getTime(serviceDataTo[index]['sTime']),
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

  List floorIDFrom = List();
  var floorIDselectFrom;
  _onfloorfrom() async {
    var url =
        "https://premprachatransports.com/flutter_app/booking/floor.php?plan_id=$planIDConFrom";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        print("---------- Floor ID ----------------");
        floorIDFrom = jsonData;
        floorIDselectFrom = floorIDFrom.first["floor_id"];
        print(floorIDselectFrom);
      });
    }
  }

  List floorIDTo = List();
  var floorIDselectTo;
  _onfloorto() async {
    var url =
        "https://premprachatransports.com/flutter_app/booking/floor.php?plan_id=$planIDConTo";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        print("---------- Floor ID ----------------");
        floorIDTo = jsonData;
        floorIDselectTo = floorIDTo.first["floor_id"];
        print(floorIDselectTo);
      });
    }
  }

  List bookingFreeFrom = List();
  _onbookingFreefrom() async {
    var url =
        "https://premprachatransports.com/flutter_app/booking/booking_fee.php?floor_id=$floorIDselectFrom&sID=$selectsIDConFrom";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        bookingFreeFrom = jsonData;
        if (bookingFreeFrom.isEmpty) {
          normalDialog_pls(context, 'ที่นั่งเต็ม');
        } else {
          print("--Seat--");
          print(bookingFreeFrom);
        }
      });
    }
  }

  List bookingFreeTo = List();
  _onbookingFreeto() async {
    var url =
        "https://premprachatransports.com/flutter_app/booking/booking_fee.php?floor_id=$floorIDselectTo&sID=$selectsIDConTo";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        bookingFreeTo = jsonData;
        if (bookingFreeTo.isEmpty) {
          normalDialog_pls(context, 'ที่นั่งเต็ม');
        } else {
          print("--Seat--");
          print(bookingFreeTo);
        }
        print(bookingFreeTo);
      });
    }
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
                      color: MyStyle().colorsbg(),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                // padding: EdgeInsets.all(50.0),
                                alignment: Alignment.centerLeft,
                                // child: fromButton(),
                                child: Container(
                                  width: 175.0,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      color: Colors.white),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: new DropdownButtonFormField(
                                        decoration: InputDecoration.collapsed(
                                            hintText: 'เลือกเส้นทาง'),
                                        isExpanded: true,
                                        value: selectedValueFrom,
                                        items: routeItemList.map((route) {
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
                                              getRoutePointCome();
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 175.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    color: Colors.white),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: new DropdownButtonFormField(
                                      isExpanded: true,
                                      decoration: InputDecoration.collapsed(
                                          hintText: 'เลือกเส้นทาง'),
                                      value: selectedValueTo,
                                      items: routeItemListTo.map((routeTo) {
                                        return DropdownMenuItem(
                                          value: routeTo['routeID'],
                                          child: Text(
                                            routeTo['thName'],
                                            textAlign: TextAlign.center,
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (valueTo) {
                                        setState(() {
                                          selectedValueTo = valueTo;
                                          print(selectedValueTo);
                                          if (selectedValueTo.isNotEmpty) {
                                            getRoutePointTo();
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                child: Text(
                                  'วันที่ออก',
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.white),
                                ),
                              ),
                              Container(
                                child: Text(
                                  'วันที่กลับ',
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: 175.0,
                                height: 50.0,
                                // padding: const EdgeInsets.all(5.0),
                                // margin: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30.0)),
                                    color: Colors.white),
                                child: showDateCome(),
                              ),
                              Container(
                                width: 175.0,
                                height: 50.0,
                                // padding: const EdgeInsets.all(5.0),
                                // margin: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30.0)),
                                    color: Colors.white),
                                child: showDateOff(),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              new Container(
                                child: SizedBox(
                                  width: 200,
                                ),
                              ),
                              buttonSearch(),
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Center(
                            child: Column(
                              children: [
                                SizedBox(height: 10.0),
                              ],
                            ),
                          ),
                          TabBar(
                            controller: _tabController,
                            tabs: <Widget>[
                              Tab(
                                icon: Image.asset(
                                  'images/public-transport-white.png',
                                  scale: 24.0,
                                ),
                                text: 'เลือกเที่ยวรถขาไป',
                              ),
                              Tab(
                                icon: Image.asset(
                                  'images/public-transport-white-2.png',
                                  scale: 24.0,
                                  color: Colors.white,
                                ),
                                text: 'เลือกเที่ยวรถขากลับ',
                              )
                            ],
                          ),
                          Container(
                            height: 300.0,
                            color: Colors.grey[300],
                            child: TabBarView(
                              controller: _tabController,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: listTicketfrom(),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: listTicketto(),
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
                    child: getTextCheckbox('ยืนยันการเลือกตั๋ว :'),
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
