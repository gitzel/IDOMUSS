import 'package:flutter/material.dart';
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
  bool _vip = false;

  @override
  void initState() {
    _vip = false;
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
              TextCadastro('sla vip??'),
              //saber se é vip
            ],
          ),
        ),
      ],
      _vip != null
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
