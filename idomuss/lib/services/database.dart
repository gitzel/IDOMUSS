import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:idomuss/models/cliente.dart';
import 'package:idomuss/models/profissional.dart';
import 'package:idomuss/models/endereco.dart';
import 'package:idomuss/models/servicoContratado.dart';

class DatabaseService{
    final String uid;

    DatabaseService({this.uid});

    final CollectionReference collection = Firestore.instance.collection("clientes");
    final CollectionReference prof = Firestore.instance.collection("profissionais");
    final CollectionReference enderecos = Firestore.instance.collection("endereco");
    final CollectionReference servicosContratados = Firestore.instance.collection("servicoContratado");


    Future updateUserData(Cliente cliente) async{
      /*
        "foto"            : cliente.foto,
        "nome"            : cliente.nome,
      */
        return await collection.document(uid).setData({
          "rg"              : cliente.rg,
          "cpf"             : cliente.cpf,
          "dataNascimento"  : cliente.dataNascimento,
          "genero"          : cliente.genero,
          "querGenero"      : cliente.querGenero,
          "descricao"       : cliente.descricao,
        });
    }

    Future addUserAddress(Endereco endereco) async{
      return await enderecos.add({
            "uidCliente"  : uid,
            "complemento" : endereco.complemento,
            "numero"      : endereco.numero,
            "cep"         : endereco.cep,
            "filtro"      : endereco.filtro
      });
    }

    Future addAvaliacao(String uidProfissional, String texto, double nota) async{
        return await Firestore.instance.collection("avaliacao").add({
          "uidCliente"      : uid,
          "uidProfissional" : uidProfissional,
          "texto"           : texto,
          "nota"            : nota
        });
    }


    Future addServicoContratado(ServicoContratado servicoContratado) async{
      return await servicosContratados.add({
        "uidProfissional" : servicoContratado.uidProfissional,
        "uidCliente"      : servicoContratado.uidCliente,
        "data"            : servicoContratado.data,
        "uidServico"      : servicoContratado.uidServico,
        "situacao"        : servicoContratado.situacao,
        "preco"           : servicoContratado.preco,
        "descricao"       : servicoContratado.descricao,
      });
    }

    Future updateServicoContratado(String uidServicoContratado, ServicoContratado servicoContratado) async{
      return await servicosContratados.document(uidServicoContratado).updateData({
          "uidProfissional" : servicoContratado.uidProfissional,
          "uidCliente"      : servicoContratado.uidCliente,
          "data"            : servicoContratado.data,
          "uidServico"      : servicoContratado.uidServico,
          "situacao"        : servicoContratado.situacao,
          "preco"           : servicoContratado.preco,
          "descricao"       : servicoContratado.descricao,
      });
    }


    Future getServicosContratados(ServicoContratado servicoContratado) async{
      /*Stream<String> id = servicosContratados.where("uidProfissional", isEqualTo: nome).snapshots().map((snapshot){
        return snapshot.documents.map((doc){
          return doc.data.keys;
        }).toString();
      });
      return id;
        return enderecos.where("uidCliente", isEqualTo: uid).snapshots().map(_enderecoListFromSnapshot);
     */
    }


    List<Endereco> _servicosContratadosListFromSnapshot(QuerySnapshot snapshot) {
      return snapshot.documents.map((doc) {
        return Endereco.fromJson(doc.data);
      }).toList();
    }


    Future addFavorito(String uidProfissional) async{
      return await Firestore.instance.collection("avaliacao").add({
        "uidCliente"      : uid,
        "uidProfissional" : uidProfissional,
      });
    }

    Future<Cliente> getCliente() async{
        List<Cliente> cliente =  await collection.document(uid).snapshots().map((doc){
          return Cliente.fromJson(doc.data);
        }).toList();

        return cliente.first;
    }

    void deleteUserData() async{
        await collection.document(uid).delete();
    }

    Stream<List<Profissional>> get profissionais{
      return prof.snapshots().map(_profissionalListFromSnapshot);
    }

    Stream<List<Endereco>> get enderecosFromCliente{
      return enderecos.where("uidCliente", isEqualTo: uid).snapshots().map(_enderecoListFromSnapshot);
    }

    List<Profissional> _profissionalListFromSnapshot(QuerySnapshot snapshot) {
      return snapshot.documents.map((doc) {
        return Profissional.fromJson(doc.data);
      }).toList();
    }

    Future<List<Profissional>> profissionalCategoriaList(String categoria) async {
      List<List<Profissional>> lista = await prof.where("categoria", isEqualTo:  categoria).snapshots().map((snapshot) {
        return snapshot.documents.map((doc){
          return Profissional.fromJson(doc.data);
        }).toList();
      }).toList();

      return lista.first;
    }

    List<Endereco> _enderecoListFromSnapshot(QuerySnapshot snapshot) {
      return snapshot.documents.map((doc) {
        return Endereco.fromJson(doc.data);
      }).toList();
    }
}