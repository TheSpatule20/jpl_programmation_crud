import 'package:flutter/material.dart';

class TextFieldContainer extends StatefulWidget {
  final Widget child;
  final double dblTailleMultiplieur;
  const TextFieldContainer({
    Key? key,
    required this.child,
    this.dblTailleMultiplieur = 1,
  }) : super(key: key);

  @override
  State<TextFieldContainer> createState() => _TextFieldContainerState();
}

class _TextFieldContainerState extends State<TextFieldContainer> {
  @override
  Widget build(BuildContext context) {
    //Calcule du nombre de pixel a retirer pour les margins si plusieurs
    int sizeOffset = 0;
    if (widget.dblTailleMultiplieur == 1 / 2) {
      sizeOffset = 4;
    } else if (widget.dblTailleMultiplieur == 1 / 3) {
      sizeOffset = 5;
    } else if (widget.dblTailleMultiplieur == 1 / 4) {
      sizeOffset = 6;
    }

    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.01, horizontal: 5),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      width: (size.width * 0.8 * widget.dblTailleMultiplieur) - sizeOffset,
      decoration: decorationAccents,
      child: widget.child,
    );
  }
}

BorderRadius borderRadius = BorderRadius.circular(29);

BoxDecoration decorationAccents = BoxDecoration(
  borderRadius: borderRadius,
  color: Colors.white,
  boxShadow: const [
    BoxShadow(
      offset: Offset(
        1.0,
        1.0,
      ),
      blurRadius: 3.0,
    ),
  ],
);
