
import 'package:flutter/material.dart';

import 'crud_items_affiche_utils.dart';
import 'data_source_information.dart';
import 'global_function_jpl_utils.dart';

class MyData extends DataTableSource {
  MyData({
    required this.context,
    required this.objects,
    required this.getCell,
    required this.informationDataSource,
    required this.success,
  });

  BuildContext context;
  List<Object> objects;
  Function(Object object) getCell;
  List<DataSourceInformation> informationDataSource;
  Function() success;

  @override
  DataRow? getRow(int index) {
    List<dynamic> cells = getCell(objects[index]);
    Object object = objects[index];
    return DataRow(
      cells: CrudItemAfficheUtils.modelBuilder(cells, (index, cell) {
        if (cell is bool) {
          return DataCell(
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Icon(cell == true ? Icons.check_box : Icons.check_box_outline_blank),
              ), onTap: () async {
            Future<bool> Function(BuildContext, Object) onTap = informationDataSource[index].cellEdition;

            bool reponse = await onTap(context, object);
            if (reponse) {
              success();
            }
          });
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
              Future<bool> Function(BuildContext, Object) onTap = informationDataSource[index].cellEdition;
              bool reponse = await onTap(context, object);
              if (reponse) {
                success();
              }
            },
          );
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
              Future<bool> Function(BuildContext, Object) onTap = informationDataSource[index].cellEdition;
              bool reponse = await onTap(context, object);
              if (reponse) {
                success();
              }
            },
          );
        }
        if (cell.toString() == 'null') {
          cell = '';
        }
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
            Future<bool> Function(BuildContext, Object) onTap = informationDataSource[index].cellEdition;
            bool reponse = await onTap(context, object);
            if (reponse) {
              success();
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
