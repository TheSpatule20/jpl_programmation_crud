import 'package:crud_item_jpl/src/drop_down_object.dart';
import 'package:crud_item_jpl/src/enum_des_type_colonnes.dart';
import 'package:crud_item_jpl/src/inputFields/loading.dart';
import 'package:crud_item_jpl/src/inputFields/text_field_container.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:textfield_search/textfield_search.dart';

//Peux être utile un jour https://pub.dev/packages/mask_text_input_formatter

class RoundedInputField extends StatefulWidget {
  final String? hintText;
  final IconData? icon;
  final ValueChanged<String?>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final int intTailleMultiplieur;
  final List<TextInputFormatter>? inputFormat;
  final bool editable;
  final TypeColonne? typeColumn;
  final List<DropdownObject>? itemDropDown;
  final TextInputType? textInputType;
  final Function()? onUnfocus;
  final ValueChanged<String>? onFieldSubmitted;

  const RoundedInputField({
    Key? key,
    this.hintText,
    this.icon,
    this.onChanged,
    this.intTailleMultiplieur = 1,
    this.validator,
    this.controller,
    this.inputFormat,
    this.editable = true,
    this.typeColumn = TypeColonne.string,
    this.itemDropDown,
    this.textInputType,
    this.onUnfocus,
    this.onFieldSubmitted,
  }) : super(key: key);

  @override
  State<RoundedInputField> createState() => _RoundedInputFieldState();
}

class _RoundedInputFieldState extends State<RoundedInputField> {
  bool? checkBox = true;
  List<TextInputFormatter> inputFormat = [];
  String valeurEnEntrant = '';
  @override
  Widget build(BuildContext context) {
    //constStrSearchField
    if (widget.typeColumn == TypeColonne.searchField) {
      if (widget.itemDropDown != null) {
        List<String> a = [];

        for (var element in widget.itemDropDown!) {
          a.add(element.titre);
        }

        return TextFieldContainer(
          dblTailleMultiplieur: (1 / widget.intTailleMultiplieur),
          child: TextFieldSearch(
            label: '',
            controller: widget.controller!,
            initialList: a,
            getSelectedValue: (value) {
              widget.controller!.text = value;
            },
            decoration: InputDecoration(
              icon: const Icon(Icons.arrow_drop_down),
              labelText: widget.hintText,
              border: InputBorder.none,
            ),
          ),
        );
      }
    }

    //Dropdown
    if (widget.typeColumn == TypeColonne.dropdown) {
      if (widget.itemDropDown != null) {
        List<DropdownMenuItem<DropdownObject>>? items = widget.itemDropDown?.map<DropdownMenuItem<DropdownObject>>((valeur) {
          return DropdownMenuItem<DropdownObject>(
            value: valeur,
            child: Text(valeur.titre),
          );
        }).toList();

        DropdownObject? valeur;
        if (widget.controller!.text.isNotEmpty) {
          valeur = items!
              .firstWhere((element) => element.value!.id.toString() == widget.controller!.text,
                  orElse: () => const DropdownMenuItem<DropdownObject>(
                        value: null,
                        child: Text(''),
                      ))
              .value;
        }

        TextEditingController siNonEditable = TextEditingController(text: valeur == null ? '' : valeur.titre);
        return TextFieldContainer(
          dblTailleMultiplieur: (1 / widget.intTailleMultiplieur),
          child: widget.editable
              ? DropdownButtonFormField<DropdownObject>(
                  isExpanded: true,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    icon: const Icon(Icons.arrow_drop_down),
                    labelText: widget.hintText,
                    border: InputBorder.none,
                  ),
                  items: items,
                  value: valeur,
                  onChanged: ((value) {
                    if (widget.editable) {
                      if (value != null) {
                        widget.controller!.text = value.id.toString();
                        if (widget.onChanged != null) {
                          widget.onChanged!(value.id.toString());
                        }
                      }
                    }
                  }),
                )
              : TextFormField(
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  decoration: InputDecoration(
                    icon: const Icon(Icons.arrow_drop_down),
                    labelText: widget.hintText,
                    border: InputBorder.none,
                  ),
                  enabled: widget.editable,
                  controller: siNonEditable,
                ),
        );
      }
    }

