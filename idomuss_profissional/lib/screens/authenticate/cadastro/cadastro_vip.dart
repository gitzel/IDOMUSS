import 'package:flutter/material.dart';
import 'package:idomussprofissional/components/radio_button.dart';
import 'package:idomussprofissional/components/titulo_cadastro.dart';
import 'package:idomussprofissional/helpers/ColorsSys.dart';
import 'package:idomussprofissional/models/profissional.dart';
import 'package:idomussprofissional/screens/authenticate/cadastro/cadastroScaffold.dart';
import 'package:idomussprofissional/screens/authenticate/cadastro/cadastro_foto.dart';

class CadastroVip extends StatefulWidget {
  Profissional profissional;
  CadastroVip({this.profissional});

  @override
  _CadastroVipState createState() => _CadastroVipState();
}

class _CadastroVipState extends State<CadastroVip> {
  final _formKey = GlobalKey<FormState>();
  bool _vip;
  String _vipRadio;
  bool termos;

  @override
  void initState() {
    _vip = null;
    termos = false;
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
              TextCadastro('Você gostaria de ser um profissional VIP??'),
              Text(
                "Sendo VIP você tem acesso a diversas vantagens no app!",
                textAlign: TextAlign.center,
              ),
              Container(
                  width: double.infinity,
                  child: RaisedButton(
                      child: Text("Clique aqui para saber mais!"),
                      onPressed: () {})),
              TextCadastro("E aí? Quer entrar nessa jornada VIP?"),
              RadioButton(
                value: 'Sim! Adoraria!',
                groupValue: _vipRadio,
                onChanged: (String value) {
                  setState(() {
                    _vip = value == 'Sim! Adoraria';
                    _vipRadio = value;
                  });
                },
              ),
              RadioButton(
                value: 'Infelizmente não! :(',
                groupValue: _vipRadio,
                onChanged: (String value) {
                  setState(() {
                    _vip = value == 'Sim! Adoraria';
                    _vipRadio = value;
                  });
                },
              ),
              Row(
                children: [
                  Checkbox(
                    value: termos,
                    onChanged: (bool value) {
                      setState(() {
                        termos = value;
                      });
                    },
                  ),
                  Flexible(
                      child: Text(
                          "Confirmo que aceito os termos de compromisso com IDOMUSS e que tenho total conhecimento sobre!"))
                ],
              ),
            ],
          ),
        ),
      ],
      _vip != null && termos
          ? () {
              widget.profissional.vip = _vip;

              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadastroFoto(
                      profissional: widget.profissional,
                    ),
                  ));
            }
          : null,
    );
  }
}
