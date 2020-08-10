import 'package:flutter/material.dart';
import 'package:idomussprofissional/components/titulo_cadastro.dart';
import 'package:idomussprofissional/helpers/ColorsSys.dart';
import 'package:idomussprofissional/helpers/constantes.dart';
import 'package:idomussprofissional/screens/authenticate/cadastro/cadastro_telefone.dart';
import 'package:idomussprofissional/screens/authenticate/cadastro/cadastroScaffold.dart';
import 'package:email_validator/email_validator.dart';
import 'package:idomussprofissional/models/profissional.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  Profissional profissional;
  bool valorValido;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    profissional = new Profissional.empty();
    valorValido = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CadastroScaffold(
      <Widget>[
        BackButton(),
        TextCadastro('Qual é o seu email?'),
        Form(
          key: _formKey,
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                labelText: 'Email',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10))),
            validator: (val) =>
                !EmailValidator.validate(val) ? 'Email inválido!' : null,
            onChanged: (val) {
              setState(() {
                if (_formKey.currentState.validate()) {
                  profissional.email = val;
                  valorValido = true;
                } else {
                  valorValido = false;
                }
              });
            },
          ),
        ),
      ],
      valorValido
          ? () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadastroTelefone(
                      profissional: profissional,
                    ),
                  ));
            }
          : null,
    );
  }
}
