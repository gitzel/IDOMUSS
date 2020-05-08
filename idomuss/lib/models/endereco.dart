import 'package:flutter/cupertino.dart';

class Endereco{
  @protected
  String _filtro, _numero, _complemento, _cep;

  Endereco(this._complemento,
           this._numero,
           this._cep,
           this._filtro);

  Endereco.fromJson(Map<String, dynamic> json)
      : _complemento = json['complemento'],
        _numero = json['numero'],
        _cep = json['cep'],
        _filtro = json['filtro'];

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

  get cep => _cep;

  set cep(value) {
    _cep = value;
  }
}
