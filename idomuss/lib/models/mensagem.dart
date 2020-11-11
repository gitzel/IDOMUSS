import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Mensagem {
  @protected
  String _uidMensagem, _uidCliente, _uidProfissional, _mensagem;

  @protected
  DateTime _data;

  @protected
  bool _autorCliente, _visualizado;

  Mensagem(this._uidMensagem, this._uidCliente, this._uidProfissional,
      this._mensagem, this._data, this._autorCliente, this._visualizado);

  Mensagem.fromJson(Map<String, dynamic> json)
      : _uidCliente = json['uidCliente'],
        _uidProfissional = json['uidProfissional'],
        _mensagem = json['mensagem'],
        _data = DateTime.fromMillisecondsSinceEpoch(
            json['data'].millisecondsSinceEpoch),
        _autorCliente = json['autorCliente'],
        _visualizado = json['visualizado'];

  get uidMensagem => _uidMensagem;

  get uidProfissional => _uidProfissional;

  get mensagem => _mensagem;

  get data => _data;

  get uidCliente => _uidCliente;

  get autorCliente => _autorCliente;

  get visualizado => _visualizado;

  set autorCliente(value) {
    _autorCliente = value;
  }

  set uidMensagem(value) {
    _uidMensagem = value;
  }

  set uidCliente(value) {
    _uidCliente = value;
  }

  set uidProfissional(value) {
    _uidProfissional = value;
  }

  set mensagem(value) {
    _mensagem = value;
  }

  set data(value) {
    if (value.runtimeType == DateTime)
      _data = value;
    else if (value.runtimeType == Timestamp)
      _data = DateTime.fromMillisecondsSinceEpoch(value.millisecondsSinceEpoch);
  }

  set visualizado(value) {
    _visualizado = value;
  }
}
