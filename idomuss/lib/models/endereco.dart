import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Endereco {
  @protected
  GeoPoint _location;

  GeoPoint get location => _location;

  set location(GeoPoint value) {
    _location = value;
  }

  @protected
  String _filtro, _numero, _complemento, _rua, _bairro, _cidade, _uf;

  Endereco(this._complemento, this._numero, this._filtro, this._rua,
      this._bairro, this._cidade, this._uf, this._location);

  Endereco.fromJson(Map<String, dynamic> json)
      : _complemento = json['complemento'],
        _numero = json['numero'],
        _filtro = json['filtro'],
        _rua = json['rua'],
        _bairro = json['bairro'],
        _cidade = json['cidade'],
        _uf = json['uf'],
        _location = json['location'];

  get filtro => _filtro;

  set filtro(value) {
    _filtro = value;
  }

  get numero => _numero;

  set numero(value) {
    _numero = value;
  }

  get complemento => _complemento;

  set complemento(value) {
    _complemento = value;
  }

  get rua => _rua;

  set rua(value) {
    _rua = value;
  }

  get bairro => _bairro;

  set bairro(value) {
    _bairro = value;
  }

  get cidade => _cidade;

  set cidade(value) {
    _cidade = value;
  }

  get uf => _uf;

  set uf(value) {
    _uf = value;
  }
}
