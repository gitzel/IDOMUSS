import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';

class MenuComplemento extends StatefulWidget {
  String numero;
  LatLng pos;

  MenuComplemento(this.numero, this.pos);

  @override
  _MenuComplementoState createState() => _MenuComplementoState();
}

class _MenuComplementoState extends State<MenuComplemento> {
  TextEditingController _numeroController,
      _complementoController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    _numeroController = new TextEditingController(text: widget.numero);
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(paddingSmall),
            child: Text(
              "Veja se o número da residência está correto",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: fontSizeRegular),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(paddingSmall),
            child: TextFormField(
              controller: _numeroController,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                hintText: "Digite o número da residência",
                prefixIcon: Icon(Icons.search),
                fillColor: ColorSys.lightGray,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(paddingSmall),
            child: Text(
              "Se tiver complemento, pode me falar!",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: fontSizeRegular),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(paddingSmall),
            child: TextFormField(
              controller: _complementoController,
              decoration: InputDecoration(
                hintText: "Ex. Torre XX APT XX",
                prefixIcon: Icon(Icons.search),
                fillColor: ColorSys.lightGray,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(paddingSmall),
              child: Container(
                width: double.infinity,
                child: RaisedButton(
                  child: Text("Salvar"),
                  onPressed: _numeroController.text.isEmpty
                      ? null
                      : () {
                          Navigator.pop(context);
                          Navigator.pop(context, [
                            widget.pos,
                            widget.numero,
                            _complementoController.text ?? ""
                          ]);
                        },
                ),
              )),
        ],
      ),
    );
  }
}
