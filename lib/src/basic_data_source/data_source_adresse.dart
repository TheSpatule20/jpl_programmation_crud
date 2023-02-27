import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jpl_programmation_crud/jpl_programmation_crud.dart';

const String constStrAdresseId = 'adresseId';
const String constStrPays = 'pays';
const String constStrProvince = 'province';
const String constStrCodePostal = 'codePostal';
const String constStrVille = 'ville';
const String constStrLigne1 = 'ligne1';
const String constStrLigne2 = 'ligne2';

class Adresse{
  int? adresseId;
  String? pays;
  String? province;
  String? codePostal;
  String? ville;
  String? ligne1;
  String? ligne2;

  Adresse({
    this.adresseId,
    required this.pays,
    required this.province,
    required this.codePostal,
    required this.ville,
    required this.ligne1,
    this.ligne2,
  });

  factory Adresse.fromJson(Map<String, dynamic> json) {
    return Adresse(
      adresseId: json[constStrAdresseId] == null ? null : int.parse(json[constStrAdresseId].toString()),
      pays: json[constStrPays]?.toString(),
      province: json[constStrProvince]?.toString(),
      codePostal: json[constStrCodePostal]?.toString(),
      ville: json[constStrVille]?.toString(),
      ligne1: json[constStrLigne1]?.toString(),
      ligne2: json[constStrLigne2] == null ? '' : json[constStrLigne2].toString(),
    );
  }

  Map<String, String> toJson() => {
        jsonEncode(constStrAdresseId): jsonEncode(adresseId),
        jsonEncode(constStrPays): jsonEncode(pays),
        jsonEncode(constStrProvince): jsonEncode(province),
        jsonEncode(constStrCodePostal): jsonEncode(codePostal),
        jsonEncode(constStrVille): jsonEncode(ville),
        jsonEncode(constStrLigne1): jsonEncode(ligne1),
        jsonEncode(constStrLigne2): jsonEncode(ligne2),
      };

  static String adresseToString(Adresse adresse) {
    String adresseString = '';
    adresseString = '${adresse.ligne1 ?? ""} ${adresse.ville ?? ""} ${adresse.province ?? ""} ${adresse.pays ?? ""}, ${adresse.codePostal ?? ""}';
    if (adresseString == ",    , ") {
      adresseString = '';
    }

    return adresseString;
  }

  String toStringFormated() {
    Adresse adresseRetour =
        CardAdresseObject.getAdresseFromAdresse(Adresse(pays: pays, province: province, codePostal: codePostal, ville: ville, ligne1: ligne1, ligne2: ligne2));

    String adresseFormater = '';

    if (ligne2 == '') {
      adresseFormater += ligne1.toString();
    } else {
      adresseFormater += '$ligne1 $ligne2';
    }
    adresseFormater += ', $ville, $codePostal, ${adresseRetour.province}, ${adresseRetour.pays}';

    return adresseFormater;
  }
}

class DataSourceAdresse {
  String urlPrefixe, dossierAdresse;
  DataSourceAdresse({required this.urlPrefixe, required this.dossierAdresse});

  Future<Adresse> readOneWithAdresseId({required int adresseId}) async {
    String basicAuth = await getBasicAuth();

    final response = await http.post(
      Uri.parse("$urlPrefixe/$dossierAdresse/readOneWithAdresseId.php"),
      headers: {
        'authorization': basicAuth,
        "Cache-Control": "no-cache",
      },
      body: {
        constStrAdresseId: adresseId.toString(),
      },
    );

    Adresse adresse = Adresse(pays: '', province: '', codePostal: '', ville: '', ligne1: '');

    if (response.body != 'false') {
      adresse = Adresse.fromJson(json.decode(response.body));
    }

    return adresse;
  }

  Future<int> add(Adresse adresse) async {
    String basicAuth = await getBasicAuth();

    final response = await http.post(
      Uri.parse("$urlPrefixe/$dossierAdresse/add.php"),
      headers: {
        'authorization': basicAuth,
        "Cache-Control": "no-cache",
      },
      body: {
        'adresse': adresse.toJson().toString(),
      },
    );
    int adresseId = -1;

    if (response.body != 'false') {
      adresseId = json.decode(response.body);
    }

    return adresseId;
  }

  Future<bool> edit({required Adresse adresse}) async {
    String basicAuth = await getBasicAuth();

    final response = await http.post(
      Uri.parse("$urlPrefixe/$dossierAdresse/edit.php"),
      headers: {
        'authorization': basicAuth,
        "Cache-Control": "no-cache",
      },
      body: {
        'adresse': adresse.toJson().toString(),
      },
    );

    return response.body.toString().toLowerCase() == 'true' || response.body.toString().toLowerCase() == '1';
  }
}
