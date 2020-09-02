import 'package:flutter/cupertino.dart';

class Avaliacao {
  @protected
  String _uidProfissional, _texto, _uidCliente, _data;

  @protected
  double _nota;

  Avaliacao(this._uidCliente, this._uidProfissional, this._texto, this._nota, this._data);

  get texto => _texto;

  set texto(value) {
    _texto = value;
  }

  double get nota => _nota;

  set nota(double value) {
    _nota = value;
  }

  String get uidCliente => _uidCliente;

  set uidCliente(String value) {
    _uidCliente = value;
  }

  String get uidProfissional => _uidProfissional;

  set uidProfissional(String value) {
    _uidProfissional = value;
  }

  String get data => _data;

  set data(String value) {
    _data = value;
  }

  Avaliacao.fromJson(Map<String, dynamic> json)
      : _uidProfissional = json['uidProfissional'],
        _nota = double.parse(json['nota'].toString()),
        _uidCliente = json['uidCliente'],
        _data = json['data'],
        _texto = json['texto'];
}
