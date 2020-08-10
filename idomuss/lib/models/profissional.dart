import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profissional {
  @protected
  double _nota;

  double get nota => _nota;

  set nota(double value) {
    _nota = value;
  }

  @protected
  bool _vip;

  @protected
  GeoPoint _location;

  @protected
  String _uid,
      _rg,
      _cpf,
      _cnpj,
      _nome,
      _email,
      _numeroCelular,
      _dataNascimento,
      _genero,
      _descricao,
      _foto,
      _nomeServico;

  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }

  get foto => _foto;

  set foto(value) {
    _foto = value;
  }

  @protected
  int _querGenero;

  Profissional(
      this._rg,
      this._cpf,
      this._cnpj,
      this._nome,
      this._location,
      this._numeroCelular,
      this._dataNascimento,
      this._genero,
      this._querGenero,
      this._descricao);

  Profissional.fromJson(Map<String, dynamic> json)
      : _rg = json['rg'],
        _cpf = json['cpf'],
        _cnpj = json['cnpj'],
        _location = json['location'],
        _dataNascimento = json['dataNascimento'],
        _genero = json['genero'],
        _querGenero = int.parse(json['querGenero']),
        _descricao = json['descricao'],
        _vip = json['vip'],
        _nome = json['nota'],
        _nomeServico = json['servico'];

  String get rg => _rg;

  set rg(String value) {
    _rg = value;
  }

  get cpf => _cpf;

  get cnpj => _cnpj;

  get nome => _nome;

  set nome(value) {
    _nome = value;
  }

  get email => _email;

  set email(value) {
    _email = value;
  }

  GeoPoint get location => _location;

  set location(GeoPoint value) {
    _location = value;
  }

  get numeroCelular => _numeroCelular;

  set numeroCelular(value) {
    _numeroCelular = value;
  }

  get dataNascimento => _dataNascimento;

  get genero => _genero;

  set genero(value) {
    _genero = value;
  }

  get descricao => _descricao;

  set descricao(value) {
    _descricao = value;
  }

  get nomeServico => _nomeServico;

  set nomeServico(value) {
    _nomeServico = value;
  }

  get querGenero => _querGenero;

  set querGenero(int value) {
    _querGenero = value;
  }

  bool get vip => _vip;

  set vip(bool value) {
    _vip = value;
  }
}
