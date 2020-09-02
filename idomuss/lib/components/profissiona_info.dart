import 'dart:ffi';

import 'package:flutter/material.dart';

class ProfissionalInfo extends StatelessWidget {

  Widget child;
  double width;
  ProfissionalInfo(this.child, {this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
                          
                          child: child,
                          height: 60,
                          width: this.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                            boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 0.5,
                                        blurRadius: 10,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                          ),
                        );
  }
}