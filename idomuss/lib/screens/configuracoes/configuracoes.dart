import 'package:flutter/material.dart';
import 'package:idomuss/components/botao_perfil.dart';
import 'package:idomuss/helpers/constantes.dart';

class Configuracoes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(paddingMedium),
            child: Container(
                width: double.infinity,
                child: ButtonProfile("Alterar email", Icons.mail, () {})),
          ),
          Padding(
            padding: const EdgeInsets.all(paddingMedium),
            child: Container(
                width: double.infinity,
                child: ButtonProfile("Alterar nome", Icons.person, () {})),
          ),
          Padding(
            padding: const EdgeInsets.all(paddingMedium),
            child: Container(
                width: double.infinity,
                child: ButtonProfile("Alterar nome", Icons.person, () {})),
          ),
        ],
      ),
    );
  }
}
