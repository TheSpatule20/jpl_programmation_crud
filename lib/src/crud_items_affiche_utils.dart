
import 'package:flutter/material.dart';

import 'data_source_information.dart';
import 'global_function_jpl_utils.dart';
import 'mes_donnee.dart';

class CrudItemAfficheUtils {
  static List<T> modelBuilder<M, T>(List<M> models, T Function(int index, M model) builder) =>
      models.asMap().map<int, T>((index, model) => MapEntry(index, builder(index, model))).values.toList();

  static DataTableSource getDataTableSource({
    required BuildContext context,
    required List<Object> objects,
    required Function(Object object) getCell,
    required List<DataSourceInformation> informationDataSource,
    required Function() success,
  }) {
    return MyData(context: context, objects: objects, getCell: getCell, informationDataSource: informationDataSource, success: success);
  }

  static List<DataRow> getRows({
    required BuildContext context,
    required List<Object> objects,
    required Function(Object object) getCell,
    required List<DataSourceInformation> informationDataSource,
    required Function() success,
  }) {
    return objects.map((Object object) {
      List<dynamic> cells = getCell(object);

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
    }).toList();
  }
}
