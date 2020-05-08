import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:idomussprofissional/models/profissional.dart';

class DatabaseService{
    final String uid;

    DatabaseService({this.uid});

    final CollectionReference collection = Firestore.instance.collection("profissionais");

    Future updateUserData(Profissional profissional) async{
        return await collection.document(uid).setData({
          "rg"              : profissional.rg,
          "cpf"             : profissional.cpf,
          "nome"            : profissional.nome,
          "numeroCelular"   : profissional.numeroCelular,
          "dataNascimento"  : profissional.dataNascimento,
          "genero"          : profissional.genero,
          "querGenero"      : profissional.querGenero,
          "descricao"       : profissional.descricao,
          "foto"            : profissional.foto,
        });
    }

    Stream<QuerySnapshot> get collections{
      return collection.snapshots();
    }
}