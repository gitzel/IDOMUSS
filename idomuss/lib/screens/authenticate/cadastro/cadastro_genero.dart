import 'package:flutter/material.dart';
import 'package:idomuss/components/radio_button.dart';
import 'package:idomuss/components/titulo_cadastro.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/screens/authenticate/cadastro/cadastroScaffold.dart';
import 'package:idomuss/models/cliente.dart';
import 'package:idomuss/screens/authenticate/cadastro/cadastro_nascimento.dart';

class CadastroGenero extends StatefulWidget {
  Cliente cliente;
  CadastroGenero({this.cliente});

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
                widget.cliente.querGenero = 0;
              else
                widget.cliente.genero = _genero;

              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadastroNascimento(
                      cliente: widget.cliente,
                    ),
                  ));
            }
          : null,
    );
  }
}
