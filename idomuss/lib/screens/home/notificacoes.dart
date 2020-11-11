import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:idomuss/components/servico_item.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';
import 'package:idomuss/models/servicoContratado.dart';
import 'package:idomuss/screens/home/busca.dart';
import 'package:idomuss/screens/home/infoServicoOrcamento.dart';
import 'package:idomuss/screens/home/infoServico.dart';
import 'package:idomuss/services/database.dart';
import 'package:provider/provider.dart';

import 'infoServicoAguarde.dart';

class Notificacoes extends StatefulWidget {
  @override
  _NotificacoesState createState() => _NotificacoesState();
}

class _NotificacoesState extends State<Notificacoes> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);

    return Container(
      decoration: BoxDecoration(color: ColorSys.primary),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 75,
            padding: const EdgeInsets.all(paddingSmall),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                    fontSize: fontSizeSubTitle,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    color: Colors.white),
                children: <TextSpan>[
                  TextSpan(text: 'Serviços'),
                  TextSpan(
                      text: ' pendentes',
                      style: TextStyle(fontWeight: FontWeight.normal)),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                  color: ColorSys.gray,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(75.0)),
                ),
                child: StreamBuilder<List<ServicoContratado>>(
                  stream: DatabaseService(uid: user.uid)
                      .servicosPendentes(['Solicitando', 'Analisando']),
                  builder: (context, servicosPendentes) {
                    if (!servicosPendentes.hasData) return LoadPage();

                    if (servicosPendentes.data.isEmpty)
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                              child:
                                  Image.asset("assets/geral/no_services.png")),
                          Padding(
                            padding: EdgeInsets.fromLTRB(paddingSmall,
                                paddingMedium, paddingSmall, paddingSmall),
                            child: Text(
                              "Selecione para conhecer os melhores trabalhadores perto de você!",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: paddingSmall),
                            child: Text(
                              "Selecione o icone central para conhecer os melhores trabalhadores perto de você!",
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      );

                    return ListView.builder(
                        padding: EdgeInsets.only(top: 37.5),
                        itemCount: servicosPendentes.data.length,
                        itemBuilder: (ctx, index) {
                          return FutureBuilder<bool>(
                              future: DatabaseService(uid: user.uid)
                                  .temMensagem([
                                'Solicitando',
                                'Analisando'
                              ], servicosPendentes.data[index].uidProfissional),
                              builder: (context, temMensagem) {
                                if (!temMensagem.hasData)
                                  return Container(
                                    child: null,
                                  );
                                return GestureDetector(
                                  onTap: () {
                                    switch (servicosPendentes
                                        .data[index].situacao) {
                                      case "Solicitando":
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return InfoServicoAguarde(
                                              servicosPendentes.data[index]);
                                        }));
                                        break;
                                    }
                                  },
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(paddingSmall),
                                        child: ServicoItem(
                                          servicosPendentes.data[index],
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              paddingSmall * 2,
                                        ),
                                      ),
                                      !temMensagem.data &&
                                              servicosPendentes.data[index]
                                                  .visualizadoProfissional
                                          ? SizedBox.shrink()
                                          : Positioned(
                                              left: paddingSmall / 2,
                                              top: 0,
                                              child: Container(
                                                padding:
                                                    EdgeInsets.all(paddingTiny),
                                                decoration: BoxDecoration(
                                                    color: ColorSys.primary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Text(
                                                  temMensagem.data
                                                      ? "Novas mensagens"
                                                      : "Novo",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            )
                                    ],
                                  ),
                                );
                              });
                        });
                  },
                )),
          )
        ],
      ),
    );
  }
}
