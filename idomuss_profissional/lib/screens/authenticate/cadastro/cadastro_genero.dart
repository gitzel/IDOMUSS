import 'package:flutter/material.dart';
import 'package:idomussprofissional/components/radio_button.dart';
import 'package:idomussprofissional/components/titulo_cadastro.dart';
import 'package:idomussprofissional/helpers/ColorsSys.dart';
import 'package:idomussprofissional/screens/authenticate/cadastro/cadastroScaffold.dart';
import 'package:idomussprofissional/screens/authenticate/cadastro/cadastro_nascimento.dart';
import 'package:idomussprofissional/models/profissional.dart';

class CadastroGenero extends StatefulWidget {
  Profissional profissional;
  CadastroGenero({this.profissional});

  @override
  _CadastroGeneroState createState() => _CadastroGeneroState();
}

class _CadastroGeneroState extends State<CadastroGenero> {
  final _formKey = GlobalKey<FormState>();
  String _genero;

  @override
  void initState() {
    _genero = "";
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
              TextCadastro('Com qual gênero você se identifica?'),
              RadioButton(
                value: 'Masculino',
                groupValue: _genero,
                onChanged: (String value) {
                  setState(() {
                    _genero = value;
                  });
                },
              ),
              RadioButton(
                value: 'Feminino',
                groupValue: _genero,
                onChanged: (String value) {
                  setState(() {
                    _genero = value;
                  });
                },
              ),
              RadioButton(
                value: 'Prefiro não dizer',
                groupValue: _genero,
                onChanged: (String value) {
                  setState(() {
                    _genero = value;
                  });
                },
              ),
            ],
          ),
        ),
      ],
      _genero.isNotEmpty
          ? () {
              if (_genero == 'Prefiro não dizer')
                widget.profissional.querGenero = 0;
              else
                widget.profissional.genero = _genero;

              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadastroNascimento(
                      profissional: widget.profissional,
                    ),
                  ));
            }
          : null,
    );
  }
}
