import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:idomussprofissional/components/radio_button.dart';
import 'package:idomussprofissional/components/titulo_cadastro.dart';
import 'package:idomussprofissional/helpers/ColorsSys.dart';
import 'package:idomussprofissional/helpers/loadPage.dart';
import 'package:idomussprofissional/models/profissional.dart';
import 'package:idomussprofissional/screens/authenticate/cadastro/cadastroScaffold.dart';
import 'package:idomussprofissional/screens/authenticate/cadastro/cadastro_descricao.dart';
import 'package:idomussprofissional/screens/authenticate/cadastro/cadastro_limite.dart';
import 'package:idomussprofissional/services/database.dart';

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
    return StreamBuilder<List<String>>(
      stream: DatabaseService().ListaServicos,
      builder: (context, snapshot) {

        if(!snapshot.hasData)
          return Scaffold(body: LoadPage(),);

        snapshot.data.sort();
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
                  TextCadastro('Você trabalha com que tipo de serviço?'),
                  
                   DropDownField(
                onValueChanged: (dynamic value) {
                  setState(() {
                    _servico = value;
                  });
                  
                },
                value: _servico,
                required: true,
                hintText: 'Escolha um tipo de serviço',
                labelText: 'Serviços',
                items: snapshot.data,
              ),
                  ///botar uma lista pra escolher
                ],
              ),
            ),
          ],
          _servico.isNotEmpty
              ? () {
                  widget.profissional.nomeServico = _servico;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CadastroLimite(
                          profissional: widget.profissional,
                        ),
                      ));
                }
              : null,
        );
      }
    );
  }
}
