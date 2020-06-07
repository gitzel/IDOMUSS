import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idomuss/components/textFieldOutline.dart';
import 'package:idomuss/components/titulo_cadastro.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/screens/authenticate/cadastro/cadastro_genero.dart';
import 'package:idomuss/screens/authenticate/cadastro/cadastroScaffold.dart';
import 'package:idomuss/models/cliente.dart';

class CadastroNome extends StatefulWidget {
  Cliente cliente;
  CadastroNome({this.cliente});

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
              widget.cliente.nome = nome + " " + sobrenome;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadastroGenero(
                      cliente: widget.cliente,
                    ),
                  ));
            }
          : null,
    );
  }
}
