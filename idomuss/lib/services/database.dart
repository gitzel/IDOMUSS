import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:idomuss/models/cliente.dart';
import 'package:idomuss/models/profissional.dart';
import 'package:idomuss/models/endereco.dart';

class DatabaseService{
    final String uid;

    DatabaseService({this.uid});

    final CollectionReference collection = Firestore.instance.collection("clientes");
    final CollectionReference prof = Firestore.instance.collection("profissionais");
    final CollectionReference enderecos = Firestore.instance.collection("endereco");


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

    Future updateUserAddress(Endereco endereco) async{
      return await enderecos.add({
            "uidCliente"  : uid,
            "complemento" : endereco.complemento,
            "numero"      : endereco.numero,
            "cep"         : endereco.cep,
            "filtro"      : endereco.filtro
      });
    }

    Future<Cliente> getCliente() async{
        List<Cliente> cliente =  await collection.document(uid).snapshots().map((doc){
          return Cliente.fromJson(doc.data);
        }).toList();

        return cliente[0];
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

    List<Endereco> _enderecoListFromSnapshot(QuerySnapshot snapshot) {
      return snapshot.documents.map((doc) {
        return Endereco.fromJson(doc.data);
      }).toList();
    }
}