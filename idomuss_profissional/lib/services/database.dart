import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:idomussprofissional/models/profissional.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference collection =
      Firestore.instance.collection("profissionais");
  final CollectionReference servicos =
      Firestore.instance.collection("servico");

  Future updateUserData(Profissional profissional) async {
    return await collection.document(uid).setData({
      "rg": profissional.rg,
      "cpf": profissional.cpf,
      "email": profissional.email,
      "vip": profissional.vip,
      "dataNascimento": profissional.dataNascimento,
      "nome":profissional.nome,
      "numero":profissional.numeroCelular,
      "foto":profissional.foto,
      "genero": profissional.genero,
      "querGenero": profissional.querGenero,
      "descricao": profissional.descricao,
      "location": profissional.location,
      "nomeServico": profissional.nomeServico,
      "nota": profissional.nota
    });
  }

  Stream<List<String>> get ListaServicos {
    return servicos.snapshots().map(_servicosFromSnapshot);
  }

  List<String> _servicosFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return doc.data["nome"];
    }).toList();
  }

  Stream<QuerySnapshot> get collections {
    return collection.snapshots();
  }

  static Stream<String> getIdServico(String nome) {
    Stream<String> id = Firestore.instance
        .collection("servicos")
        .where("nome", isEqualTo: nome)
        .snapshots()
        .map((snapshot) {
      return snapshot.documents.map((doc) {
        return doc.data.keys;
      }).toString();
    });
    return id;
  }

  Stream<List<String>> get enderecosFromCliente {
    return Firestore.instance
        .collection("avaliacao")
        .where("uidProfissional", isEqualTo: uid)
        .snapshots()
        .map(_enderecoListFromSnapshot);
  }

  List<String> _enderecoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return doc.data["texto"];
    }).toList();
  }

  Future<Profissional> getProfissional() async {
    Profissional profissional;

    await collection.document(uid).snapshots().map((doc) {
          profissional =  Profissional.fromJson(doc.data);
    }).toList();

    return profissional;
  }

  void deleteUserData() async {
    await collection.document(uid).delete();
  }
}
