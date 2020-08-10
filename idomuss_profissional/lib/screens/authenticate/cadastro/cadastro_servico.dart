import 'package:flutter/material.dart';
import 'package:idomussprofissional/components/radio_button.dart';
import 'package:idomussprofissional/components/titulo_cadastro.dart';
import 'package:idomussprofissional/helpers/ColorsSys.dart';
import 'package:idomussprofissional/models/profissional.dart';
import 'package:idomussprofissional/screens/authenticate/cadastro/cadastroScaffold.dart';
import 'package:idomussprofissional/screens/authenticate/cadastro/cadastro_descricao.dart';

class CadastroServico extends StatefulWidget {
  Profissional profissional;
  CadastroServico({this.profissional});

  @override
  _CadastroServicoState createState() => _CadastroServicoState();
}

class _CadastroServicoState extends State<CadastroServico> {
  final _formKey = GlobalKey<FormState>();
  String _servico;

  @override
  void initState() {
    _servico = "";
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
              TextCadastro('sla serviço?'),

              ///botar uma lista pra escolher
            ],
          ),
        ),
      ],
      _servico.isNotEmpty
          ? () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadastroDescricao(
                      profissional: widget.profissional,
                    ),
                  ));
            }
          : null,
    );
  }
}
