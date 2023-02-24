import 'dart:convert';
import 'package:crypto/crypto.dart';

class Crypt {
  static String hash(String password) {
    var bytes = utf8.encode(password); // data being hashed
    String digest = sha512.convert(bytes).toString();
    return digest;
  }
}
