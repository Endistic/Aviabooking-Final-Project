import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:prampracha_app/myStyle/mystyle.dart';
import 'package:prampracha_app/screens/home.dart';

class ReBooking extends StatefulWidget {
  @override
  _ReBookingState createState() => _ReBookingState();
}

final TextField numTicket = new TextField(
  decoration: new InputDecoration(
    hintText: 'รหัสตั๋ว',
    contentPadding: new EdgeInsets.all(10.0),
    border: InputBorder.none,
  ),
  keyboardType: TextInputType.number,
  autocorrect: false,
);

final TextField emailTicket = new TextField(
  decoration: new InputDecoration(
    hintText: 'อีเมลล์',
    contentPadding: new EdgeInsets.all(10.0),
    border: InputBorder.none,
  ),
  keyboardType: TextInputType.number,
  autocorrect: true,
);

class _ReBookingState extends State<ReBooking>
    with SingleTickerProviderStateMixin {
  int _dvalue = 1;
  int _pvalue = 1;
  int _tvalue = 1;
  int _rvalue = 1;
  DateTime dateTimeCome;
  int cindex = 0;
  int p_num = 0;
  TabController _tabController;
  TextEditingController _textController;

  void _incrementTab(index) {
    setState(() {
      cindex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    dateTimeCome = DateTime.now();
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
        theme: ThemeData(primarySwatch: Colors.orange));
    if (chooseDateTime != null) {
      setState(() {
        dateTimeCome = chooseDateTime;
      });
    }
  }

  Widget showDateCome() {
    return ListTile(
      title: Text(
          '${dateTimeCome.day}-${dateTimeCome.month}-${dateTimeCome.year}'),
      trailing: Icon(Icons.keyboard_arrow_down),
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

  Widget buttonConfirm() {
    return Container(
      width: 120.0,
      height: 35.0,
      child: RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: MyStyle().colorsbg(),
        onPressed: () {
          // Navigator.pop(context);
          // CupertinoPageRoute cuper =
          //     CupertinoPageRoute(builder: (value) => SelectSeat());
          // Navigator.push(context, cuper);
        },
        child: Text(
          'ยืนยัน',
          style: TextStyle(fontSize: 22.0, color: Colors.white),
        ),
      ),
    );
  }

  Widget appbarcustom() {
    return Container(
      height: 50.0,
      width: double.infinity,
      color: MyStyle().colorsbg(),
      child: Column(
        children: [
          SizedBox(
            height: 10.0,
          ),
          Text('เลื่อนตั๋ว',
              style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
        ],
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
        color: Colors.grey[400],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.grey[200],
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              appbarcustom(),
              SizedBox(
                height: 30.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 200.0,
                    // margin: new EdgeInsets.symmetric(
                    //     horizontal: 20.0, vertical: 20.0),
                    decoration: new BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        border:
                            new Border.all(width: 1.1, color: Colors.black12),
                        borderRadius:
                            BorderRadius.all(const Radius.circular(25.0))),
                    child: showDateCome(),
                  ),
                  buttonSearch(),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 540.0,
                  child: listcard1(),
                ),
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
              SizedBox(
                height: 10.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class listcard2 extends StatefulWidget {
  const listcard2({
    Key key,
  }) : super(key: key);

  @override
  _listcard2State createState() => _listcard2State();
}

class _listcard2State extends State<listcard2> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          height: MediaQuery.of(context).size.width * 0.50,
          child: Card(
            color: Colors.white70,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 8,
            child: InkWell(
              highlightColor: Colors.orange,
              splashColor: Colors.orange,
              borderRadius: BorderRadius.circular(15.0),
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

class listcard1 extends StatefulWidget {
  const listcard1({
    Key key,
  }) : super(key: key);

  @override
  _listcard1State createState() => _listcard1State();
}

class _listcard1State extends State<listcard1> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 2,
      itemBuilder: (context, index) {
        return Container(
          height: MediaQuery.of(context).size.width * 0.5,
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
