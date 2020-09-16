import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idomussprofissional/components/textFieldOutline.dart';
import 'package:idomussprofissional/components/titulo_cadastro.dart';
import 'package:idomussprofissional/helpers/ColorsSys.dart';
import 'package:idomussprofissional/screens/authenticate/cadastro/cadastroScaffold.dart';
import 'package:idomussprofissional/screens/authenticate/cadastro/cadastro_senha.dart';
import 'package:idomussprofissional/models/profissional.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:cpfcnpj/cpfcnpj.dart';

class CadastroDocumento extends StatefulWidget {
  Profissional profissional;
  CadastroDocumento({this.profissional});

  @override
  _CadastroDocumentoState createState() => _CadastroDocumentoState();
}

class _CadastroDocumentoState extends State<CadastroDocumento> {
  String rg, cpf, cnpj;
  final _formKey = GlobalKey<FormState>();
  var maskCPF = new MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});

  var maskCNPJ = new MaskTextInputFormatter(
      mask: '##.###.###/####-## ', filter: {"#": RegExp(r'[0-9]')});

  @override
  void initState() {
    rg = cpf = cnpj = "";
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
                    cpf = val;
                    _formKey.currentState.validate();
                  });
                },
                inputFormatter: [maskCPF],
              ),
              TextCadastro('O CNPJ?'),
              TextFieldOutline(
                prefixIcon: Icons.done,
                label: 'CNPJ',
                keyboardType: TextInputType.number,
                validator: (val) => CNPJ.isValid(maskCNPJ.getUnmaskedText())
                    ? null
                    : "CNPJ inválido!",
                onChanged: (val) {
                  setState(() {
                    if (_formKey.currentState.validate()) {
                      cnpj = val;
                    }
                  });
                },
                inputFormatter: [maskCNPJ],
              ),
            ],
          ),
        ),
      ],
      cnpj.isNotEmpty && rg.isNotEmpty && cpf.isNotEmpty
          ? () {
              widget.profissional.rg = rg;
              widget.profissional.cpf = cpf;
              widget.profissional.cnpj = cnpj;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadastroSenha(
                      profissional: widget.profissional,
                    ),
                  ));
            }
          : null,
    );
  }
}
