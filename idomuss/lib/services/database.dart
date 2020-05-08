import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:idomuss/models/cliente.dart';
import 'package:idomuss/models/profissional.dart';
import 'package:firebase_database/firebase_database.dart' as db;


class DatabaseService{
    final String uid;

    DatabaseService({this.uid});

    final CollectionReference collection = Firestore.instance.collection("clientes");
    final CollectionReference prof = Firestore.instance.collection("profissionais");

    Future updateUserData(Cliente cliente) async{
        return await collection.document(uid).setData({
          "rg"              : cliente.rg,
          "cpf"             : cliente.cpf,
          "nome"            : cliente.nome,
          "numeroCelular"   : cliente.numeroCelular,
          "dataNascimento"  : cliente.dataNascimento,
          "genero"          : cliente.genero,
          "querGenero"      : cliente.querGenero,
          "descricao"       : cliente.descricao,
          });
    }

    void  deleteUserData(Cliente cliente) async{
        await collection.document(uid).delete();
    }


    Stream<List<Profissional>> get profissionais{
      return prof.snapshots().map(_profissionalListFromSnapshot);
    }

    List<Profissional> _profissionalListFromSnapshot(QuerySnapshot snapshot) {
      return snapshot.documents.map((doc) {
        return Profissional.fromJson(doc.data);
      }).toList();
    }
}