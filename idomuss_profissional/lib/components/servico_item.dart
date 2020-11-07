import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:idomussprofissional/helpers/ColorsSys.dart';
import 'package:idomussprofissional/helpers/constantes.dart';
import 'package:idomussprofissional/helpers/loadPage.dart';
import 'package:idomussprofissional/models/cliente.dart';
import 'package:idomussprofissional/models/servicoContrado.dart';
import 'package:idomussprofissional/services/database.dart';

class ServicoItem extends StatefulWidget {
  ServicoContratado servico;
  double width, height;
  ServicoItem(this.servico, {this.width = null, this.height = null});

  @override
  _State createState() => _State();
}

class _State extends State<ServicoItem> with TickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Cliente>(
        stream: DatabaseService().getCliente(widget.servico.uidCliente),
        builder: (context, cliente) {
          if (!cliente.hasData)
            return Container(
              decoration: BoxDecoration(
                  color: ColorSys.gray,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: shadow),
              child: LoadPage(),
            );

          return FutureBuilder<List<Placemark>>(
              future: placemarkFromCoordinates(
                  widget.servico.localizacao.latitude,
                  widget.servico.localizacao.longitude),
              builder: (context, localizacao) {
                if (!localizacao.hasData)
                  return Container(
                    decoration: BoxDecoration(
                        color: ColorSys.gray,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: shadow),
                    child: LoadPage(),
                  );
                return Container(
                  width: widget.width == null
                      ? MediaQuery.of(context).size.width
                      : widget.width,
                  decoration: BoxDecoration(
                      color: ColorSys.gray,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: shadow),
                  padding: EdgeInsets.all(paddingSmall),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: -1,
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: shadow,
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(cliente.data.foto),
                            backgroundColor: Colors.white,
                            radius: MediaQuery.of(context).size.width * 0.1,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: paddingSmall),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cliente.data.nome,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: ColorSys.black),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: ColorSys.primary,
                                          size: fontSizeSmall,
                                        ),
                                        Flexible(
                                          child: Text(
                                            localizacao.data.first.street +
                                                "\nNº ${widget.servico.numero}, ${widget.servico.complemento}",
                                            style: TextStyle(
                                                fontSize: fontSizeSmall / 1.5,
                                                color: ColorSys.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  "Forneça um orçamento",
                                  style: TextStyle(
                                      fontSize: fontSizeSmall,
                                      fontWeight: FontWeight.bold,
                                      color: ColorSys.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.monetization_on,
                        color: ColorSys.primary,
                      )
                    ],
                  ),
                );
              });
        });
  }
}
