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
          "idServico"       : profissional.idServico,
        });
    }

    Stream<QuerySnapshot> get collections{
      return collection.snapshots();
    }

    static Stream<String> getIdServico(String nome) {
        Stream<String> id = Firestore.instance.collection("servicos").where("nome", isEqualTo: nome).snapshots().map((snapshot){
          return snapshot.documents.map((doc){
            return doc.data.keys;
          }).toString();
        });
        return id;
    }
}