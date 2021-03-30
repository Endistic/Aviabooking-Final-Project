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
import 'package:prampracha_app/myStyle/success_dialogCT.dart';
import 'package:prampracha_app/screens/detail.dart';
import 'package:prampracha_app/screens/ticketforpaymentCT.dart';
import 'bookingComeTo.dart';
import 'comebooking.dart';

class BookingDetailComeTo extends StatefulWidget {
  var seatselectc;
  var seatselectt;
  var serviceIDc;
  var serviceIDt;

  var rIDc;
  var rIDt;

  var stpointC;
  var stpointT;
  var dtpointC;
  var dtpointT;

  String name;
  String surname;
  String telNo;
  String email;
  String noID;
  var floorID;
  DateTime dateTimeCome;
  DateTime dateTimeTo;

  String timeserviceC;
  String timeserviceT;

  BookingDetailComeTo(
      {Key key,
      @required this.seatselectc,
      this.seatselectt,
      this.serviceIDc,
      this.serviceIDt,
      this.rIDc,
      this.rIDt,
      this.stpointC,
      this.stpointT,
      this.dtpointC,
      this.dtpointT,
      this.dateTimeCome,
      this.dateTimeTo,
      this.timeserviceC,
      this.timeserviceT})
      : super(key: key);
  @override
  _BookingDetailComeToState createState() => _BookingDetailComeToState(
      seatselectc,
      seatselectt,
      serviceIDc,
      serviceIDt,
      rIDc,
      rIDt,
      stpointC,
      stpointT,
      dtpointC,
      dtpointT,
      dateTimeCome,
      dateTimeTo,
      timeserviceC,
      timeserviceT);
}

class _BookingDetailComeToState extends State<BookingDetailComeTo> {
  List<User> user = new List<User>();
  List<Contact> _contacts = [];
  DatabaseHelper _dbHelper = DatabaseHelper.instance;

  var seatselectc;
  var seatselectt;
  var serviceIDc;
  var serviceIDt;

  var rIDc;
  var rIDt;

  var stpointC;
  var stpointT;
  var dtpointC;
  var dtpointT;

  DateTime dateTimeCome;
  DateTime dateTimeTo;
  String chooseType;
  String name;
  String timeserviceC;
  String timeserviceT;
  List userName = List();

