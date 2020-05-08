import 'package:flutter/cupertino.dart';

class Profissional
{
    @protected
    String _rg, _cpf, _cnpj, _nome, _email, _cep, _numeroCelular, _dataNascimento, _genero, _descricao, _nomeServico;

    @protected
    int _querGenero, _idServico;

    Profissional(this._rg,
        this._cpf,
        this._cnpj,
        this._nome,
        this._cep,
        this._numeroCelular,
        this._dataNascimento,
        this._genero,
        this._querGenero,
        this._descricao);

    Profissional.fromJson(Map<String, dynamic> json)
        : _rg = json['rg'],
          _cpf = json['cpf'],
          _cnpj = json['cnpj'],
          _nome = json['nome'],
          _cep = json['cep'],
          _numeroCelular = json['numeroCelular'],
          _dataNascimento = json['dataNascimento'],
          _genero = json['genero'],
          _querGenero = int.parse(json['querGenero']),
          _descricao = json['descricao'],
          _idServico = int.parse(json['idServico']);

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

    get cep => _cep;

    set cep(value) {
      _cep = value;
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

    get idServico => _idServico;

    set idServico(value) {
      _idServico = value;
    }
}

