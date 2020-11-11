import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:idomussprofissional/components/servico_item.dart';
import 'package:idomussprofissional/helpers/ColorsSys.dart';
import 'package:idomussprofissional/helpers/constantes.dart';
import 'package:idomussprofissional/helpers/loadPage.dart';
import 'package:idomussprofissional/models/servicoContrado.dart';
import 'package:idomussprofissional/services/database.dart';
import 'package:provider/provider.dart';

import 'infoServico.dart';

class RequisicoesServicos extends StatefulWidget {
  @override
  _RequisicoesServicosState createState() => _RequisicoesServicosState();
}

class _RequisicoesServicosState extends State<RequisicoesServicos> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: StreamBuilder<List<ServicoContratado>>(
              stream: DatabaseService(uid: user.uid)
                  .servicosPendentes(['Solicitando']),
              builder: (context, servicosPendentes) {
                if (!servicosPendentes.hasData) return LoadPage();

                if (servicosPendentes.data.isEmpty)
                  return Padding(
                    padding: const EdgeInsets.all(paddingSmall),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(paddingSmall),
                          child: Image.asset("assets/geral/no_services.png"),
                        ),
                        Text(
                          "Infelizmente, ninguém contatou seus serviços!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: fontSizeRegular),
                        ),
                        Text(
                          "Aguarde até algúem contatá-lo!",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: fontSizeRegular * 0.8),
                        ),
                      ],
                    ),
                  );
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: -1,
                      child: Padding(
                        padding: EdgeInsets.all(paddingSmall),
                        child: Text(
                          "Novos pedidos",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: fontSizeRegular),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: servicosPendentes.data.length,
                          itemBuilder: (ctx, index) {
                            return FutureBuilder<bool>(
                                future: DatabaseService(uid: user.uid)
                                    .temMensagem([
                                  'Solicitando'
                                ], servicosPendentes.data[index].uidCliente),
                                builder: (context, temMensagem) {
                                  if (!temMensagem.hasData)
                                    return Container(
                                      child: null,
                                    );
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return InfoServico(
                                            servicosPendentes.data[index]);
                                      }));
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
                                                  padding: EdgeInsets.all(
                                                      paddingTiny),
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
                          }),
                    ),
                  ],
                );
              }),
        ),
      ],
    );
  }
}
