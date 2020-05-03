import 'package:idomuss/db/Cliente.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

class Conect
{
    static final String url = "http://192.168.15.12:3000/";

    static Future<Cliente> getCliente(String nome) async
    {
        http.Response  response = await http.get(url + "usuario/" + nome);

        Map clienteMap = json.decode(response.body)[0];
        return  Future(() =>  Cliente.fromJson(clienteMap));
    }


    static Future<http.Response> cadastro (String nome, String senha) async {
        Map data = {
            'Nome': nome,
            'Senha': senha
        };

        var response = await http.post(url + 'cadastrarCliente',
            body: data
        );

        return response;
    }

    static Future<http.Response> deletar (String nome) async {
        var response = await http.delete(url + 'excluiConta/' + nome);

        return response;
    }
}