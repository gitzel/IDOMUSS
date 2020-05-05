import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Cliente
{
  @protected
  String _rg, _cpf, _nome, _email, _numeroCelular, _dataNascimento, _genero, _descricao, _foto;

  @protected
  int _querGenero;

  Cliente(this._rg,
      this._cpf,
      this._nome,
      this._email,
      this._numeroCelular,
      this._dataNascimento,
      this._genero,
      this._querGenero,
      this._descricao,
      this._foto);

  Cliente.fromJson(Map<String, dynamic> json)
      : _rg = json['rg'],
        _cpf = json['cpf'],
        _nome = json['nome'],
        _email = json['email'],
        _numeroCelular = json['numeroCelular'],
        _dataNascimento = json['dataNascimento'],
        _genero = json['genero'],
        _querGenero = int.parse(json['querGenero']),
        _descricao = json['descricao'],
        _foto = json['foto'];

  Map toMap()
  {
    return {
      "rg"              : this._rg,
      "cpf"             : this._cpf,
      "nome"            : this._nome,
      "email"           : this._email,
      "numeroCelular"   : this._numeroCelular,
      "dataNascimento"  : this._dataNascimento,
      "genero"          : this._genero,
      "querGenero"      : this._querGenero.toString(),
      "descricao"       : this._descricao,
      "foto"            : this._foto,
    };
  }

  get rg => _rg;

  get cpf => _cpf;

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

  get genero => _genero;

  set genero(value) {
    _genero = value;
  }

  get querGenero => _querGenero;

  set querGenero(int value) {
    _querGenero = value;
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

