import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'basic_data_source/data_source_usager.dart';

Future<String> getBasicAuth() async {
  Usager connectedUsager = await Session.usagerInformationDeConnectionGet();

  String basicAuth = 'Basic ${base64Encode(utf8.encode('${connectedUsager.courriel.toString()}:${connectedUsager.motDePasse}'))}';

  return basicAuth;
}

class Session {
  static Usager constEmployeConnecte = Usager();

  /// Définit les informations de connexion de l'utilisateur dans les SharedPreferences.
  ///
  /// [usager] L'objet [Usager] contenant les informations de connexion.
  /// [enregistrerLesInformations] Un booléen indiquant si les informations de connexion doivent être enregistrées ou non.
  static Future<void> usagerInformationDeConnectionSet(Usager usager, bool enregistrerLesInformations) async {
    // On récupère l'instance de SharedPreferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // On convertit l'objet Usager en chaîne de caractères JSON
    String user = usager.toJson().toString();

    // On enregistre la chaîne de caractères JSON dans les SharedPreferences
    sharedPreferences.setString('usagerInformationDeConnection', user);

    // On enregistre le booléen "enregistrerLesInformations" dans les SharedPreferences
    sharedPreferences.setBool('enregistrerLesInformations', enregistrerLesInformations);

    // On définit la constante "constEmployeConnecte" avec l'objet Usager fourni en paramètre
    constEmployeConnecte = usager;
  }

  /// Récupère les informations de connexion de l'utilisateur à partir des SharedPreferences.
  ///
  /// Retourne l'objet [Usager] contenant les informations de connexion si elles existent, sinon un objet vide.
  static Future<Usager> usagerInformationDeConnectionGet() async {
    // On récupère l'instance de SharedPreferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // On récupère la chaîne de caractères JSON stockée dans les SharedPreferences sous la clé "usagerInformationDeConnection"
    var string = sharedPreferences.getString('usagerInformationDeConnection');

    if (string != null) {
      // On convertit la chaîne JSON en Map
      Map<String, dynamic> userMap = jsonDecode(string);

      // On crée un objet Usager à partir de la Map
      Usager user = Usager.fromJson(userMap);

      // On définit la constante "constEmployeConnecte" avec l'objet Usager créé
      constEmployeConnecte = user;

      // On retourne l'objet Usager créé
      return user;
    }

    // Si aucune information de connexion n'a été trouvée, on retourne un objet Usager vide
    return Usager();
  }

  /// Récupère la valeur booléenne indiquant si les informations de connexion doivent être enregistrées ou non.
  ///
  /// Retourne la valeur booléenne si elle existe, sinon null.
  static Future<bool?> usagerEnregistrerInformationsGet() async {
    // On récupère l'instance de SharedPreferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // On récupère la valeur booléenne stockée dans les SharedPreferences sous la clé "enregistrerLesInformations"
    var bool = sharedPreferences.getBool('enregistrerLesInformations');

    // On retourne la valeur booléenne récupérée, ou null si elle n'existe pas
    return bool;
  }

  /// Stocke les informations de connexion de l'utilisateur dans les SharedPreferences et définit la constante [constEmployeConnecte] avec l'objet [Usager] fourni en paramètre.
  ///
  /// [usager] L'objet [Usager] contenant les informations de connexion.
  static Future<void> usagerConnecterSet(Usager usager) async {
    // On récupère l'instance de SharedPreferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // On convertit l'objet Usager en chaîne de caractères JSON
    String user = usager.toJson().toString();

    // On enregistre la chaîne de caractères JSON dans les SharedPreferences
    sharedPreferences.setString('usagerConnecter', user);

    // On définit la constante "constEmployeConnecte" avec l'objet Usager fourni en paramètre
    constEmployeConnecte = usager;
  }

  /// Récupère les informations de connexion de l'utilisateur à partir des SharedPreferences.
  ///
  /// Retourne l'objet [Usager] contenant les informations de connexion si elles existent, sinon un objet vide.
  static Future<Usager> usagerConnecterGet() async {
    // On récupère l'instance de SharedPreferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // On récupère la chaîne de caractères JSON stockée dans les SharedPreferences sous la clé "usagerConnecter"
    var string = sharedPreferences.getString('usagerConnecter');

    if (string != null) {
      // On convertit la chaîne JSON en Map
      Map<String, dynamic> userMap = jsonDecode(string);

      // On crée un objet Usager à partir de la Map
      Usager user = Usager.fromJson(userMap);

      // On définit la constante "constEmployeConnecte" avec l'objet Usager créé
      constEmployeConnecte = user;

      // On retourne l'objet Usager créé
      return user;
    }

    // Si aucune information de connexion n'a été trouvée, on retourne un objet Usager vide
    return Usager();
  }
}
