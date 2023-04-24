import 'package:flutter/material.dart';

import 'crud_items_affiche_utils.dart';
import 'data_source_information.dart';
import 'global_function_jpl_utils.dart';

class MyData extends DataTableSource {
  ///Une simplification de l'objet DataTableSource qui contient le getRow déjà construit et qui s'affiche selon les paramètres
  ///
  /// [objects] est une liste d'objet contenant tout les données du format de l'objet
  /// Généralement : [asyncSnapshot.data]!
  ///
  /// [getCell] une fonction qui recoit en paramètre un object pour aller chercher sa liste de cellule
  /// Généralement : if (object is [Type de mon objet]) {return object.cells();}
  ///
  /// [informationDataSource]  Une liste de InformationDataSource définit dans la class de mon objet
  /// Généralement : TypeDeMonObjet.informationDataSource,
  ///
  /// [success] une fonction de quoi effectuer dans le cas d'un success
  /// Généralement : setState(() {});
  MyData({
    required this.context,
    required this.objects,
    required this.getCell,
    required this.informationDataSource,
    required this.success,
  });

  BuildContext context;
  List<dynamic> objects;
  Function(dynamic object) getCell;
  List<DataSourceInformation> informationDataSource;
  Function() success;

  @override
  DataRow? getRow(int index) {
    List<dynamic> cells = getCell(objects[index]);
    dynamic object = objects[index];
    return DataRow(
      cells: CrudItemAfficheUtils.modelBuilder(cells, (index, cell) {
        //Si la cellule contient une valeur bool
        if (cell is bool) {
          return DataCell(
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Icon(cell == true ? Icons.check_box : Icons.check_box_outline_blank),
              ), onTap: () async {
            Future<bool> Function(BuildContext, Object)? onTap = informationDataSource[index].cellEdition;
            if (onTap != null) {
              bool reponse = await onTap(context, object);
              if (reponse) {
                success();
              }
            }
          });
          //Si la cellule contient une valeur date heure
        } else if (cell is DateTime) {
          String valeur = GlobalFunctionJPLUtils.formatDateYYYYMMDD(cell);
          return DataCell(
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                valeur,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            onTap: () async {
              Future<bool> Function(BuildContext, Object)? onTap = informationDataSource[index].cellEdition;
              if (onTap != null) {
                bool reponse = await onTap(context, object);
                if (reponse) {
                  success();
                }
              }
            },
          );
          //Si la cellule contient une icon
        } else if (cell is IconData) {
          return DataCell(
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Center(
                  child: Icon(
                cell,
                color: Theme.of(context).colorScheme.primary,
              )),
            ),
            onTap: () async {
              Future<bool> Function(BuildContext, Object)? onTap = informationDataSource[index].cellEdition;
              if (onTap != null) {
                bool reponse = await onTap(context, object);
                if (reponse) {
                  success();
                }
              }
            },
          );
        }
        //Éviter d'afficher le text null
        if (cell.toString() == 'null') {
          cell = '';
        }
        //Sinon afficher une cellule avec le texte dedans
        return DataCell(
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              '$cell',
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          onTap: () async {
            Future<bool> Function(BuildContext, Object)? onTap = informationDataSource[index].cellEdition;
            if (onTap != null) {
              bool reponse = await onTap(context, object);
              if (reponse) {
                success();
              }
            }
          },
        );
      }),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => objects.length;

  @override
  int get selectedRowCount => 0;
}
