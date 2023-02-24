import 'package:flutter/material.dart';

import 'data_source_information.dart';
import 'drop_down_object.dart';
import 'enum_des_type_colonnes.dart';
import 'inputFields/loading.dart';
import 'inputFields/rounded_object.dart';

class CrudItemsAjouter extends StatefulWidget {
  final String title;
  final Function(List<TextEditingController> listTextEditingController) press;
  final List<DataSourceInformation> informationDataSource;

  const CrudItemsAjouter({Key? key, required this.title, required this.press, required this.informationDataSource}) : super(key: key);

  @override
  State<CrudItemsAjouter> createState() => _CrudItemsAjouterState();
}

class _CrudItemsAjouterState extends State<CrudItemsAjouter> {
  List<TextEditingController> listTextEditingController = [];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.title, style: const TextStyle(fontSize: 24)),
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.informationDataSource.length,
              itemBuilder: (context, index) {
                listTextEditingController.add(TextEditingController());
                if (widget.informationDataSource[index].ajouterDefaultValue != null) {
                  listTextEditingController[index].text = widget.informationDataSource[index].ajouterDefaultValue!;
                }
                if (widget.informationDataSource[index].typeColonne == TypeColonne.nonAjoutable) {
                  return Container();
                }

                if (widget.informationDataSource[index].listFunctionInformationDropdownObject == null) {
                  return RoundedInputField(
                    hintText: widget.informationDataSource[index].titreColonne,
                    validator: null,
                    typeColumn: widget.informationDataSource[index].typeColonne,
                    controller: listTextEditingController[index],
                  );
                }

                return FutureBuilder<List<DropdownObject>>(
                    future: widget.informationDataSource[index].listFunctionInformationDropdownObject!.call(),
                    builder: (context, asyncSnapshot) {
                      if (!asyncSnapshot.hasData) {
                        return const JPLLoadingCircular();
                      }
                      return RoundedInputField(
                        itemDropDown: asyncSnapshot.data,
                        hintText: widget.informationDataSource[index].titreColonne,
                        validator: null,
                        typeColumn: widget.informationDataSource[index].typeColonne,
                        controller: listTextEditingController[index],
                      );
                    });
              },
            ),
            RoundedButton(
              text: 'Ajouter',
              press: () {
                widget.press(listTextEditingController);
              },
            ),
          ],
        ),
      ),
    );
  }
}
