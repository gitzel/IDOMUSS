import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:idomussprofissional/components/servico_item.dart';
import 'package:idomussprofissional/helpers/ColorsSys.dart';
import 'package:idomussprofissional/helpers/constantes.dart';
import 'package:idomussprofissional/models/servicoContrado.dart';
import 'package:idomussprofissional/screens/home/infoServicoAguardo.dart';
import 'package:idomussprofissional/services/database.dart';
import 'package:provider/provider.dart';

import 'infoServico.dart';

class ListaServicosContratados extends StatefulWidget {
  List<ServicoContratado> list;

  ListaServicosContratados(this.list);

  @override
  _ListaServicosContratadosState createState() =>
      _ListaServicosContratadosState();
}

class _ListaServicosContratadosState extends State<ListaServicosContratados> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Container(
        decoration: background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: -1,
              child: Padding(
                padding: const EdgeInsets.all(paddingSmall),
                child: Text(
                  "Serviços em ${widget.list.first.data.day}/${widget.list.first.data.month}/${widget.list.first.data.year}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: fontSizeRegular),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: widget.list.length,
                  itemBuilder: (ctx, index) {
                    return FutureBuilder<bool>(
                        future: DatabaseService(uid: user.uid).temMensagem(
                            ['Pendente'], widget.list[index].uidCliente),
                        builder: (context, temMensagem) {
                          if (!temMensagem.hasData)
                            return Container(
                              child: null,
                            );
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return AguardarClienteInfo(widget.list[index]);
                              }));
                            },
                            child: Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(paddingSmall),
                                  child: ServicoItem(
                                    widget.list[index],
                                    width: MediaQuery.of(context).size.width -
                                        paddingSmall * 2,
                                  ),
                                ),
                                !temMensagem.data
                                    ? SizedBox.shrink()
                                    : Positioned(
                                        left: paddingSmall / 2,
                                        top: 0,
                                        child: Container(
                                          padding: EdgeInsets.all(paddingTiny),
                                          decoration: BoxDecoration(
                                              color: ColorSys.primary,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Text(
                                            temMensagem.data
                                                ? "Novas mensagens"
                                                : "",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )
                              ],
                            ),
                          );
                        });
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
