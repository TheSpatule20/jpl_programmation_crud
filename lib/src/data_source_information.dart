import 'package:crud_item_jpl/src/drop_down_object.dart';
import 'package:crud_item_jpl/src/enum_des_type_colonnes.dart';
import 'package:flutter/material.dart';

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