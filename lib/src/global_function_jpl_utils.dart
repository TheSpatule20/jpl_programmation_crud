import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../jpl_programmation_crud.dart';

class GlobalFunctionJPLUtils {
  static String formatDateYYYYMMDD(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }

    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    return dateFormat.format(dateTime);
  }

  ///Une fonction qui convertie un string en double.
  static double? stringToDouble(String str) {
    str = str.replaceAll(RegExp(r','), '.');
    if (str.contains('null')) {
      return null;
    }
    if (double.tryParse(str) == null) {
      return double.parse(str);
    } else {
      return null;
    }
  }

  /// Une fonction qui affiche une snackBar avec un code d'erreur si il est passeé en paramètre
  static void showSnackBarErreurInattendu({required BuildContext context, String? code}) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text("Une erreur c'est produite, veuillez réessayer plus tard : $code")));
  }
}

///Fonction pour analyser le retour d'un datasource
///Le string recu n'est pas vide
///ET que le string est un chiffre
///ET que le chiffre est plus grand ou égal à 1
bool analyseResponseBodyPourInt(String responseBody) {
  if (responseBody.isEmpty) {
    return false;
  }
  int? tryParse = int.tryParse(responseBody);
  if (tryParse != null) {
    return (tryParse >= 1 ? true : false);
  }

  return false;
}

int boolToJson(bool? bool) {
  if (bool == true) {
    return 1;
  }
  return 0;
}

bool? jsonToBool(var jsonValeur) {
  return jsonValeur == null ? null : (jsonValeur.toString() == '1' || jsonValeur.toString().toLowerCase() == 'true' ? true : false);
}

Future<bool> consulterField(BuildContext context, String valeur) async {
  showTextDialog(context, title: 'Consultation', value: valeur, editable: false, changerLaValeur: null);
  return false;
}

Future<bool> editField({
  required BuildContext context,
  required String titre,
  required String valeurOrigine,
  TextInputType? textInputType,
  List<DropdownObject>? listDropDownObject,
  required Future<bool> Function(String valeurChanger) changerLaValeur,
  TypeColonne? typeColumn,
}) async {
  return await showTextDialog(
    context,
    title: 'Modifier: $titre',
    value: valeurOrigine,
    textInputType: textInputType,
    editable: true,
    changerLaValeur: changerLaValeur,
    listDropDownObject: listDropDownObject,
    typeColumn: typeColumn,
  );
}

Future<bool> editBool({
  required BuildContext context,
  required String titre,
  required String text,
  required bool valeurOrigine,
  TextInputType? textInputType,
  required Future<bool> Function(String valeurChanger) changerLaValeur,
}) async {
  return await showTextDialog(
    context,
    title: 'Modifier: $titre',
    value: valeurOrigine.toString(),
    editable: true,
    isBool: true,
    text: text,
    changerLaValeur: changerLaValeur,
  );
}

Future<T?> showTextDialog<T>(
  BuildContext context, {
  required String title,
  String? text,
  required String value,
  TextInputType? textInputType,
  bool editable = false,
  bool isBool = false,
  List<DropdownObject>? listDropDownObject,
  Future<bool> Function(String valeurChanger)? changerLaValeur,
  TypeColonne? typeColumn,
}) =>
    showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (context) => TextDialogWidget(
        title: title,
        value: value,
        textInputType: textInputType,
        textEditable: editable,
        isBool: isBool,
        text: text,
        changerLaValeur: changerLaValeur,
        listDropDownObject: listDropDownObject,
        typeColumn: typeColumn,
      ),
    );

class TextDialogWidget extends StatefulWidget {
  final String title;
  final String value;
  final String? text;
  final TextInputType? textInputType;
  final bool textEditable;
  final bool isBool;
  final Future<bool> Function(String valeurChanger)? changerLaValeur;
  final List<DropdownObject>? listDropDownObject;
  final TypeColonne? typeColumn;

  const TextDialogWidget({
    Key? key,
    required this.title,
    required this.value,
    required this.textEditable,
    this.text,
    this.textInputType,
    required this.isBool,
    required this.changerLaValeur,
    this.listDropDownObject,
    this.typeColumn,
  }) : super(key: key);

  @override
  TextDialogWidgetState createState() => TextDialogWidgetState();
}

class TextDialogWidgetState extends State<TextDialogWidget> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text(widget.text ?? ''),
            widget.isBool == false
                ? RoundedInputField(
                    intTailleMultiplieur: 2,
                    typeColumn: widget.typeColumn,
                    validator: null,
                    controller: controller,
                    hintText: widget.title,
                    editable: widget.textEditable,
                    itemDropDown: widget.listDropDownObject,
                  )
                : Container(),
          ],
        ),
      ),
      actions: !widget.textEditable
          ? [
              ElevatedButton(
                child: const Text('Quitter'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ]
          : [
              ElevatedButton(
                child: const Text('Accepter'),
                onPressed: () {
                  if (widget.changerLaValeur != null) {
                    if (widget.isBool == false) {
                      widget.changerLaValeur!(controller.value.text);
                    } else {
                      widget.changerLaValeur!(controller.value.text == 'true' ? '0' : '1');
                    }

                    Navigator.of(context).pop(true);
                  } else {
                    Navigator.of(context).pop(false);
                  }
                },
              ),
              ElevatedButton(
                child: const Text('Annuler'),
                onPressed: () => Navigator.of(context).pop(false),
              )
            ],
    );
  }
}

int stringtointdef(String str, {int defaultValue = -1}) {
  try {
    return int.parse(str);
  } on FormatException {
    return defaultValue;
  }
}

bool isEmail(String email) {
  String p = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  RegExp regExp = RegExp(p);
  return regExp.hasMatch(email);
}
