import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:idomussprofissional/models/profissional.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference profissionais =
      Firestore.instance.collection("profissionais");
  final CollectionReference servicos =
      Firestore.instance.collection("servicos");

  Future updateUserData(Profissional profissional) async {
    return await profissionais.document(uid).setData({
      "rg": profissional.rg,
      "cpf": profissional.cpf,
      "cnpj": profissional.cnpj,
      "email": profissional.email,
      "vip": profissional.vip,
      "dataNascimento": profissional.dataNascimento,
      "nome":profissional.nome,
      "numero":profissional.numeroCelular,
      "foto":profissional.foto,
      "genero": profissional.genero,
      "descricao": profissional.descricao,
      "location": profissional.location,
      "servico": profissional.nomeServico,
      "nota": -1,
      "servicosPrestados": 0,
      "curtidas": 0,
      "limite": profissional.limite,
      "uid": uid,
      "melhor": Timestamp.fromDate(DateTime(2020, 9, 7,))
    });
  }

  Stream<List<String>> get ListaServicos {
    return servicos.snapshots().map(_servicosFromSnapshot);
  }

  List<String> _servicosFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return doc.data["nome"].toString();
    }).toList();
  }

  Stream<QuerySnapshot> get collections {
    return profissionais.snapshots();
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

    await profissionais.document(uid).snapshots().map((doc) {
          profissional =  Profissional.fromJson(doc.data);
    }).toList();

    return profissional;
  }

  Stream<Profissional> get profissional {
    return profissionais.document(uid).snapshots().map(_ProfissionalFromSnapshot);
  }

  Profissional _ProfissionalFromSnapshot(DocumentSnapshot snapshot) {
    Profissional prof;
    prof = Profissional.fromJson(snapshot.data);
    prof.uid = snapshot.documentID;
    return prof;
  }

  void deleteUserData() async {
    await profissionais.document(uid).delete();
  }
}
