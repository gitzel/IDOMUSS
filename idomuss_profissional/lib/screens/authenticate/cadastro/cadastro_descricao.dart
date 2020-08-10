import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idomussprofissional/components/textFieldOutline.dart';
import 'package:idomussprofissional/components/titulo_cadastro.dart';
import 'package:idomussprofissional/screens/authenticate/cadastro/cadastro_documentos.dart';
import 'package:idomussprofissional/screens/authenticate/cadastro/cadastroScaffold.dart';
import 'package:idomussprofissional/screens/authenticate/cadastro/cadastro_foto.dart';
import 'package:idomussprofissional/models/profissional.dart';
import 'package:idomussprofissional/screens/authenticate/cadastro/cadastro_vip.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadastroDescricao extends StatefulWidget {
  Profissional profissional;
  CadastroDescricao({this.profissional});

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
              widget.profissional.descricao = descricao;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadastroVip(
                      profissional: widget.profissional,
                    ),
                  ));
            }
          : null,
    );
  }
}
