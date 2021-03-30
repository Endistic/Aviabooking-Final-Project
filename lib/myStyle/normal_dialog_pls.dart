import 'package:flutter/material.dart';
import 'package:prampracha_app/screens/home.dart';

Future<void> normalDialog_pls(BuildContext context, String message) async {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      title: Text(message),
      actions: <Widget>[
        FlatButton(
          child: Text('ตกลง'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
