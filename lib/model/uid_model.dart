import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class UserId {
  final String id;

  UserId({this.id});

  factory UserId.fromJson(Map<String, dynamic> parsedJson) {
    return UserId(id: parsedJson['id']);
  }
}
