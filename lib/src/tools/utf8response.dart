import 'package:http/http.dart';
import 'dart:convert' show utf8;

extension UTF8Response on Response {
  String get utf8Body {
    return utf8.decode(bodyBytes);
  }
}
