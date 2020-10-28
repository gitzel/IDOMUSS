import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admin/firebase_admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:idomuss/models/avaliacao.dart';
import 'package:idomuss/models/cliente.dart';
import 'package:idomuss/models/profissional.dart';
import 'package:idomuss/models/endereco.dart';
import 'package:idomuss/models/servico.dart';
import 'package:idomuss/models/servicoContratado.dart';
import 'package:idomuss/screens/home/lista.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference collection =
      Firestore.instance.collection("clientes");
  final CollectionReference prof =
      Firestore.instance.collection("profissionais");
  final CollectionReference enderecos =
      Firestore.instance.collection("endereco");
  final CollectionReference servicosContratados =
      Firestore.instance.collection("servicosContratados");
  final CollectionReference servicos =
      Firestore.instance.collection("servicos");
  final CollectionReference ranking = Firestore.instance.collection("ranking");
  final CollectionReference favorite =
      Firestore.instance.collection("favoritos");
  final CollectionReference avalicao =
      Firestore.instance.collection("avaliacao");

  Future updateUserData(Cliente cliente) async {
    return await collection.document(uid).setData({
      "rg": cliente.rg,
      "cpf": cliente.cpf,
      "email": cliente.email,
      "dataNascimento": cliente.dataNascimento,
      "foto": cliente.foto,
      "nome": cliente.nome,
      "numero": cliente.numeroCelular,
      "genero": cliente.genero,
      "querGenero": cliente.querGenero,
      "descricao": cliente.descricao,
    });
  }

  Future addUserAddress(Endereco endereco) async {
    return await enderecos.add({
      "uidCliente": uid,
      "complemento": endereco.complemento,
      "numero": endereco.numero,
      "rua": endereco.rua,
      "bairro": endereco.bairro,
      "cidade": endereco.cidade,
      "uf": endereco.uf,
      "location": endereco.location,
      "filtro": endereco.filtro
    });
  }

  Future removeUserAddress(GeoPoint location) async {
    return await enderecos
        .where("location", isEqualTo: location)
        .where("uidCliente", isEqualTo: uid)
        .getDocuments()
        .then((snapshot) {
      snapshot.documents.forEach((element) {
        enderecos.document(element.documentID).delete();
      });
    });
  }

  Future addAvaliacao(
      Profissional profissional, String texto, double nota) async {
    String uidProfissional = profissional.uid;

    double antigaNota = double.parse(
        (await prof.document(uidProfissional).snapshots().first)
            .data["nota"]
            .toString());
    double novaNota = (nota + antigaNota) / 2;

    await prof.document(uidProfissional).updateData({"nota": novaNota});

    return await avalicao.add({
      "uidCliente": uid,
      "uidProfissional": uidProfissional,
      "texto": texto,
      "nota": nota
    });
  }

  Stream<List<Avaliacao>> listaAvaliacoes(String uidProfissional) {
    return avalicao
        .where("uidProfissional", isEqualTo: uidProfissional)
        .snapshots()
        .map(_avalicaoFromSnapshot);
  }

  List<Avaliacao> _avalicaoFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Avaliacao.fromJson(doc.data);
    }).toList();
  }

  Future removerFavoritos(String uidProfissional) async {
    int c = int.parse((await prof.document(uidProfissional).snapshots().first)
        .data["curtidas"]
        .toString());

    await prof.document(uidProfissional).updateData({"curtidas": --c});

    return await favorite
        .where("uidProfissional", isEqualTo: uidProfissional)
        .where("uidCliente", isEqualTo: uid)
        .getDocuments()
        .then((snapshot) {
      snapshot.documents.forEach((element) {
        favorite.document(element.documentID).delete();
      });
    });
  }

  Future addFavoritos(String uidProfissional) async {
    int c = int.parse((await prof.document(uidProfissional).snapshots().first)
        .data["curtidas"]
        .toString());

    await prof.document(uidProfissional).updateData({"curtidas": ++c});

    return await favorite.add({
      "uidCliente": uid,
      "uidProfissional": uidProfissional,
    });
  }

  Future addServicoContratado(ServicoContratado servicoContratado) async {
    return await servicosContratados.add({
      "uidProfissional": servicoContratado.uidProfissional,
      "uidCliente": servicoContratado.uidCliente,
      "data": servicoContratado.data,
      "situacao": "Pendente",
      "preco": -1.0,
      "descricao": servicoContratado.descricao,
      "localizacao": servicoContratado.localizacao,
      "numero": servicoContratado.numero,
      "complemento": servicoContratado.complemento,
      "visualizado": false
    });
  }

  Stream<List<DateTime>> horarioDisponivel(String uidProf, DateTime data) {

    var min = Timestamp.fromDate(DateTime(data.year, data.month, data.day));
    var max = Timestamp.fromDate(DateTime.now().add(Duration(days:1)));

    return servicosContratados
        .where("uidProfissional", isEqualTo: uidProf)
        .where("data", isGreaterThanOrEqualTo: min)
      .where("data",  isLessThanOrEqualTo: max)
        .snapshots()
        .map(_horariosFromSnapshot);
  }

  List<DateTime> _horariosFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      Timestamp time = doc.data["data"];
      return DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch);
    }).toList();
  }

  Future updateServicoContratado(ServicoContratado servicoContratado) async {
    return await servicosContratados
        .document(servicoContratado.uid)
        .updateData({
      "uidProfissional": servicoContratado.uidProfissional,
      "uidCliente": servicoContratado.uidCliente,
      "data": servicoContratado.data,
      "situacao": servicoContratado.situacao,
      "preco": servicoContratado.preco,
      "descricao": servicoContratado.descricao,
    });
  }

  Stream<List<Servico>> ListaServicos(String condicao) {
    if (condicao.isEmpty)
      return servicos.orderBy("nome").snapshots().map(_servicosFromSnapshot);

    condicao = condicao[0].toUpperCase() + condicao.substring(1).toLowerCase();
    return servicos
        .orderBy('nome')
        .startAt([condicao])
        .endAt([condicao + "\uf8ff"])
        .snapshots()
        .map(_servicosFromSnapshot);
  }

  List<Servico> _servicosFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Servico.fromJson(doc.data);
    }).toList();
  }

  Stream<List<ServicoContratado>> get servicosContratado {
    return servicosContratados
        .where("uidCliente", isEqualTo: uid)
        .snapshots()
        .map(_servicosContratadosFromSnapshot);
  }

  List<ServicoContratado> _servicosContratadosFromSnapshot(
      QuerySnapshot snapshot) {
    List<ServicoContratado> servicos = snapshot.documents.map((doc) {
      ServicoContratado ret = ServicoContratado.fromJson(doc.data);
      ret.uid = doc.documentID;
      return ret;
    }).toList();

    servicos.forEach((servico) async {
      prof
          .document(servico.uidProfissional)
          .snapshots()
          .map((event) => (QuerySnapshot snapshot_prof) {
                snapshot_prof.documents.map((doc) =>
                    servico.uidProfissional = doc.data["uid"].toString());
              });
    });

    return servicos;
  }

  Stream<List<Profissional>> get profissionaisPreferidos async* {
    List<String> uidProfFav = await favorite
        .where("uidCliente", isEqualTo: uid)
        .snapshots()
        .map(_favoritosFromSnapshot)
        .first;

    List<Profissional> ret = List<Profissional>();

    for (var uidProf in uidProfFav) {
      Profissional p = await prof
          .document(uidProf)
          .snapshots()
          .map(_profissionalFromSnapshot)
          .first;
      ret.add(p);
    }

    yield ret;
  }

  List<String> _favoritosFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return doc.data['uidProfissional'].toString();
    }).toList();
  }

  /*List<Profissional> _favoritosFromSnapshot(QuerySnapshot snapshot) {
    List<String> fav = snapshot.documents.map((doc) {
      return doc.data["uidProfissional"].toString();
    }).toList();

    List<Profissional> ret = List<Profissional>();

    fav.forEach((f) async {
      prof
          .document(f)
          .snapshots()
          .map((event) => (QuerySnapshot snapshot_prof) {
                snapshot_prof.documents
                    .map((doc) => ret.add(Profissional.fromJson(doc.data)));
              });
    });

    return ret;
  }*/

  List<Endereco> _servicosContratadosListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Endereco.fromJson(doc.data);
    }).toList();
  }

  Future<Cliente> getCliente() async {
    Cliente cliente;

    await collection.document(uid).snapshots().map((doc) {
      cliente = Cliente.fromJson(doc.data);
      cliente.uid = doc.documentID;
    });

    return cliente;
  }

  Stream<Cliente> get cliente {
    return collection.document(uid).snapshots().map(_clienteFromSnapshot);
  }

  Cliente _clienteFromSnapshot(DocumentSnapshot snapshot) {
    Cliente cliente;
    cliente = Cliente.fromJson(snapshot.data);
    cliente.uid = snapshot.documentID;
    return cliente;
  }

  void deleteUserData() async {
    await collection.document(uid).delete();
  }

  Stream<List<Profissional>> get ListaProfissionaisByNota {
    // o parametro estava como List<string>
    return prof.orderBy("nota").snapshots().map(_profissionalListFromSnapshot);
  }

  Stream<List<Profissional>> get profissionais {
    return prof.snapshots().map(_profissionalListFromSnapshot);
  }

  Stream<List<Profissional>> profissionaisCategoria(String categoria) async* {
    List<String> profFav = await favorite
        .where("uidCliente", isEqualTo: uid)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.documents.map((doc) {
        return doc.data['uidProfissional'].toString();
      }).toList();
    }).first;

    yield* prof
        .where("servico", isEqualTo: categoria)
        .orderBy('nota')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.documents.map((doc) {
        Profissional ret = Profissional.fromJson(doc.data);
        ret.uid = doc.documentID;
        ret.favoritado = profFav.contains(doc.documentID);
        return ret;
      }).toList();
    });
  }

  List<Profissional> _profissionalListFromSnapshot(QuerySnapshot snapshot) {
    List<Profissional> p = snapshot.documents.map((doc) {
      Profissional ret = Profissional.fromJson(doc.data);
      ret.uid = doc.documentID;
      return ret;
    }).toList();

    return p;
  }

  Profissional _profissionalFromSnapshot(DocumentSnapshot snapshot) {
    Profissional p = Profissional.fromJson(snapshot.data);
    p.uid = snapshot.documentID;
    return p;
  }

  Future<List<Profissional>> _profissionalCategoriaList(
      {String categoria = null}) async {
    List<Profissional> profissionais;

    if (categoria == null)
      profissionais = (await prof.snapshots().map((snapshot) {
        return snapshot.documents.map((doc) {
          return Profissional.fromJson(doc.data);
        }).toList();
      }).toList())
          .first;
    else
      profissionais = (await prof
              .where("servico", isEqualTo: categoria)
              .orderBy("nota")
              .snapshots()
              .map((snapshot) {
        return snapshot.documents.map((doc) {
          return Profissional.fromJson(doc.data);
        }).toList();
      }).toList())
          .first;

    return profissionais;
  }

  Future<List<Profissional>> nearProfissionais(Endereco endereco,
      {int distance = 10000, String categoria = null}) async {
    List<Profissional> profissionais = List<Profissional>();
    List<Profissional> all =
        await _profissionalCategoriaList(categoria: categoria);

    all.forEach((prof) async {
      double distanceInMeters = await distanceBetween(
          endereco.location.latitude,
          endereco.location.longitude,
          prof.location.latitude,
          prof.location.longitude);
      if (distanceInMeters <= distance) profissionais.add(prof);
    });

    return profissionais;
  }

  Stream<List<Endereco>> get enderecosFromCliente {
    return enderecos
        .where("uidCliente", isEqualTo: uid)
        .snapshots()
        .map(_enderecoListFromSnapshot);
  }

  List<Endereco> _enderecoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Endereco.fromJson(doc.data);
    }).toList();
  }

  Future getFoto() {
    return FirebaseStorage.instance
        .ref()
        .child("//clientes//" + uid + ".jpg")
        .getDownloadURL();
  }

  List<String> _nomeServicoFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return doc.data['nome'].toString();
    }).toList();
  }

  void gerarMelhoresDaSemana(DateTime monday) async {
    List<String> listaServicos = await servicos
        .orderBy("nome")
        .snapshots()
        .map(_nomeServicoFromSnapshot)
        .first;

    List<Profissional> total = await prof
        .orderBy('nota')
        .snapshots()
        .map(_profissionalListFromSnapshot)
        .first;

    try {
      listaServicos.forEach((s) {
        List<Profissional> possivel =
            total.where((prof) => prof.nomeServico == s).toList();
        int c = 0, indice = 0;

        while (c < 5 && indice < possivel.length) {
          if (monday.difference(possivel[indice].melhor) >=
              Duration(days: 14)) {
            c++;
            prof.document(possivel[indice].uid).updateData({"melhor": monday});
          }
          indice++;
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Stream<List<Profissional>> melhoresDaSemana(double lat, double lng) async* {
    try {
      var now = new DateTime.now();
      now = now.subtract(Duration(days: now.weekday - 1));
      now = DateTime(now.year, now.month, now.day);
      await prof
          .where("melhor", isEqualTo: Timestamp.fromDate(now))
          .getDocuments()
          .then((value) {
        if (value.documents.isEmpty) gerarMelhoresDaSemana(now);
      });

      List<Profissional> all = await prof
          .where("melhor", isEqualTo: now)
          .snapshots()
          .map(_profissionalListFromSnapshot)
          .first;

      List<Profissional> ret = new List<Profissional>();

      for (Profissional profissional in all) {
        double distanceInMeters = await distanceBetween(lat, lng,
            profissional.location.latitude, profissional.location.longitude);
        if (distanceInMeters <= 10000) ret.add(profissional);
      }

      yield ret;
    } catch (e) {
      print(e);
    }
  }
}
