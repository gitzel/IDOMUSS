import 'package:firebase_admin/firebase_admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:idomuss/helpers/constantes.dart';
import 'package:idomuss/models/endereco.dart';
import 'package:idomuss/screens/configuracoes/listaEnderecos.dart';
import 'package:idomuss/services/database.dart';
import 'package:provider/provider.dart';

class MenuEnderecos extends StatefulWidget {
  @override
  _MenuEnderecosState createState() => _MenuEnderecosState();
}

class _MenuEnderecosState extends State<MenuEnderecos> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: StreamBuilder<List<Endereco>>(
          stream: DatabaseService(uid: user.uid).enderecosFromCliente,
          builder: (context, snapshot) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(paddingSmall),
                      child: Text(
                        "Endereços salvos",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )),
                  ListaEnderecos(snapshot.data, user.uid)
                ],
              ),
            );
          }),
    );
  }
}
