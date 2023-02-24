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

  static double? stringToDouble(String str) {
    str = str.replaceAll(RegExp(r','), '.');
    if (str.contains('null')) {
      return null;
    }
    return double.parse(str);
  }

  static void erreurInatendu(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text("Une erreur c'est produit, veuillez réessayer plus tard")));
  }
}
