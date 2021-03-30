import 'package:flutter/material.dart';
import 'package:prampracha_app/screens/home.dart';
import 'package:prampracha_app/screens/ticketforpayment.dart';
import 'package:prampracha_app/screens/ticketforpaymentCT.dart';

Future<void> successDialog_CT(BuildContext context, String message) async {
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
            MaterialPageRoute cuper =
                MaterialPageRoute(builder: (value) => TicketForPaymentCT());
            Navigator.pushReplacement(context, cuper);
          },
        ),
      ],
    ),
  );
}
