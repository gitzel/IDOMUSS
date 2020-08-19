import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class Profissional {
  @protected
  double _nota;

  @protected
  bool _vip;

  @protected
  GeoPoint _location;

  File fotoFile;

  @protected
  String _uid,
      _rg,
      _cpf,
      _cnpj,
      _nome,
      senha,
      _email,
      _numeroCelular,
      _dataNascimento,
      _genero,
      _descricao,
      _foto,
      _nomeServico;

  String get uid => _uid;

  @protected
  int _querGenero, _curtidas;

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
      this._descricao,
      {this.senha,
      this.fotoFile});

  Profissional.fromJson(Map<String, dynamic> json)
      : _uid = json['uid'],
        _rg = json['rg'],
        _cpf = json['cpf'],
        _cnpj = json['cnpj'],
        _curtidas = json['curtidas'],
        _location = json['location'],
        _dataNascimento = json['dataNascimento'],
        _foto = json['foto'],
        _nome = json['nome'],
        _numeroCelular = json['numero'],
        _genero = json['genero'],
        _querGenero = int.parse(json['querGenero']),
        _descricao = json['descricao'],
        _vip = json['vip'],
        _nota = json['nota'],
        _nomeServico = json['servico'];

  Profissional.empty() {
    this._cpf = '';
    this._curtidas = 0;
    this._nome = '';
    this._cnpj = '';
    this._numeroCelular = '';
    this._dataNascimento = '';
    this._genero = '';
    this._querGenero = 0;
    this._descricao = '';
    this._email = '';
    this._foto = '';
    this._nomeServico = '';
    this._vip = false;
    this._nota = 0;
  }

  String get rg => _rg;

  set rg(String value) {
    _rg = value;
  }

  get cpf => _cpf;

  set cpf(String value) {
    _cpf = value;
  }

  get cnpj => _cnpj;

  set cnpj(String value) {
    _cnpj = value;
  }

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

  set dataNascimento(value) {
    _dataNascimento = value;
  }

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

  double get nota => _nota;

  set nota(double value) {
    _nota = value;
  }

  set uid(String value) {
    _uid = value;
  }

  get foto => _foto;

  set foto(value) {
    _foto = value;
  }

  get curtidas => _curtidas;

  set curtidas(value) {
    _curtidas = value;
  }
}