  _BookingDetailComeToState(
      this.seatselectc,
      this.seatselectt,
      this.serviceIDc,
      this.serviceIDt,
      this.rIDc,
      this.rIDt,
      this.stpointC,
      this.stpointT,
      this.dtpointC,
      this.dtpointT,
      this.dateTimeCome,
      this.dateTimeTo,
      this.timeserviceC,
      this.timeserviceT);
  @override
  void initState() {
    super.initState();
    print('Data Require');
    print(seatselectc);
    print(seatselectt);
    print(serviceIDc);
    print(serviceIDt);
    print(rIDc);
    print(rIDt);
    print(stpointC);
    print(stpointT);
    print(dtpointC);
    print(dtpointT);
    print(dateTimeCome);
    print(dateTimeTo);
    print(timeserviceC);
    print(timeserviceT);
    print("------------ Fatch Name ---------------");
    _fatchData();
    print("--------------- Price -----------------");
    // _onPriceC();
    // _onPriceT();
    getRouteNameC();
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
          if (dataBookingC.isEmpty) {
            _putbookingC();
            if (dataBookingT.isEmpty) {
              _putbookingT();
            }
          } else {
            print("Error");
          }
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
              MaterialPageRoute(builder: (value) => Booking());
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
    "เวลา : ",
    "เส้นทาง : ",
    "ชื่อ-สกุล : ",
    "ราคา : ",
  ];
  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    height: 550.0,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.black, width: 5)),
                          height: 250.0,
                          width: 300.0,
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
                                  trailing: Text("${timeserviceC}"),
                                  dense: true,
                                ),
                                new ListTile(
                                  title: Text(litems[2]),
                                  trailing: Text("${routeNameInputC}"),
                                  dense: true,
                                ),
                                new ListTile(
                                  title: Text(litems[3]),
                                  trailing:
                                      Text("${name}" + "\t" + "${sername}"),
                                  dense: true,
                                ),
                                new ListTile(
                                  title: Text(litems[4]),
                                  trailing:
                                      Text("${price_c.toString() + '\tบาท'}"),
                                  dense: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.black, width: 5)),
                          height: 250.0,
                          width: 300.0,
                          child: Container(
                            child: Column(
                              children: [
                                new ListTile(
                                  title: Text(litems[0]),
                                  trailing: Text(
                                      "${dateTimeTo.day}-${dateTimeTo.month}-${dateTimeTo.year}"),
                                  dense: true,
                                ),
                                new ListTile(
                                  title: Text(litems[1]),
                                  trailing: Text("${timeserviceT}"),
                                  dense: true,
                                ),
                                new ListTile(
                                  title: Text(litems[2]),
                                  trailing: Text("${routeNameInputT}"),
                                  dense: true,
                                ),
                                new ListTile(
                                  title: Text(litems[3]),
                                  trailing:
                                      Text("${name}" + "\t" + "${sername}"),
                                  dense: true,
                                ),
                                new ListTile(
                                  title: Text(litems[4]),
                                  trailing:
                                      Text("${price_t.toString() + '\tบาท'}"),
                                  dense: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  buttonConfirm(),
                  SizedBox(
                    height: 10.0,
                  ),
                  buttonCancle()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String routeNameInputC;
  List routeNameC = List();
  getRouteNameC() async {
    var url =
        "https://premprachatransports.com/flutter_app/booking/routename.php?routeID=$rIDc";
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      setState(() {
        _onPriceC();
        routeNameC = jsonData;
        routeNameInputC = routeNameC.first['thName'];
        if (routeNameC.isNotEmpty) {
          getRouteNameT();
        }
      });
    }
    print(routeNameC);
  }

  String routeNameInputT;
  List routeNameT = List();
  getRouteNameT() async {
    var url =
        "https://premprachatransports.com/flutter_app/booking/routename2.php?routeID=$rIDt";
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      setState(() {
        _onPriceT();
        routeNameT = jsonData;
        routeNameInputT = routeNameT.first['thName'];
      });
    }
    print(routeNameT);
  }

  int price_c = 0;
  _onPriceC() async {
    final response = await http.get(
        'https://premprachatransports.com/flutter_app/booking/calprice.php?startPointID=$stpointC&stopPointID=$dtpointC&sDate=$dateTimeCome');
    if (response.statusCode == 200) {
      var priceData = json.decode(response.body);
      setState(() {
        price_c = priceData;
        print(price_c);
      });
    }
  }

  int price_t = 0;
  _onPriceT() async {
    final response = await http.get(
        'https://premprachatransports.com/flutter_app/booking/calprice2.php?startPointID=$stpointT&stopPointID=$dtpointT&sDate=$dateTimeTo');
    if (response.statusCode == 200) {
      var priceData = json.decode(response.body);
      setState(() {
        price_t = priceData;
        print(price_t);
      });
    }
  }

  String sername;
  String tel;
  String email;
  String idNo;
  var fullname = '';
  Future fetchUser() async {
    var id = _contacts[0].uId;
    print(id);
    final response = await http.get(
        'https://premprachatransports.com/flutter_app/userinfo/get_user.php?id=$id');
    String logResponse = response.statusCode.toString();
    if (response.statusCode == 200) {
      // print('ResponseStatusCode: $logResponse'); // Check Status Code = 200
      // print('ResponseBody: ' + response.body); // Read Data in Array
      var jsonDataUser = json.decode(response.body);
      setState(() {
        userName = jsonDataUser;
        name = userName.first["name"];
        sername = userName[0]["surname"];
        tel = userName[0]["tel"];
        email = userName[0]["email"];
        idNo = userName[0]["idNo"];
        fullname = name + '' + sername;
        print(name);
        print(sername);
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

  List dataBookingC = List();
  Future _putbookingC() async {
    var url =
        'https://premprachatransports.com/flutter_app/booking/putbookingCome.php?sID=$serviceIDt&travelFrom=$stpointC&travelTo=$dtpointC&passengerName=$fullname&passengerTel=$tel&passengerCardID=$idNo&passengerEmail=$email&sDate=$dateTimeCome&seatName=$seatselectc';
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var putDataC = json.decode(response.body);
      setState(() {
        dataBookingC = putDataC;
        print(dataBookingC);
      });
    }
  }

  List dataBookingT = List();
  Future _putbookingT() async {
    var url =
        'https://premprachatransports.com/flutter_app/booking/putbookingTo.php?sID=$serviceIDt&travelFrom=$stpointT&travelTo=$dtpointT&passengerName=$fullname&passengerTel=$tel&passengerCardID=$idNo&passengerEmail=$email&sDate=$dateTimeTo&seatName=$seatselectt';
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var putDataT = json.decode(response.body);
      setState(() {
        dataBookingT = putDataT;
        print(dataBookingT);
      });
    }
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => TicketForPaymentCT(
          putbookingsuccessC: dataBookingC,
          putbookingsuccessT: dataBookingT,
          dateTimeCome: dateTimeCome,
          dateTimeTo: dateTimeTo,
          timeserviceC: timeserviceC,
          timeserviceT: timeserviceT,
          routeNameInputC: routeNameInputC,
          routeNameInputT: routeNameInputT,
        ),
      ),
      result: successDialog_CT(context, "จองตั๋วสำเร็จ"),
    );
  }
}
