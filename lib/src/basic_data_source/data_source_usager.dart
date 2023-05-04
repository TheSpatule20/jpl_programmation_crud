import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../jpl_programmation_crud.dart';

Crypt crypt = Crypt();
const String constStrUsagerId = 'usagerId';
const String constStrCourriel = 'courriel';
const String constStrMotDePasse = 'motDePasse';
const String constStrOtp = 'otp';
const String constStrCourrielConfirme = 'courrielConfirme';
const String constStrMotDePasseModifier = 'motDePasseModifier';
const String constStrActif = 'actif';
const String constStrAdminsitrateur = 'administrateur';
const String constStrDateInscription = 'dateInscription';
const String constStrDateDerniereConnection = 'dateDerniereConnection';

class Usager {
  int? usagerId;
  String? courriel;
  String? motDePasse;
  String? otp;
  bool? actif;
  bool? courrielConfirme;
  bool? motDePasseModifier;
  bool? administrateur;
  DateTime? dateInscription;
  DateTime? dateDerniereConnection;

  Usager({
    this.usagerId,
    this.courriel,
    this.motDePasse,
    this.otp,
    this.actif,
    this.courrielConfirme,
    this.motDePasseModifier,
    this.administrateur,
    this.dateInscription,
    this.dateDerniereConnection,
  });

  factory Usager.fromJson(Map<String, dynamic> json) {
    return Usager(
      usagerId: json[constStrUsagerId],
      courriel: json[constStrCourriel].toString(),
      motDePasse: json[constStrMotDePasse].toString(),
      otp: json[constStrOtp].toString(),
      actif: jsonToBool(json[constStrActif]) ?? false,
      courrielConfirme: jsonToBool(json[constStrCourrielConfirme]) ?? false,
      motDePasseModifier: jsonToBool(json[constStrMotDePasseModifier]) ?? false,
      administrateur: jsonToBool(json[constStrAdminsitrateur]) ?? false,
      dateInscription: (json[constStrDateInscription].toString() == 'null' ? null : DateTime.parse(json[constStrDateInscription])),
      dateDerniereConnection: (json[constStrDateDerniereConnection].toString() == 'null' ? null : DateTime.parse(json[constStrDateDerniereConnection])),
    );
  }

  Map<String, String> toJson() => {
        jsonEncode(constStrUsagerId): jsonEncode(usagerId),
        jsonEncode(constStrCourriel): jsonEncode(courriel.toString()),
        jsonEncode(constStrMotDePasse): jsonEncode(motDePasse.toString()),
        jsonEncode(constStrCourrielConfirme): jsonEncode(boolToJson(courrielConfirme)),
        jsonEncode(constStrMotDePasseModifier): jsonEncode(boolToJson(motDePasseModifier)),
        jsonEncode(constStrActif): jsonEncode(boolToJson(actif)),
        jsonEncode(constStrAdminsitrateur): jsonEncode(boolToJson(administrateur)),
        jsonEncode(constStrDateInscription): jsonEncode(dateInscription.toString()),
        jsonEncode(constStrDateDerniereConnection): jsonEncode(dateDerniereConnection.toString()),
      };
}

class DataSourceUsager {
  String urlPrefixe, dossierUsager;
  DataSourceUsager({required this.urlPrefixe, required this.dossierUsager});

  Future<bool> courrielExiste(String strCourriel) async {
    final response = await http.post(Uri.parse("$urlPrefixe/$dossierUsager/courriel_existe.php"), body: {
      'courriel': strCourriel.toString(),
    });
    return analyseResponseBodyPourInt(response.body);
  }

  Future<Usager> connection(Usager usagerIdentifiant) async {
    final response = await http.post(Uri.parse("$urlPrefixe/$dossierUsager/connection.php"), body: {
      'usager': usagerIdentifiant.toJson().toString(),
    });

    if (response.body == 'false') {
      return Usager();
    }

    final usagerJson = json.decode(response.body);

    Usager usager = Usager.fromJson(usagerJson);

    return usager;
  }

  Future<bool> modifierMotDePasseEtConfirmerCourriel(Usager usagerModifier) async {
    String basicAuth = await Session.getBasicAuth();

    final response = await http.post(
      Uri.parse("$urlPrefixe/$dossierUsager/modifierMotDePasseEtConfirmerCourriel.php"),
      headers: {
        'authorization': basicAuth,
        "Cache-Control": "no-cache",
      },
      body: {
        'usager': usagerModifier.toJson().toString(),
      },
    );

    if (response.body == 'false') {
      return false;
    }

    return true;
  }

