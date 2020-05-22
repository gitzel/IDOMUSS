import 'package:flutter/material.dart';
import 'package:idomuss/components/textFieldOutline.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';
import 'package:idomuss/screens/authenticate/cadastro/cadastro_telefone.dart';
import 'package:idomuss/screens/authenticate/cadastroScaffold.dart';
import 'package:idomuss/models/cliente.dart';
import 'package:email_validator/email_validator.dart';

class CadastroNome extends StatefulWidget {
  Cliente cliente;
  CadastroNome({this.cliente});

  @override
  _CadastroNomeState createState() => _CadastroNomeState();
}

class _CadastroNomeState extends State<CadastroNome> {
  bool valorValido;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    valorValido = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CadastroScaffold(
      children: <Widget>[
        BackButton(
          color: ColorSys.primary,
        ),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: paddingMedium, bottom: paddingSmall),
                child: Text(
                  'Qual é o seu nome?',
                  style: TextStyle(
                      color: ColorSys.black, fontSize: fontSizeRegular),
                ),
              ),
              TextFieldOutline(
                prefixIcon: Icons.person,
                label: 'Nome',
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: paddingMedium, bottom: paddingSmall),
                child: Text(
                  'E o seu sobrenome?',
                  style: TextStyle(
                      color: ColorSys.black, fontSize: fontSizeRegular),
                ),
              ),
              TextFieldOutline(
                prefixIcon: Icons.person,
                label: 'Sobrenome',
              ),
            ],
          ),
        ),
      ],
      labelButtonBottomBar: 'Continuar',
      onPressed: valorValido
          ? () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadastroTelefone(
                      cliente: widget.cliente,
                    ),
                  ));
            }
          : null,
    );
  }
}
