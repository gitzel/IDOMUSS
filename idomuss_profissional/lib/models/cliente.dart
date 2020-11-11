import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cliente {
  @protected
  String _uid,
      _rg,
      _cpf,
      _nome,
      _email,
      _numeroCelular,
      _dataNascimento,
      _genero,
      _descricao,
      _foto;

  Cliente.empty() {
    this._cpf = '';
    this._nome = '';
    this._numeroCelular = '';
    this._dataNascimento = '';
    this._genero = '';
    this._descricao = '';
    this._email = '';
    this._foto = '';
  }

  Cliente(
    this._rg,
    this._cpf,
    this._nome,
    this._numeroCelular,
    this._dataNascimento,
    this._genero,
    this._descricao,
  );

  Cliente.fromJson(Map<String, dynamic> json)
      : _rg = json['rg'],
        _email = json['email'],
        _cpf = json['cpf'],
        _dataNascimento = json['dataNascimento'],
        _foto = json['foto'],
        _nome = json['nome'],
        _numeroCelular = json['numero'],
        _genero = json['genero'],
        _descricao = json['descricao'];

  get uid => _uid;

  set uid(String value) {
    _uid = value;
  }

  String get rg => _rg;

  set rg(String value) {
    _rg = value;
  }

  get cpf => _cpf;

  set cpf(value) {
    _cpf = value;
  }

  get nome => _nome;

  set nome(value) {
    _nome = value;
  }

  get email => _email;

  set email(value) {
    _email = value;
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

  get foto => _foto;

  set foto(value) {
    _foto = value;
  }
}
