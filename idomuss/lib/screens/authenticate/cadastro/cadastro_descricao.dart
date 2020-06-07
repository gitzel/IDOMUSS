import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idomuss/components/textFieldOutline.dart';
import 'package:idomuss/components/titulo_cadastro.dart';
import 'package:idomuss/screens/authenticate/cadastro/cadastro_documentos.dart';
import 'package:idomuss/screens/authenticate/cadastro/cadastroScaffold.dart';
import 'package:idomuss/models/cliente.dart';
import 'package:idomuss/screens/authenticate/cadastro/cadastro_foto.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadastroDescricao extends StatefulWidget {
  Cliente cliente;
  CadastroDescricao({this.cliente});

  @override
  _CadastroDescricaoState createState() => _CadastroDescricaoState();
}

class _CadastroDescricaoState extends State<CadastroDescricao> {
  String descricao;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    descricao = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CadastroScaffold(
      <Widget>[
        BackButton(),
        TextCadastro('Tô curioso agora! Fala para mim um pouco sobre você!'),
        Form(
          key: _formKey,
          child: Row(
            children: <Widget>[
              Expanded(
                  child: TextFieldOutline(
                label: 'Descrição',
                hint:
                    'Sou uma pessoa muito organizada, gosto de trabalhar com tal coisa e assisto muita série...',
                keyboardType: TextInputType.multiline,
                maxLine: 12,
                validator: (val) =>
                    val.length < 15 ? "Escreva só um pouquinho de você!" : null,
                onChanged: (val) {
                  setState(() {
                    if (_formKey.currentState.validate()) {
                      descricao = val;
                    }
                  });
                },
              )),
            ],
          ),
        ),
      ],
      descricao.isNotEmpty
          ? () {
              widget.cliente.descricao = descricao;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadastroFoto(
                      cliente: widget.cliente,
                    ),
                  ));
            }
          : null,
    );
  }
}
