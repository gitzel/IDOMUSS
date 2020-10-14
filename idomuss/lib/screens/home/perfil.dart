import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:idomuss/components/botao_perfil.dart';
import 'package:idomuss/components/profissional_item.dart';
import 'package:idomuss/components/radial_progress.dart';
import 'package:idomuss/components/rounded_image.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';
import 'package:idomuss/models/cliente.dart';
import 'package:idomuss/screens/configuracoes/configuracoes.dart';
import 'package:idomuss/screens/configuracoes/menuEnderecos.dart';
import 'package:idomuss/screens/home/busca.dart';
import 'package:idomuss/services/auth.dart';
import 'package:idomuss/services/database.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart' as math;

class Perfil extends StatefulWidget {
  String uid;

  Perfil(this.uid);

  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final cliente = Provider.of<Cliente>(context) ?? Cliente.empty();
    return FutureBuilder<dynamic>(
        future: DatabaseService(uid: widget.uid).getFoto(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                Expanded(
                    flex: 2,
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                snapshot.data,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          color: ColorSys.primary.withOpacity(0.6),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: RadialProgress(
                                width: 4,
                                goalCompleted: 0.9,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(snapshot.data),
                                  radius: screen.width * 0.15,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(paddingSmall),
                                  child: Text(
                                    cliente.nome,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {},
                                )
                              ],
                            ),
                            Text(
                              cliente.dataNascimento,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    )),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(paddingMedium),
                          child: Text(
                            cliente.descricao,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(paddingMedium),
                          child: Container(
                              width: double.infinity,
                              child: ButtonProfile(
                                  "Cartões", Icons.credit_card, () {})),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(paddingMedium),
                          child: Container(
                              width: double.infinity,
                              child: ButtonProfile(
                                  "Endereços", Icons.edit_location, () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MenuEnderecos(),
                                    ));
                              })),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(paddingMedium),
                          child: Container(
                              width: double.infinity,
                              child: ButtonProfile(
                                  "Configurações", Icons.settings, () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Configuracoes()));
                              })),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          }
          return LoadPage();
        });
  }
}
