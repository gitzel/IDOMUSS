import 'package:flutter/cupertino.dart';

class Avaliacao {
  @protected
  String _texto, _nomeCliente, _fotoCliente, _uidCliente, _uidProfissional;

  @protected
  double _nota;

  Avaliacao(this._texto, this._uidProfissional, this._nota);

  Avaliacao.fromJson(Map<String, dynamic> json)
      : _texto = json['texto'],
        _uidCliente = json['uidCliente'],
        _uidProfissional = json['uidProfissional'],
        _nota = json['nota'];

  String get texto => _texto;

  set texto(String value) {
    _texto = value;
  }

  get nomeCliente => _nomeCliente;

  set nomeCliente(value) {
    _nomeCliente = value;
  }

  get fotoCliente => _fotoCliente;

  set fotoCliente(value) {
    _fotoCliente = value;
  }

  get uidCliente => _uidCliente;

  set uidCliente(value) {
    _uidCliente = value;
  }

  get uidProfissional => _uidProfissional;

  set uidProfissional(value) {
    _uidProfissional = value;
  }

  double get nota => _nota;

  set nota(double value) {
    _nota = value;
  }
}
