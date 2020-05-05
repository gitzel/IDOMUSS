import 'package:idomuss/db/cliente.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

class Connect
{
    static final String url = "http://192.168.15.3:3000/";

    static Future<http.Response> cadastro (Cliente novoCliente, String senha) async {
        Map data = novoCliente.toMap();
        data["senha"] = senha;

        var response = await http.post(url + 'cadastrarCliente',
            body: data
        );

        return response;
    }

    static Future deletar (Cliente cliente, String senha) async {
        final uri = Uri.parse(url + "excluiCliente");

        final request = http.Request("DELETE", uri);

        request.bodyFields = {
            'email' : cliente.email,
            'senha' : senha
        };

        final response = await request.send();

        return response;
    }

    static Future<http.Response> alterar (String novoValor, String email, String campo) async {

        var response = await http.patch(url + "altera/" + campo + "/cliente",
            body: {
                'email'     : email,
                'novoValor' : novoValor
            }
        );

        return response;
    }

    static Future<Cliente> login (String email, String senha) async {
        var response = await http.post(url + "loginCliente",
            body:  {
                'email': email,
                'senha': senha
            }
        );

        Map clienteMap = json.decode(response.body)[0];

        return  Future(() =>  Cliente.fromJson(clienteMap));
    }
}