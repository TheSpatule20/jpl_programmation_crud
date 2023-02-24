
import 'package:flutter/material.dart';

import 'crud_items_affiche_utils.dart';
import 'data_source_information.dart';

class CrudItemsAffiche extends StatefulWidget {
  ///Un PaginatedDataTable qui s'adapte totalement à n'importe quelle datasource recu
  const CrudItemsAffiche({
    Key? key,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.header,
    required this.object,
    required this.getCell,
    required this.success,
    required this.informationDataSource,
    this.rowsPerPage = 15,
  }) : super(key: key);

  final List<Object> object;
  final Function(Object object) getCell;
  final Function() success;
  final List<DataSourceInformation> informationDataSource;
  final Widget? header;
  final int rowsPerPage;
  final int? sortColumnIndex;
  final bool sortAscending;

  @override
  State<CrudItemsAffiche> createState() => _CrudItemsAfficheState();
}

class _CrudItemsAfficheState extends State<CrudItemsAffiche> {
  List<DataColumn> columns = [];
  int? sortColumnIndex;
  bool sortAscending = true;
  bool firstOpen = true;

  @override
  Widget build(BuildContext context) {
    final DataTableSource dataTableSource = CrudItemAfficheUtils.getDataTableSource(
      context: context,
      objects: widget.object,
      getCell: widget.getCell,
      informationDataSource: widget.informationDataSource,
      success: widget.success,
    );

    //À la première ouverture sort comme recu dans le widget
    if (firstOpen) {
      if (widget.sortColumnIndex != null) {
        widget.informationDataSource[widget.sortColumnIndex!].dataColumnSortCallback!(widget.object, widget.sortColumnIndex!, widget.sortAscending);
      }

      setState(() {
        sortColumnIndex = widget.sortColumnIndex;
        sortAscending = widget.sortAscending;
        firstOpen = false;
      });
    }

    //Création de Chaque colonnes de donnée
    columns = [];
    for (var element in widget.informationDataSource) {
      columns.add(
        DataColumn(
          label: Text(element.titreColonne, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.left),
          onSort: (columnIndex, ascending) {
            if (element.dataColumnSortCallback != null) {
              element.dataColumnSortCallback!(widget.object, columnIndex, ascending);
              setState(() {
                sortAscending = ascending;
                sortColumnIndex = columnIndex;
              });
            }
          },
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PaginatedDataTable(
                sortColumnIndex: sortColumnIndex,
                sortAscending: sortAscending,
                header: widget.header,
                rowsPerPage: widget.rowsPerPage,
                columnSpacing: 4,
                columns: columns,
                source: dataTableSource),
          ],
        ),
      ),
    );
  }
}
