import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idomussprofissional/components/textFieldOutline.dart';
import 'package:idomussprofissional/components/titulo_cadastro.dart';
import 'package:idomussprofissional/helpers/ColorsSys.dart';
import 'package:idomussprofissional/screens/authenticate/cadastro/cadastro_servico.dart';
import 'package:idomussprofissional/screens/authenticate/cadastro/cadastro_genero.dart';
import 'package:idomussprofissional/screens/authenticate/cadastro/cadastroScaffold.dart';
import 'package:idomussprofissional/models/profissional.dart';

class CadastroSenha extends StatefulWidget {
  Profissional profissional;
  CadastroSenha({this.profissional});

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
                onChanged: (val) {
                  setState(() {
                    comparaSenha = val;
                    _formKey.currentState.validate();
                  });
                },
                validator: (val) {
                  if(comparaSenha.isEmpty)
                    return null;
                  
                  if(comparaSenha.compareTo(senha) != 0)
                    return "As senhas são incompatíveis!";

                  return null;
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
      senha.isNotEmpty && comparaSenha.isNotEmpty && senha.compareTo(comparaSenha) == 0
          ? () {
              widget.profissional.senha = senha;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadastroServico(
                      profissional: widget.profissional,
                    ),
                  ));
            }
          : null,
    );
  }
}
