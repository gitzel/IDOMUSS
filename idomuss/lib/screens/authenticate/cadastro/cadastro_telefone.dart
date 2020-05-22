import 'package:flutter/material.dart';
import 'package:idomuss/components/textFieldOutline.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';
import 'package:idomuss/screens/authenticate/cadastro/cadastro_nome.dart';
import 'package:idomuss/screens/authenticate/cadastroScaffold.dart';
import 'package:idomuss/models/cliente.dart';
import 'package:email_validator/email_validator.dart';

class CadastroTelefone extends StatefulWidget {
  Cliente cliente;
  CadastroTelefone({this.cliente});

  @override
  _CadastroTelefoneState createState() => _CadastroTelefoneState();
}

class _CadastroTelefoneState extends State<CadastroTelefone> {
  bool valorValido;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    valorValido = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CadastroScaffold(
      children: <Widget>[
        BackButton(
          color: ColorSys.primary,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: paddingMedium),
          child: Text(
            'Qual é o seu número de celular?',
            style: TextStyle(color: ColorSys.black, fontSize: fontSizeRegular),
          ),
        ),
        Form(
          key: _formKey,
          child: Row(
            children: <Widget>[
              Expanded(
                  child: TextFieldOutline(
                prefixIcon: Icons.phone_iphone,
                label: 'Celular',
                hint: '(XX) X XXXX-XXXX',
                keyboardType: TextInputType.number,
                validator: (val) => val.isEmpty ? "Número inválido!" : null,
                onChanged: (val) {
                  setState(() {
                    if (_formKey.currentState.validate()) {
                      widget.cliente.numeroCelular = val;
                      valorValido = true;
                    } else {
                      valorValido = false;
                    }
                  });
                },
              )),
            ],
          ),
        ),
      ],
      labelButtonBottomBar: 'Continuar',
      onPressed: valorValido
          ? () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadastroNome(
                      cliente: widget.cliente,
                    ),
                  ));
            }
          : null,
    );
  }
}
