import 'package:flutter/material.dart';

class Servico{

  @protected
  String _nome, _img;

  String get nome => _nome;

  String get img => _img;

  set nome(String value) {
    _nome = value;
  }

  set img(String value) {
    _img = value;
  }

  Servico(this._nome, this._img);

  Servico.fromJson(Map<String, dynamic> json)
      : _nome = json['nome'],
        _img = json['image'];

}