import 'package:flutter/material.dart';
import 'package:idomuss/helpers/ColorsSys.dart';

const background = BoxDecoration(
  image: DecorationImage(
      image: AssetImage('assets/geral/bg.png'), fit: BoxFit.cover),
);

const paddingTiny = 8.0;
const paddingSmall = 16.0;
const paddingMedium = 24.0;
const paddingLarge = 32.0;
const paddingExtraLarge = 48.0;

const fontSizeTitle = 48.0;
const fontSizeSubTitle = 32.0;

const fontSizeRegular = 18.0;
const fontSizeSmall = 14.0;

final BoxDecoration box = BoxDecoration(
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
                          );

final InputDecoration textFilled = InputDecoration(
                        fillColor: ColorSys.lightGray,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              width: 0, 
                              style: BorderStyle.none,
                          ),
                                               
                      ),
                    );