import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:idomussprofissional/helpers/ColorsSys.dart';
import 'package:idomussprofissional/helpers/constantes.dart';

class HeadServico extends StatelessWidget {

  String foto, data, bairro, nome;

  HeadServico(this.nome, this.foto, this.data, this.bairro);

  @override
  Widget build(BuildContext context) {
    return Container(
                              padding: EdgeInsets.fromLTRB(
                                  paddingSmall, 0, paddingSmall, paddingSmall),
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
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        )),
                                    child: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(foto),
                                      backgroundColor: Colors.white,
                                      minRadius:
                                          MediaQuery.of(context).size.width * 0.1,
                                      maxRadius:
                                          MediaQuery.of(context).size.width *
                                              0.15,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: paddingSmall),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          AutoSizeText(
                                            nome.split(" ")[0],
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: fontSizeRegular * 1.5),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Container(
                                              padding:
                                                  EdgeInsets.all(paddingTiny),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  boxShadow: shadow,
                                                  borderRadius:
                                                      BorderRadius.circular(10)),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.location_city,
                                                    color: ColorSys.primary,
                                                  ),
                                                  Expanded(
                                                    child: AutoSizeText(
                                                      bairro,
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
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.calendar_today,
                                                  color: ColorSys.primary,
                                                ),
                                                Expanded(
                                                  child: AutoSizeText(
                                                    data,
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
                            );
  }
}