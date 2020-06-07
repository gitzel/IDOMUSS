import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idomuss/components/textFieldOutline.dart';
import 'package:idomuss/components/titulo_cadastro.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/screens/authenticate/cadastro/cadastroScaffold.dart';
import 'package:idomuss/models/cliente.dart';
import 'package:idomuss/screens/authenticate/cadastro/cadastro_senha.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:cpfcnpj/cpfcnpj.dart';

class CadastroDocumento extends StatefulWidget {
  Cliente cliente;
  CadastroDocumento({this.cliente});

  @override
  _CadastroDocumentoState createState() => _CadastroDocumentoState();
}

class _CadastroDocumentoState extends State<CadastroDocumento> {
  String rg, cpf;
  final _formKey = GlobalKey<FormState>();
  var maskCPF = new MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});

  @override
  void initState() {
    rg = cpf = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CadastroScaffold(
      <Widget>[
        BackButton(
          color: ColorSys.primary,
        ),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextCadastro('Qual é o seu RG?'),
              TextFieldOutline(
                prefixIcon: Icons.dock,
                label: 'RG',
                keyboardType: TextInputType.text,
                validator: (val) => val.length > 0 ? null : "RG inválido!",
                onChanged: (val) {
                  setState(() {
                    if (_formKey.currentState.validate() || val.isNotEmpty) {
                      rg = val;
                      /*
                      TODO - RG validation
                      */
                    }
                  });
                },
              ),
              TextCadastro('E o seu CPF?'),
              TextFieldOutline(
                prefixIcon: Icons.done,
                label: 'CPF',
                keyboardType: TextInputType.number,
                validator: (val) => CPF.isValid(maskCPF.getUnmaskedText())
                    ? null
                    : "CPF inválido!",
                onChanged: (val) {
                  setState(() {
                    if (_formKey.currentState.validate()) {
                      cpf = val;
                    }
                  });
                },
                inputFormatter: [maskCPF],
              ),
            ],
          ),
        ),
      ],
      rg.isNotEmpty && cpf.isNotEmpty
          ? () {
              widget.cliente.rg = rg;
              widget.cliente.cpf = cpf;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadastroSenha(
                      cliente: widget.cliente,
                    ),
                  ));
            }
          : null,
    );
  }
}
