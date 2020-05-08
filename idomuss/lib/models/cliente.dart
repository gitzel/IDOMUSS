import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Cliente
{
    @protected
    String uid, _rg, _cpf, email, _nome,_numeroCelular, _dataNascimento, _genero, _descricao;

    @protected
    int _querGenero;

    Cliente(this._rg,
        this._cpf,
        this._nome,
        this._numeroCelular,
        this._dataNascimento,
        this._genero,
        this._querGenero,
        this._descricao,
        {this.uid, this.email});


    Cliente.fromJson(Map<String, dynamic> json)
        : _rg = json['rg'],
          _cpf = json['cpf'],
          _nome = json['nome'],
          _numeroCelular = json['numeroCelular'],
          _dataNascimento = json['dataNascimento'],
          _genero = json['genero'],
          _querGenero = int.parse(json['querGenero']),
          _descricao = json['descricao'];

    get rg => _rg;

    set rg(value) {
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

    int get querGenero => _querGenero;

    set querGenero(int value) {
        _querGenero = value;
    }
}

