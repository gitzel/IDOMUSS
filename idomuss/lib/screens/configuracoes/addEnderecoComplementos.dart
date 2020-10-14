import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:idomuss/components/textFieldOutline.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';
import 'package:idomuss/models/endereco.dart';
import 'package:idomuss/services/database.dart';
import 'package:provider/provider.dart';

class AdicionarComplemento extends StatefulWidget {

  Endereco novo;

  AdicionarComplemento(this.novo);

  @override
  _AdicionarComplementoState createState() => _AdicionarComplementoState();
}

class _AdicionarComplementoState extends State<AdicionarComplemento> {

  String numero, complemento, filtro;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    numero = complemento = filtro = "";
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(elevation: 0,),
      body: SingleChildScrollView(
              child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(paddingSmall),
              child: Text("Digite o número da residência",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSizeRegular,
                  color: ColorSys.black
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(paddingSmall),
              child: TextFieldOutline(
                hint: "Ex. 999",
                label: "Número",
                keyboardType: TextInputType.datetime,
                onChanged: (value) {setState(() => numero = value);},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(paddingSmall),
              child: Text("Caso tenha algum complemento, por favor, informe!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSizeRegular,
                  color: ColorSys.black
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(paddingSmall),
              child: TextFieldOutline(
                hint: "Ex. Torre 9 Ap 9",
                label: "Complemento",
                  onChanged: (value) {setState(() => complemento = value);},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(paddingSmall),
              child: Text("Por último, dê um apelido!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSizeRegular,
                  color: ColorSys.black
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(paddingSmall),
              child: TextFieldOutline(
                hint: "Ex. Minha casa",
                label: "Apelido",
                  onChanged: (value) {setState(() => filtro = value);},
              ),
            ),
            
          ],
        ),
      ),
      bottomNavigationBar: FlatButton(
        disabledColor: ColorSys.secundarygray,
        padding: EdgeInsets.all(paddingLarge),
        child: Text(
          "Salvar",
          style: TextStyle(color: Colors.white),
        ),
        color: ColorSys.primary,
        onPressed: numero.isEmpty  || filtro.isEmpty ? null:  () async{
          widget.novo.complemento = complemento;
          widget.novo.numero = numero;
          widget.novo.filtro = filtro;
          List<Location> locations = await locationFromAddress("${widget.novo.rua}, ${widget.novo.bairro}, ${widget.novo.cidade}, ${widget.novo.numero}");
          widget.novo.location = GeoPoint(locations.first.latitude, locations.first.longitude);
          DatabaseService(uid:user.uid).addUserAddress(widget.novo);
          Navigator.popUntil(context, (route) => route.isFirst);
        }),
    );
  }
}