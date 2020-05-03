import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Cliente
{
  final int id;
  final String nome;
  final String senha;

  Cliente(this.id, this.nome, this.senha);

  Cliente.fromJson(Map<String, dynamic> json)
      : id = json["Id"],
        nome = json['Nome'],
        senha = json['Senha'];
}

