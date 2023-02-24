
import 'package:flutter/material.dart';

import 'drop_down_object.dart';
import 'enum_des_type_colonnes.dart';

class DataSourceInformation {
  String titreColonne;
  String? titreColonneAjouter;
  Future<bool> Function(BuildContext context, Object object) cellEdition;
  TypeColonne typeColonneAjouter;
  String? ajouterDefaultValue;
  void Function(List<Object> data, int columnIndex, bool ascending)? dataColumnSortCallback;
  Future<List<DropdownObject>> Function()? listFunctionInformationDropdownObject;
  DataSourceInformation(
      {required this.titreColonne,
      this.titreColonneAjouter,
      required this.cellEdition,
      required this.typeColonneAjouter,
      this.listFunctionInformationDropdownObject,
      this.ajouterDefaultValue,
      this.dataColumnSortCallback}); 
}