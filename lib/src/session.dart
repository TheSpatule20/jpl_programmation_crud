import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'basic_data_source/data_source_usager.dart';

Future<String> getBasicAuth() async {
  Usager connectedUsager = await Session.usagerSessionGet();
  String basicAuth = 'Basic ${base64Encode(utf8.encode('${connectedUsager.usagerId.toString()}:${connectedUsager.motDePasse}'))}';

  return basicAuth;
}

class Session {
  static Usager constEmployeConnecte = Usager();

  static Future<void> usagerSessionSet(Usager usager) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String user = usager.toJson().toString();
    sharedPreferences.setString('UsagerConnecte', user);
    constEmployeConnecte = usager;
  }

  static Future<Usager> usagerSessionGet() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var string = sharedPreferences.getString('UsagerConnecte');

    if (string != null) {
      Map<String, dynamic> userMap = jsonDecode(string);
      Usager user = Usager.fromJson(userMap);
      constEmployeConnecte = user;
      return user;
    }

    return Usager();
  }

  static Future<void> usagerConnectionSet(Usager usager) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String user = usager.toJson().toString();
    sharedPreferences.setString('usagerConnection', user);
    constEmployeConnecte = usager;
  }

  static Future<Usager> usagerConnectionGet() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var string = sharedPreferences.getString('usagerConnection');

    if (string != null) {
      Map<String, dynamic> userMap = jsonDecode(string);
      Usager user = Usager.fromJson(userMap);
      constEmployeConnecte = user;
      return user;
    }

    return Usager();
  }
}
