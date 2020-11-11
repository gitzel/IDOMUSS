import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:idomuss/components/head_servico.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';
import 'package:idomuss/models/profissional.dart';
import 'package:idomuss/models/servicoContratado.dart';
import 'package:idomuss/screens/home/busca.dart';
import 'package:idomuss/services/database.dart';

import 'chat.dart';

class InfoServicoOrcamento extends StatefulWidget {
  ServicoContratado servicoContratado;
  InfoServicoOrcamento(this.servicoContratado);
  @override
  _InfoServicoOrcamentoState createState() => _InfoServicoOrcamentoState();
}

class _InfoServicoOrcamentoState extends State<InfoServicoOrcamento> {
  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DatabaseService().visualizarServico(widget.servicoContratado.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: StreamBuilder<Profissional>(
            stream: DatabaseService()
                .getProfissional(widget.servicoContratado.uidProfissional),
            builder: (context, profissional) {
              if (!profissional.hasData) return LoadPage();

              return FutureBuilder<List<Placemark>>(
                  future: placemarkFromCoordinates(
                      widget.servicoContratado.localizacao.latitude,
                      widget.servicoContratado.localizacao.longitude),
                  builder: (context, location) {
                    if (!location.hasData) return LoadPage();

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HeadServico(
                              profissional.data.nome,
                              profissional.data.foto,
                              formatDate(widget.servicoContratado.data),
                              location.data.first.subLocality),
                          Padding(
                            padding: EdgeInsets.all(paddingSmall),
                            child: Container(
                              padding: EdgeInsets.all(paddingSmall),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: shadow,
                                  color: Colors.white),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: -1,
                                      child: Icon(
                                        Icons.location_on,
                                        color: ColorSys.primary,
                                      )),
                                  Expanded(
                                    child: AutoSizeText(
                                        "${location.data.first.street}"),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(paddingSmall),
                            child: Container(
                              padding: EdgeInsets.all(paddingSmall),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: shadow,
                                  color: Colors.white),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: -1,
                                      child: Icon(
                                        Icons.home,
                                        color: ColorSys.primary,
                                      )),
                                  Expanded(
                                    child: AutoSizeText(
                                        "${widget.servicoContratado.numero}" +
                                            (widget.servicoContratado
                                                        .complemento ==
                                                    null
                                                ? ""
                                                : ", ${widget.servicoContratado.complemento}")),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(paddingSmall),
                            child: Text(
                              "${profissional.data.nome.split(' ')[0]} trouxe um orçamento para você!",
                              style: TextStyle(
                                  color: ColorSys.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSizeRegular),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(paddingSmall),
                            child: Container(
                              child: RaisedButton(
                                padding: EdgeInsets.all(paddingSmall),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: -1,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: paddingTiny),
                                          child: Icon(Icons.monetization_on),
                                        )),
                                    Expanded(
                                      child: AutoSizeText(
                                        "Avalie e aprove ou não o orçamento",
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(paddingSmall),
                            child: Text(
                              "Precisa de mais informações?",
                              style: TextStyle(
                                  color: ColorSys.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSizeRegular),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                paddingSmall, 0, paddingSmall, paddingSmall),
                            child: Container(
                              width: double.infinity,
                              child: RaisedButton(
                                color: Colors.white,
                                padding: EdgeInsets.all(paddingSmall),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: -1,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: paddingTiny),
                                          child: Icon(
                                            Icons.message,
                                            color: ColorSys.primary,
                                          ),
                                        )),
                                    Expanded(
                                      child: AutoSizeText(
                                        "Entre em contato com ${profissional.data.nome.split(' ')[0]}",
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return Chat(profissional.data);
                                  }));
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  });
            }));
  }
}
