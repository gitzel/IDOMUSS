import 'package:flutter/cupertino.dart';

class Avaliacao
{
  @protected
  String  _uidProfissional, _texto;

  @protected
  double _nota;

  Avaliacao(this._uidProfissional,
      this._texto,
      this._nota);

  get texto => _texto;

  set texto(value) {
    _texto = value;
  }

  double get nota => _nota;

  set nota(double value) {
    _nota = value;
  }

  String get uidProfissional => _uidProfissional;

  set uidProfissional(String value) {
    _uidProfissional = value;
  }
}