  Future<bool> modifierConfirmerCourriel(Usager usagerModifier) async {
    String basicAuth = await Session.getBasicAuth();

    final response = await http.post(
      Uri.parse("$urlPrefixe/$dossierUsager/modifierConfirmerCourriel.php"),
      headers: {
        'authorization': basicAuth,
        "Cache-Control": "no-cache",
      },
      body: {
        'usager': usagerModifier.toJson().toString(),
      },
    );

    if (response.body == 'false') {
      return false;
    }

    return true;
  }

  Future<int> add({
    required Usager usager,
  }) async {
    String basicAuth = await Session.getBasicAuth();

    final response = await http.post(
      Uri.parse("$urlPrefixe/$dossierUsager/add.php"),
      headers: {
        'authorization': basicAuth,
        "Cache-Control": "no-cache",
      },
      body: {
        'usager': usager.toJson().toString(),
      },
    );

    int usagerId = -1;
    if (response.body != 'false' && response.body != '') {
      usagerId = json.decode(response.body);
    }

    return usagerId;
  }

  Future<bool> modifierAdministrateur(Usager usagerModifier) async {
    String basicAuth = await Session.getBasicAuth();

    final response = await http.post(
      Uri.parse("$urlPrefixe/$dossierUsager/modifierAdministrateur.php"),
      headers: {
        'authorization': basicAuth,
        "Cache-Control": "no-cache",
      },
      body: {
        'usager': usagerModifier.toJson().toString(),
      },
    );

    if (response.body == 'false') {
      return false;
    }

    return true;
  }

   Future<bool> modifierActif(Usager usagerModifier) async {
    String basicAuth = await Session.getBasicAuth();

    final response = await http.post(
      Uri.parse("$urlPrefixe/$dossierUsager/modifierActif.php"),
      headers: {
        'authorization': basicAuth,
        "Cache-Control": "no-cache",
      },
      body: {
        'usager': usagerModifier.toJson().toString(),
      },
    );

    if (response.body == 'false') {
      return false;
    }

    return true;
  }

  Future<bool> modifierCourriel(Usager usagerModifier) async {
    String basicAuth = await Session.getBasicAuth();

    final response = await http.post(
      Uri.parse("$urlPrefixe/$dossierUsager/modifierCourriel.php"),
      headers: {
        'authorization': basicAuth,
        "Cache-Control": "no-cache",
      },
      body: {
        'usager': usagerModifier.toJson().toString(),
      },
    );

    if (response.body == 'false') {
      return false;
    }

    return true;
  }
}

const String conStrColUsagerCourriel = 'courriel';

class EmailAuth {
  final String urlPrefixe, dossierUsager, sessionName;
  String courriel;
  EmailAuth({
    required this.sessionName,
    required this.courriel,
    required this.urlPrefixe,
    required this.dossierUsager,
  });

  ///This functions returns a future of boolean stating if the OTP was sent.
  Future<bool> sendOtp() async {
    try {
      if (!isEmail(courriel)) {
        if (kDebugMode) {
          print("Le courriel n'est pas valide");
        }
        return false;
      }
      if (kDebugMode) {
        print("Courriel valide");
      }

      http.Response response = await http.post(Uri.parse("$urlPrefixe/$dossierUsager/send_otp.php"), body: {
        conStrColUsagerCourriel: courriel,
      });

      String data = response.body;
      if (data != '-1' && data != '') {
        if (kDebugMode) {
          print("OTP sent successfully !");
        }
        return true;
      } else {
        if (kDebugMode) {
          print("OTP was not sent failure");
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print("--This error is from the package--");
        print(e);
        print("--End package error message--");
      }
      return false;
    }
  }

  ///This functions returns a future of boolean stating if the user provided data is correct
  Future<bool> validerOTP({required String otpEntrer}) async {
    if (otpEntrer.isNotEmpty) {
      http.Response response = await http.post(Uri.parse("$urlPrefixe/$dossierUsager/compare_otp.php"), body: {
        conStrColUsagerCourriel: courriel.trim(),
        'otp': otpEntrer.trim(),
      });

      String data = response.body;
      if (data.toLowerCase() == 'true' || data == '1') {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }
}
