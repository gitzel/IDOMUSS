import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:idomussprofissional/helpers/ColorsSys.dart';
import 'package:idomussprofissional/helpers/constantes.dart';
import 'package:idomussprofissional/helpers/loadPage.dart';
import 'package:idomussprofissional/models/cliente.dart';
import 'package:idomussprofissional/models/servicoContrado.dart';
import 'package:idomussprofissional/services/database.dart';

class InfoServico extends StatefulWidget {
  ServicoContratado servicoContratado;
  InfoServico(this.servicoContratado);
  @override
  _InfoServicoState createState() => _InfoServicoState();
}

class _InfoServicoState extends State<InfoServico> {

  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: StreamBuilder<Cliente>(
        stream: DatabaseService().getCliente(widget.servicoContratado.uidCliente),
        builder: (context, cliente) {
          if(!cliente.hasData)
            return LoadPage();

         return FutureBuilder<List<Placemark>>(
              future: placemarkFromCoordinates(
                  widget.servicoContratado.localizacao.latitude,
                  widget.servicoContratado.localizacao.longitude),
            builder: (context, location) {

               if(!location.hasData)
                  return LoadPage(); 

              return SingleChildScrollView(
                              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(paddingSmall),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: ColorSys.primary,
                        boxShadow: shadow,
                       
                      ),
                      child: Row(
                        children: [
                           Container(
                                decoration: BoxDecoration(
                                  boxShadow: shadow,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white,
                                    width: 2,
                                  )
                                ),
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(cliente.data.foto),
                                  backgroundColor: Colors.white,
                                  minRadius: MediaQuery.of(context).size.width * 0.1,
                                  maxRadius: MediaQuery.of(context).size.width * 0.15,
                                ),
                              ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: paddingSmall),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                    AutoSizeText(
                                             cliente.data.nome.split(" ")[0],
                                             maxLines: 1,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: fontSizeRegular * 1.5
                                      ),),  
                                   Padding(
                                     padding: const EdgeInsets.symmetric(vertical:8.0),
                                     child: Container(
                                        padding: EdgeInsets.all(paddingTiny),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: shadow,
                                          borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: Row(
                                          
                                          children: [
                                            Icon(Icons.location_city, color: ColorSys.primary,),
                                            Expanded(
                                                                                          child: AutoSizeText(location.data.first.subLocality,
                                                          maxLines: 2,
                                                          textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                         color: ColorSys.black,
                                                      ),
                                                          ),
                                            ),
                                          ],
                                        ),
                                      ),
                                   ),
                                    Container(
                                      padding: EdgeInsets.all(paddingTiny),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: shadow,
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.calendar_today, color: ColorSys.primary,),
                                          Expanded(
                                                                                      child: AutoSizeText(formatDate(widget.servicoContratado.data),
                                                        maxLines: 1,
                                                    style: TextStyle(
                                                      color: ColorSys.black,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                        ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(paddingSmall),
                      child: Container(
                        padding: EdgeInsets.all(paddingSmall),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: shadow,
                          color: Colors.white
                        ),
                        child: Row(
                          children: [
                            Expanded(flex: -1, child: Icon(Icons.location_on, color: ColorSys.primary,)),
                            Expanded(
                                                        child: AutoSizeText(
                                "${location.data.first.street}"
                              ),
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
                          color: Colors.white
                        ),
                        child: Row(
                          children: [
                            Expanded(flex: -1, child: Icon(Icons.home, color: ColorSys.primary,)),
                            Expanded(
                                                        child: AutoSizeText(
                                "${widget.servicoContratado.numero}" + (widget.servicoContratado.complemento == null ? "" : ", ${widget.servicoContratado.complemento}")
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                       padding: const EdgeInsets.all(paddingSmall),
                      child: Text("Forneça um orçamento para este serviço!",
                        style: TextStyle(
                          color: ColorSys.black,
                          fontWeight: FontWeight.bold,
                          fontSize: fontSizeRegular
                        ),
                      ),
                    ),
                    Padding(
                       padding: const EdgeInsets.all(paddingSmall),
                       child: Container(
                         child: RaisedButton(
                          padding: EdgeInsets.all(paddingSmall),
                          child: Row(
                            children: [
                              Expanded(flex: -1, child: Padding(
                                padding: EdgeInsets.only(right: paddingTiny),
                                child: Icon(Icons.monetization_on),
                              )),
                              Expanded(
                                                            child: AutoSizeText("Avalie e forneça o orçamento",
                                maxLines: 1, 
                                ),
                              ),
                            ],
                          ),
                          onPressed: (){
                            
                          },
                        ),
                       ),
                    ),
                    Padding(
                       padding: const EdgeInsets.all(paddingSmall),
                      child: Text("Precisa de mais informações?",
                        style: TextStyle(
                          color: ColorSys.black,
                          fontWeight: FontWeight.bold,
                          fontSize: fontSizeRegular
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(paddingSmall, 0, paddingSmall, paddingSmall),
                      child: Container(
                        width: double.infinity,
                        child: RaisedButton(
                          color: Colors.white,
                          padding: EdgeInsets.all(paddingSmall),
                          child: Row(
                            
                            children: [
                              Expanded(flex: -1, child: Padding(
                                padding: EdgeInsets.only(right: paddingTiny),
                                child: Icon(Icons.message, color: ColorSys.primary,),
                              )),
                              Expanded(
                                                            child: AutoSizeText("Entre em contato com ${cliente.data.nome.split(' ')[0]}",
                                maxLines: 1, 
                                ),
                              ),
                            ],
                          ),
                          onPressed: (){
                            
                          },
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
          );
        }
      )
    );
  }
}
