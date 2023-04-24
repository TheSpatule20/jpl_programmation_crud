import 'package:flutter/material.dart';

import 'drop_down_object.dart';
import 'enum_des_type_colonnes.dart';

class DataSourceInformation {
  String titreColonne;
  Future<bool> Function(BuildContext context, dynamic object)? cellEdition;
  TypeColonne typeColonne;
  String? ajouterDefaultValue;
  void Function(List<dynamic> data, int columnIndex, bool ascending)? dataColumnSortCallback;
  Future<List<DropdownObject>> Function()? listFunctionInformationDropdownObject;

  ///Pour chaque champs (Colonnes) à afficher dans un tableau
  ///
  ///[titreColonne] Le nom qui doit être afficher
  ///[cellEdition] Function qui permet l'edition d'un information de cette colonne
  ///[typeColonne] Le type de donnée qui doit être afficher
  ///[listFunctionInformationDropdownObject] //Si c'est un dropdown la liste de toutes les informations doit être passé ici
  ///[ajouterDefaultValue] //La valeur par défaut lorsque tu en créer un nouveau
  ///[dataColumnSortCallback] //Pour trier les données
  DataSourceInformation({
    required this.titreColonne,
    this.cellEdition,
    required this.typeColonne,
    this.listFunctionInformationDropdownObject,
    this.ajouterDefaultValue,
    this.dataColumnSortCallback,
  });
}
