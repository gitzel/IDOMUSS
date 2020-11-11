import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:idomuss/components/head_servico.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';
import 'package:idomuss/models/profissional.dart';
import 'package:idomuss/models/servicoContratado.dart';
import 'package:idomuss/services/database.dart';

import 'busca.dart';
import 'chat.dart';

class InfoServicoAguarde extends StatefulWidget {
  ServicoContratado servicoContratado;
  InfoServicoAguarde(this.servicoContratado);

  @override
  _InfoServicoAguardeState createState() => _InfoServicoAguardeState();
}

class _InfoServicoAguardeState extends State<InfoServicoAguarde> {
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
                                        Icons.info,
                                        color: ColorSys.primary,
                                      )),
                                  Expanded(
                                    child: AutoSizeText(
                                        "${widget.servicoContratado.descricao}"),
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
                                  color: ColorSys.primary),
                              child: Container(
                                width: double.infinity,
                                child: AutoSizeText(
                                  "${profissional.data.nome.split(' ')[0]} ainda não retornou com seu orçamento",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(paddingSmall),
                            child: Text(
                              "Deseja falar com ${profissional.data.nome.split(' ')[0]}?",
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
