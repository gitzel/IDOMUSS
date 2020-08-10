import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idomussprofissional/components/textFieldOutline.dart';
import 'package:idomussprofissional/components/titulo_cadastro.dart';
import 'package:idomussprofissional/helpers/ColorsSys.dart';
import 'package:idomussprofissional/screens/authenticate/cadastro/cadastro_genero.dart';
import 'package:idomussprofissional/screens/authenticate/cadastro/cadastroScaffold.dart';
import 'package:idomussprofissional/models/profissional.dart';

class CadastroNome extends StatefulWidget {
  Profissional profissional;
  CadastroNome({this.profissional});

  @override
  _CadastroNomeState createState() => _CadastroNomeState();
}

class _CadastroNomeState extends State<CadastroNome> {
  String nome, sobrenome;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    nome = sobrenome = "";
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
              TextCadastro('Qual é o seu nome?'),
              TextFieldOutline(
                  prefixIcon: Icons.person,
                  label: 'Nome',
                  keyboardType: TextInputType.text,
                  validator: (val) => val.length > 0 ? null : "Nome inválido!",
                  onChanged: (val) {
                    setState(() {
                      if (_formKey.currentState.validate() || val.isNotEmpty) {
                        nome = val;
                      }
                    });
                  },
                  textCapitalization: TextCapitalization.words),
              TextCadastro('E o seu sobrenome?'),
              TextFieldOutline(
                  prefixIcon: Icons.person,
                  label: 'Sobrenome',
                  keyboardType: TextInputType.text,
                  validator: (val) =>
                      val.length > 0 ? null : "Sobrenome inválido!",
                  onChanged: (val) {
                    setState(() {
                      if (_formKey.currentState.validate()) {
                        sobrenome = val;
                      }
                    });
                  },
                  textCapitalization: TextCapitalization.words),
            ],
          ),
        ),
      ],
      nome.isNotEmpty && sobrenome.isNotEmpty
          ? () {
              widget.profissional.nome = nome + " " + sobrenome;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadastroGenero(
                      profissional: widget.profissional,
                    ),
                  ));
            }
          : null,
    );
  }
}
