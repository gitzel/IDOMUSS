import 'dart:io';

import 'package:flutter/material.dart';
import 'package:idomuss/components/titulo_cadastro.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/screens/authenticate/cadastro/cadastroScaffold.dart';
import 'package:idomuss/models/cliente.dart';
import 'package:image_picker/image_picker.dart';
import 'package:idomuss/services/auth.dart';

class CadastroFoto extends StatefulWidget {
  Cliente cliente;
  CadastroFoto({this.cliente});

  @override
  _CadastroFotoState createState() => _CadastroFotoState();
}

class _CadastroFotoState extends State<CadastroFoto> {
  File foto;
  final picker = ImagePicker();

  final AuthService _auth = AuthService();

  @override
  void initState() {
    foto = null;
    super.initState();
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null)
        foto = File(pickedFile.path);
      else
        foto = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CadastroScaffold(
      <Widget>[
        BackButton(),
        TextCadastro(
            'Prometo que é o ultimo! Manda uma foto sua para colocar na foto de perfil!'),
        Center(
          child: GestureDetector(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.8,
              child: CircleAvatar(
                backgroundColor: foto == null ? ColorSys.primary : null,
                backgroundImage: foto != null ? FileImage(foto) : null,
                child: foto != null
                    ? null
                    : Center(
                        child: Container(
                            child: Icon(Icons.add_a_photo,
                                color: Colors.white,
                                size:
                                    MediaQuery.of(context).size.width * 0.2))),
              ),
            ),
            onTap: getImage,
          ),
        ),
      ],
      foto != null
          ? () {
              widget.cliente.foto = foto.path;
              widget.cliente.fotoFile = foto;
              _auth
                  .signUp(widget.cliente.email, widget.cliente.senha,
                      widget.cliente)
                  .then((value) {
                Navigator.popUntil(context, (route) => route.isFirst);
              });
            }
          : null,
      labelButtonBottomBar: "Finalizar",
    );
  }
}
