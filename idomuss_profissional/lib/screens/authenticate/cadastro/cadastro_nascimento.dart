import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idomussprofissional/components/textFieldOutline.dart';
import 'package:idomussprofissional/components/titulo_cadastro.dart';
import 'package:idomussprofissional/screens/authenticate/cadastro/cadastro_documentos.dart';
import 'package:idomussprofissional/screens/authenticate/cadastro/cadastro_nome.dart';
import 'package:idomussprofissional/screens/authenticate/cadastro/cadastroScaffold.dart';
import 'package:idomussprofissional/models/profissional.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadastroNascimento extends StatefulWidget {
  Profissional profissional;
  CadastroNascimento({this.profissional});

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
              widget.profissional.dataNascimento = dataNascimento;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadastroDocumento(
                      profissional: widget.profissional,
                    ),
                  ));
            }
          : null,
    );
  }
}
