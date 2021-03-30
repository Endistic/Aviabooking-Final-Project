import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:prampracha_app/helper/dbhelper.dart';
import 'package:prampracha_app/model/user_model.dart';
import 'package:prampracha_app/myStyle/mystyle.dart';
import 'package:prampracha_app/myStyle/normail_dialog.dart';
import 'package:prampracha_app/screens/home.dart';
import 'package:prampracha_app/screens/register.dart';

class LoginTo extends StatefulWidget {
  LoginTo({Key key}) : super(key: key);

  @override
  _LoginToState createState() => _LoginToState();
}

class _LoginToState extends State<LoginTo> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  Contact _contact = Contact();
  List<Contact> _contacts = [];
  DatabaseHelper _dbHelper = DatabaseHelper.instance;
  // init State
  @override
  void initState() {
    super.initState();
  }

  Widget buttonRegister() {
    return Container(
      width: 250.0,
      height: 80.0,
      child: RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: MyStyle().colorbg2(),
        onPressed: () {
          MaterialPageRoute cuper =
              MaterialPageRoute(builder: (value) => Register());
          Navigator.pushReplacement(context, cuper);
        },
        child: Text(
          'Register\nสมัครสมาชิก',
          style: TextStyle(fontSize: 22.0, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget buttonlogin() {
    return Container(
      width: 250.0,
      height: 80.0,
      child: RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: MyStyle().colorsbg(),
        onPressed: () => _onSubmit(),
        child: Text(
          'Sign In\nเข้าสู่ระบบ',
          style: TextStyle(fontSize: 22.0, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 100.0,
                ),
                new Container(
                  height: 200.0,
                  decoration: BoxDecoration(
                    image: new DecorationImage(
                      image: new AssetImage('images/logo-avia.png'),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _form(),
                    buttonlogin(),
                    SizedBox(
                      height: 5.0,
                    ),
                    buttonRegister(),
                  ],
                ),

                // _list(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _refreshContact() async {
    List<Contact> x = await _dbHelper.fetchContacts();
    setState(() {
      _contacts = x;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Navigate()));
    });
  }

  _onSubmit() async {
    var form = _formKey.currentState;

    var url = 'https://premprachatransports.com/flutter_app/login/index3.php';
    var url_get =
        'https://premprachatransports.com/flutter_app/login/user_select.php';

    final response = await http.post(url, body: {
      "email": emailController.text,
      "password": passwordController.text
    });

    final response_get = await http.post(url_get, body: {
      "email": emailController.text,
      "password": passwordController.text
    });

    print(response.body);
    var message = json.decode(response.body);

    if (message.toString() == 'Success') {
      var jsonResponse = json.decode(response_get.body);
      if (form.validate()) {
        _contact.uId = jsonResponse['id'].toString();
        form.save();
        if (_contact.id == null)
          await _dbHelper.insertContact(_contact);
        else
          normalDialog(context, 'กรุณาลองใหม่');
        setState(() {
          _contacts.add(_contact);
        });
        _refreshContact();
      }
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text(message),
              actions: <Widget>[
                FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
  }

  // Form
  _form() => Container(
        padding: EdgeInsets.symmetric(vertical: 26, horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                onSaved: (val) => setState(() => _contact.email = val),
                validator: (val) =>
                    (val.length == 0 ? 'This Field is require' : null),
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                onSaved: (val) => setState(() => _contact.password = val),
                validator: (val) =>
                    (val.length < 9 ? 'Atleast 10 character required' : null),
              ),
            ],
          ),
        ),
      );
  // _list() => Expanded(
  //       child: Card(
  //         margin: EdgeInsets.fromLTRB(23, 30, 20, 0),
  //         child: ListView.builder(
  //           padding: EdgeInsets.all(8),
  //           itemBuilder: (context, index) {
  //             return Column(
  //               children: <Widget>[
  //                 ListTile(
  //                   leading: Icon(
  //                     Icons.account_circle,
  //                     color: Colors.amber,
  //                     size: 40.0,
  //                   ),
  //                   title: Text(
  //                     _contacts[index].email,
  //                     style: TextStyle(
  //                       color: Colors.orange,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                   subtitle: Text(
  //                     _contacts[index].uId,
  //                   ),
  //                 ),
  //                 Divider(
  //                   height: 5.0,
  //                 ),
  //               ],
  //             );
  //           },
  //           itemCount: _contacts.length,
  //         ),
  //       ),
  //     );
}
