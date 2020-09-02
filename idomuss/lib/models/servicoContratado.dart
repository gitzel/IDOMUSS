import 'package:flutter/cupertino.dart';
import 'package:idomuss/models/cliente.dart';
import 'package:idomuss/models/profissional.dart';

class ServicoContratado {
  @protected
  Profissional _profissional;

  @protected
  String _uidServicoContratado,
      _descricao,
      _situacao,
      _uidProfissional,
      _uidCliente,
      _servico;

  DateTime _data;

  String get uidServicoContratado => _uidServicoContratado;

  set uidServicoContratado(String value) {
    _uidServicoContratado = value;
  }

  get situacao => _situacao;

  set situacao(value) {
    _situacao = value;
  }

  @protected
  double _preco;

  ServicoContratado(this._descricao, this._preco, this._data, this._situacao,
      this._uidProfissional, this._uidCliente, this._servico);

  ServicoContratado.fromJson(Map<String, dynamic> json)
      : _servico = json['servico'],
        _uidCliente = json['uidCliente'],
        _uidProfissional = json['uidProfissional'],
        _data = json['data'],
        _preco = double.parse(json['preco']),
        _descricao = json['descricao'],
        _situacao = json['situacao'];

  get descricao => _descricao;

  set descricao(value) {
    _descricao = value;
  }

  get data => _data;

  set data(value) {
    _data = value;
  }

  get uidProfissional => _uidProfissional;

  set uidProfissional(value) {
    _uidProfissional = value;
  }

  get uidCliente => _uidCliente;

  set uidCliente(value) {
    _uidCliente = value;
  }

  get servico => _servico;

  set servico(value) {
    _servico = value;
  }

  double get preco => _preco;

  set preco(double value) {
    _preco = value;
  }

  Profissional get profissional => _profissional;

  set profissional(Profissional value) {
    _profissional = value;
  }
}
