import 'package:jpl_programmation_crud/jpl_programmation_crud.dart';

import 'package:flutter/material.dart';

import '../basic_data_source/data_source_adresse.dart';
import '../const.dart';

//String Extension pratique
extension StringCasingExtension on String {
  String toPremiereLettreMajuscule() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toPremiereLettreMajusculeEtApresTiret() => split('-').map((str) => str.toPremiereLettreMajuscule()).join('-');
  String toCodePostal() => replaceAll(RegExp(' +'), '').toUpperCase();
  String toTelephone() =>
      length == 9 ? "(${substring(0, 3)})${substring(3, 6)}-${substring(6, 10)}" : ''; //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  String toPosteTelephone() => '#$this'; //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
}


class CardAdresseObject {
  final TextEditingController ctlrPays = TextEditingController(text: 'Canada');
  final TextEditingController ctlrProvince = TextEditingController(text: 'Québec');
  final TextEditingController ctlrCodePostal = TextEditingController();
  final TextEditingController ctlrVille = TextEditingController();
  final TextEditingController ctlrLigne1 = TextEditingController();
  final TextEditingController ctlrLigne2 = TextEditingController();

  Widget getWidget({bool withTitle = true, bool withCard = true, required bool isPhone}) {
    return CardAdresse(
        ctlrPays: ctlrPays,
        ctlrProvince: ctlrProvince,
        ctlrCodePostal: ctlrCodePostal,
        ctlrVille: ctlrVille,
        ctlrLigne1: ctlrLigne1,
        ctlrLigne2: ctlrLigne2,
        withCard: withCard,
        withTitle: withTitle,
        isPhone: isPhone);
  }

  Adresse getAdresse() {
    String pays = ctlrPays.text.toPremiereLettreMajusculeEtApresTiret();
    String province = ctlrProvince.text.toPremiereLettreMajusculeEtApresTiret();

    List<DropdownObject> itemDropDownPays = [];

    for (var i = 0; i < constListePays.length; i++) {
      itemDropDownPays.add(DropdownObject(titre: constListePays[i], id: i));
    }

    List<DropdownObject> itemDropDownProvince = [];

    for (var i = 0; i < constListeProvinceCan.length; i++) {
      itemDropDownProvince.add(DropdownObject(titre: constListeProvinceCan[i], id: i));
    }

    if (stringtointdef(province) != -1) {
      province = itemDropDownProvince[stringtointdef(province)].titre;
    }

    Adresse adresse = Adresse(
      pays: itemDropDownPays[stringtointdef(pays)].titre,
      province: province,
      codePostal: ctlrCodePostal.text,
      ville: ctlrVille.text,
      ligne1: ctlrLigne1.text,
      ligne2: ctlrLigne2.text == 'null' ? '' : ctlrLigne2.text,
    );
    return adresse;
  }

  static Adresse getAdresseFromAdresse(Adresse pAdresse) {
    String pays = pAdresse.pays?.toPremiereLettreMajusculeEtApresTiret() ?? '';
    String province = pAdresse.province?.toPremiereLettreMajusculeEtApresTiret() ?? '';

    if (int.tryParse(pays) != null && int.tryParse(province) != null) {
      List<DropdownObject> itemDropDownPays = [];

      for (var i = 0; i < constListePays.length; i++) {
        itemDropDownPays.add(DropdownObject(titre: constListePays[i], id: i));
      }

      List<DropdownObject> itemDropDownProvince = [];

      for (var i = 0; i < constListeProvinceCan.length; i++) {
        itemDropDownProvince.add(DropdownObject(titre: constListeProvinceCan[i], id: i));
      }

      if (stringtointdef(province) != -1) {
        province = itemDropDownProvince[stringtointdef(province)].titre;
      }

      pAdresse.pays = itemDropDownPays[stringtointdef(pays)].titre;
      pAdresse.province = province;
    }

    return pAdresse;
  }
}

class CardAdresse extends StatefulWidget {
  final TextEditingController ctlrPays;
  final TextEditingController ctlrProvince;
  final TextEditingController ctlrCodePostal;
  final TextEditingController ctlrVille;
  final TextEditingController ctlrLigne1;
  final TextEditingController ctlrLigne2;
  final bool withTitle;
  final bool withCard;
  final bool isPhone;
  const CardAdresse({
    Key? key,
    required this.ctlrPays,
    required this.ctlrProvince,
    required this.ctlrCodePostal,
    required this.ctlrVille,
    required this.ctlrLigne1,
    required this.ctlrLigne2,
    this.withTitle = true,
    this.withCard = true,
    required this.isPhone,
  }) : super(key: key);

  @override
  State<CardAdresse> createState() => _CardAdresseState();
}

class _CardAdresseState extends State<CardAdresse> {
  bool isCanada = true;
  bool firstOpen = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<DropdownObject> itemDropDownPays = [];

    for (var i = 0; i < constListePays.length; i++) {
      itemDropDownPays.add(DropdownObject(titre: constListePays[i], id: i));
    }

    List<DropdownObject> itemDropDownProvince = [];

