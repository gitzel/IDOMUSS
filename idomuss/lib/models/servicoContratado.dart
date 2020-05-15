import 'package:flutter/cupertino.dart';

class ServicoContratado
{
  @protected
  String  _uidServicoContratado, _descricao, _situacao, _data, _uidProfissional,_uidCliente, _uidServico;

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

  ServicoContratado(this._descricao,
      this._preco,
      this._data,
      this._situacao,
      this._uidProfissional,
      this._uidCliente,
      this._uidServico);

  ServicoContratado.fromJson(Map<String, dynamic> json)
      : _uidServico = json['uidServico'],
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

  get uidServico => _uidServico;

  set uidServico(value) {
    _uidServico = value;
  }

  double get preco => _preco;

  set preco(double value) {
    _preco = value;
  }
}

