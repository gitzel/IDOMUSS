import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idomuss/components/textFieldOutline.dart';
import 'package:idomuss/components/titulo_cadastro.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/screens/authenticate/cadastro/cadastro_descricao.dart';
import 'package:idomuss/screens/authenticate/cadastro/cadastro_genero.dart';
import 'package:idomuss/screens/authenticate/cadastro/cadastroScaffold.dart';
import 'package:idomuss/models/cliente.dart';

class CadastroSenha extends StatefulWidget {
  Cliente cliente;
  CadastroSenha({this.cliente});

  @override
  _CadastroSenhaState createState() => _CadastroSenhaState();
}

class _CadastroSenhaState extends State<CadastroSenha> {
  String senha, comparaSenha;
  bool escondeSenha, escondeConfirma;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    senha = comparaSenha = "";
    escondeSenha = escondeConfirma = true;
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
              TextCadastro('Qual é a sua senha?'),
              TextFieldOutline(
                prefixIcon: Icons.lock,
                label: 'Senha',
                obscureText: escondeSenha,
                keyboardType: TextInputType.visiblePassword,
                validator: (val) => val.length > 7 ? null : "Senha fraca!",
                onChanged: (val) {
                  setState(() {
                    if (_formKey.currentState.validate() || val.isNotEmpty) {
                      senha = val;
                    }
                  });
                },
                suffixIcon: IconButton(
                    icon: escondeSenha
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        escondeSenha = !escondeSenha;
                      });
                    }),
              ),
              TextCadastro('Confirme a senha novamente!'),
              TextFieldOutline(
                prefixIcon: Icons.lock,
                label: 'Confirmar senha',
                obscureText: escondeConfirma,
                keyboardType: TextInputType.visiblePassword,
                validator: (val) =>
                    senha != val ? null : "As senhas são incompatíveis!",
                onChanged: (val) {
                  setState(() {
                    if (_formKey.currentState.validate()) {
                      comparaSenha = val;
                    }
                  });
                },
                suffixIcon: IconButton(
                    icon: escondeConfirma
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        escondeConfirma = !escondeConfirma;
                      });
                    }),
              ),
            ],
          ),
        ),
      ],
      senha.isNotEmpty && comparaSenha.isNotEmpty
          ? () {
              widget.cliente.senha = senha;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadastroDescricao(
                      cliente: widget.cliente,
                    ),
                  ));
            }
          : null,
    );
  }
}
