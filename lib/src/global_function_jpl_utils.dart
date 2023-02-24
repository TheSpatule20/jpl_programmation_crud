import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