    for (var i = 0; i < constListeProvinceCan.length; i++) {
      itemDropDownProvince.add(DropdownObject(titre: constListeProvinceCan[i], id: i));
    }

    //Le pays est un string dans widget.ctlrPays.text, faut le mettre en int avec le bon juste si ont est dans le cas ou c'est pas un nombre
    if (int.tryParse(widget.ctlrPays.text) == null) {
      widget.ctlrPays.text = constListePays.indexOf(widget.ctlrPays.text).toString();
    }
    
    
    //La province est un string dans widget.ctlrProvince.text, faut le mettre en int avec le bon
    if (widget.ctlrPays.text == "38") {
      isCanada = true;
      
      widget.ctlrProvince.text = constListeProvinceCan.indexOf(widget.ctlrProvince.text).toString();
    } else {
      isCanada = false;
    }

    //Si  il est vide mettre le pays canada
    if (widget.ctlrPays.text == '') {
      widget.ctlrPays.text = "38";
    }

    //Si le pays est canada mettre province ou sinon mettre vide
    if (widget.ctlrPays.text != '38') {
      widget.ctlrProvince.text = (widget.ctlrProvince.text == '' ? "" : widget.ctlrProvince.text);
    } else {
      widget.ctlrProvince.text = (widget.ctlrProvince.text == '' ? "8" : widget.ctlrProvince.text);
    }

    var numeroAppRueVille = <Widget>[
      RoundedInputField(
        textInputType: TextInputType.text,
        intTailleMultiplieur: 1,
        controller: widget.ctlrLigne1,
        hintText: 'Adresse municipale',
        icon: Icons.home,
        validator: (value) {
          if (value!.isEmpty) {
            return entrezRue;
          }
          return null;
        },
      ),
      RoundedInputField(
          textInputType: TextInputType.text,
          intTailleMultiplieur: 1,
          controller: widget.ctlrLigne2,
          hintText: 'Apt, Suite, Unité, Immeuble',
          icon: Icons.apartment,
          validator: (value) {
            return null;
          }),
      RoundedInputField(
        textInputType: TextInputType.text,
        intTailleMultiplieur: 1,
        controller: widget.ctlrVille,
        hintText: ville,
        icon: Icons.map,
        validator: (value) {
          if (value!.isEmpty) {
            return entrezVille;
          }
          return null;
        },
      ),
    ];
    var paysProvinceCodePostal = <Widget>[
      RoundedInputField(
        typeColumn: TypeColonne.dropdown,
        textInputType: TextInputType.text,
        intTailleMultiplieur: widget.isPhone ? 1 : 3,
        controller: widget.ctlrPays,
        hintText: pays,
        icon: Icons.flag,
        onChanged: (value) {
          if (itemDropDownPays[stringtointdef(value!)].titre == 'Canada') {
            setState(() {
              isCanada = true;
            });
          } else {
            setState(() {
              isCanada = false;
              widget.ctlrProvince.text = '';
            });
          }
        },
        validator: (value) {
          if (value!.isEmpty) {
            return entrezPays;
          }
          return null;
        },
        itemDropDown: itemDropDownPays,
      ),
      isCanada
          ? RoundedInputField(
              typeColumn: TypeColonne.dropdown,
              textInputType: TextInputType.text,
              intTailleMultiplieur: widget.isPhone ? 1 : 3,
              controller: widget.ctlrProvince,
              hintText: province,
              icon: Icons.map,
              validator: (value) {
                if (value!.isEmpty) {
                  return entrezProvince;
                }
                return null;
              },
              itemDropDown: itemDropDownProvince,
            )
          : RoundedInputField(
              typeColumn: TypeColonne.string,
              textInputType: TextInputType.text,
              intTailleMultiplieur:  widget.isPhone ? 1 : 3,
              controller: widget.ctlrProvince,
              hintText: province,
              icon: Icons.map,
              validator: (value) {
                if (value!.isEmpty) {
                  return entrezProvince;
                }
                return null;
              },
            ),
      RoundedInputField(
        textInputType: TextInputType.text,
        intTailleMultiplieur: widget.isPhone ? 1 : 3,
        controller: widget.ctlrCodePostal,
        hintText: codePostal,
        icon: Icons.markunread_mailbox,
        validator: (value) {
          if (value!.isEmpty) {
            return entrezCodePostal;
          }
          return null;
        },
      ),
    ];
    var allIsNotPhone = <Widget>[
          widget.withTitle ? Text('Adresse', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)) : Container(),
        ] +
        numeroAppRueVille +
        [
          widget.isPhone
              ? Column(mainAxisAlignment: MainAxisAlignment.center, children: paysProvinceCodePostal)
              : Row(mainAxisAlignment: MainAxisAlignment.center, children: paysProvinceCodePostal)
          //Ville - rue - numero civique - appartement
        ];
    var content = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: widget.isPhone ? numeroAppRueVille + paysProvinceCodePostal : allIsNotPhone,
      ),
    );
    return widget.withCard
        ? Card(
            margin: EdgeInsets.symmetric(horizontal: (size.width > 1000 ? 80 : 5), vertical: 10),
            // color: Colors.grey[300],
            elevation: 2,
            child: content,
          )
        : content;
  }
}
