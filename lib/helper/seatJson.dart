// import 'dart:convert';
// import 'dart:async';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';

// Future<POST> fetchPost() async {
//   var url =
//       "https://premprachatransports.com/flutter_app/select-seat/selectseat.php?sID=$selectsIDCon";
//   final response = await http.get(url);
//   final jsonData = json.decode(response.body);
//   return new POST.fromJson(jsonData);
// }

// class POST {
//   final String seatpick;

//   POST(this.seatpick);
//   factory POST.fromJson(Map<String, dynamic> json) {
//     return new POST(
//       seatpick: json[]
//     );
//   }
// }
