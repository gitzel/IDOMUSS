import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idomuss/components/textFieldOutline.dart';
import 'package:idomuss/components/titulo_cadastro.dart';
import 'package:idomuss/screens/authenticate/cadastro/cadastro_documentos.dart';
import 'package:idomuss/screens/authenticate/cadastro/cadastro_nome.dart';
import 'package:idomuss/screens/authenticate/cadastro/cadastroScaffold.dart';
import 'package:idomuss/models/cliente.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadastroNascimento extends StatefulWidget {
  Cliente cliente;
  CadastroNascimento({this.cliente});

  @override
  _CadastroNascimentoState createState() => _CadastroNascimentoState();
}

class _CadastroNascimentoState extends State<CadastroNascimento> {
  String dataNascimento;
  final _formKey = GlobalKey<FormState>();
  var maskFormatter = new MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});
  @override
  void initState() {
    dataNascimento = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CadastroScaffold(
      <Widget>[
        BackButton(),
        TextCadastro('Quando você nasceu?'),
        Form(
          key: _formKey,
          child: Row(
            children: <Widget>[
              Expanded(
                  child: TextFieldOutline(
                prefixIcon: Icons.calendar_today,
                label: 'Data de nascimento',
                hint: 'dd/mm/yyyy',
                keyboardType: TextInputType.datetime,
                validator: (val) => val.isEmpty ? "Número inválido!" : null,
                onChanged: (val) {
                  setState(() {
                    if (_formKey.currentState.validate()) {
                      dataNascimento = val;
                    }
                  });
                },
                inputFormatter: [
                  maskFormatter,
                  LengthLimitingTextInputFormatter(10)
                ],
              )),
            ],
          ),
        ),
      ],
      dataNascimento.isNotEmpty
          ? () {
              widget.cliente.dataNascimento = dataNascimento;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadastroDocumento(
                      cliente: widget.cliente,
                    ),
                  ));
            }
          : null,
    );
  }
}