    //bool
    if (widget.typeColumn == TypeColonne.bool) {
      setState(() {
        if (widget.controller!.text != '') {
          checkBox = widget.controller!.text == 'true';
        }
        widget.controller!.text = checkBox.toString();
      });
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.hintText ?? '',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Checkbox(
            value: checkBox,
            onChanged: (value) {
              setState(() {
                checkBox = value;
                widget.controller!.text = value.toString();
                if (widget.onChanged != null) {
                  widget.onChanged!(value.toString());
                }
              });
            },
          ),
        ],
      );
    }

    //date
    if (widget.typeColumn == TypeColonne.date) {
      return TextFieldContainer(
        dblTailleMultiplieur: (1 / widget.intTailleMultiplieur),
        child: TextFormField(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
            );
            if (pickedDate != null) {
              String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
              setState(() {
                widget.controller!.text = formattedDate;
              });
            } else {}
          },
          decoration: InputDecoration(
            icon: const Icon(Icons.calendar_today),
            labelText: widget.hintText,
            border: InputBorder.none,
          ),
          readOnly: true,
          controller: widget.controller,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }

    //time
    if (widget.typeColumn == TypeColonne.time) {
      return TextFieldContainer(
        dblTailleMultiplieur: (1 / widget.intTailleMultiplieur),
        child: TextFormField(
          onTap: () async {
            DateFormat formatter = DateFormat("HH:mm");
            DateTime dateTime = DateTime.now();

            try {
              if (widget.controller!.text != '') {
                dateTime = formatter.parse(widget.controller!.text);
              }

              TimeOfDay? pickedDate = await showTimePicker(
                context: context,
                initialTime: widget.controller?.text == '' ? TimeOfDay.now() : TimeOfDay.fromDateTime(dateTime),
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      alwaysUse24HourFormat: true,
                    ),
                    child: child!,
                  );
                },
              );
              if (pickedDate != null) {
                String formattedDate = '${pickedDate.hour.toString().padLeft(2, '0')}:${pickedDate.minute.toString().padLeft(2, '0')}';
                setState(() {
                  widget.controller!.text = formattedDate;
                });
              } else {}
            } catch (e) {
              if (kDebugMode) {
                print("Error parsing date: $e");
              }
            }
          },
          decoration: InputDecoration(
            icon: const Icon(Icons.calendar_today),
            labelText: widget.hintText,
            border: InputBorder.none,
          ),
          readOnly: true,
          controller: widget.controller,
          style: const TextStyle(fontWeight: FontWeight.bold),
          validator: widget.validator,
        ),
      );
    }

    // Ajouter tout les inputs formats
    for (var element in widget.inputFormat ?? []) {
      inputFormat.add(element);
    }

    if (widget.typeColumn == TypeColonne.phone || widget.typeColumn == TypeColonne.int) {
      inputFormat.add(FilteringTextInputFormatter.digitsOnly);
    }

    // String
    return Focus(
      onFocusChange: (value) async {
        if (value == false) {
          if (widget.onUnfocus != null) {
            if (widget.controller != null && valeurEnEntrant != widget.controller!.text) {
              widget.onUnfocus!.call();
            }
          }
        } else {
          valeurEnEntrant = widget.controller!.text;
        }
      },
      child: TextFieldContainer(
        dblTailleMultiplieur: (1 / widget.intTailleMultiplieur),
        child: TextFormField(
          onFieldSubmitted: widget.onFieldSubmitted,
          keyboardType: widget.textInputType,
          maxLines: widget.typeColumn == TypeColonne.text ? null : 1,
          enabled: widget.editable,
          decoration: InputDecoration(
            icon: widget.icon != null
                ? null
                : Icon(
                    widget.icon,
                  ),
            labelText: widget.hintText,
            border: InputBorder.none,
          ),
          validator: (value) => widget.validator!(value),
          controller: widget.controller,
          style: const TextStyle(fontWeight: FontWeight.bold),
          inputFormatters: inputFormat,
        ),
      ),
    );
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final regEx = RegExp(r"^[+-]?\d*\.?\d*");
    String newString = regEx.stringMatch(newValue.text) ?? "";
    return newString == newValue.text ? newValue : oldValue;
  }
}

class IntTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final regEx = RegExp(r"^[+-]?\d*");
    String newString = regEx.stringMatch(newValue.text) ?? "";
    return newString == newValue.text ? newValue : oldValue;
  }
}

class RoundedButton extends StatefulWidget {
  final bool primary;
  final String text;
  final VoidCallback press;
  //final Color color, textColor;
  final bool small;

  void pressFunction() {
    press;
  }

  const RoundedButton({
    Key? key,
    required this.text,
    required this.press,
    //this.color = clrSecondary,
    //this.textColor = clrwhite,
    this.primary = true,
    this.small = false,
  }) : super(key: key);

  @override
  State<RoundedButton> createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton> {
  bool blnLoadingAnimation = false;

  double minWidth = 200;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var borderRadius = BorderRadius.circular(29);
    return Container(
      margin: const EdgeInsets.all(4),
      constraints: widget.small
          ? BoxConstraints(minWidth: (minWidth / 4) * 3, minHeight: widget.primary ? (80 / 4) * 3 : (60 / 4) * 3)
          : BoxConstraints(minWidth: minWidth, minHeight: widget.primary ? 80 : 60),
      width: widget.primary ? size.width * 0.20 : size.width * 0.10,
      height: widget.primary ? size.height * 0.08 : size.height * 0.04,
      decoration: BoxDecoration(
        border: Border.all(width: 2),
        borderRadius: borderRadius,
        shape: BoxShape.rectangle,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: TextButton(
            onPressed: widget.press,
            child: (blnLoadingAnimation
                ? const JPLLoadingCircular()
                : Text(
                    widget.text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ))),
      ),
    );
  }
}

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<String> validator;

  const RoundedPasswordField({
    Key? key,
    this.onChanged,
    required this.hintText,
    required this.controller,
    required this.validator,
    this.onFieldSubmitted,
  }) : super(key: key);

  @override
  State<RoundedPasswordField> createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        onFieldSubmitted: widget.onFieldSubmitted,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        obscureText: !_showPassword,
        onChanged: widget.onChanged,
        //cursorColor: clrSecondary,
        validator: (value) => widget.validator(value),
        decoration: InputDecoration(
          hintText: widget.hintText,
          icon: const Icon(
            Icons.lock,
            //color: clrBlack,
          ),
          suffixIcon: IconButton(
              icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
              //color: clrSecondary,
              onPressed: () {
                setState(() {
                  _showPassword = !_showPassword;
                });
              }),
          border: InputBorder.none,
        ),
        controller: widget.controller,
      ),
    );
  }
}
