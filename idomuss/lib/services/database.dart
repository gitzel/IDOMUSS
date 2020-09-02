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
      Firestore.instance.collection("servicoContratado");
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

  Stream<List<Avaliacao>> listaAvaliacoes(String uidProfissional){
      return avalicao
      .where("uidCliente", isEqualTo: uid)
      .where("uidProfissional", isEqualTo: uidProfissional)
      .snapshots().map(_avalicaoFromSnapshot);
  }

  List<Avaliacao> _avalicaoFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Avaliacao.fromJson(doc.data);
    }).toList();
  }



  Future addFavoritos(Profissional profissional) async {
    String uidProfissional = profissional.uid;

    double c = double.parse(
        (await prof.document(uidProfissional).snapshots().first)
            .data["curtidas"]
            .toString());

    await prof.document(uidProfissional).updateData({"curtidas": ++c});

    return await Firestore.instance.collection("favoritos").add({
      "uidCliente": uid,
      "uidProfissional": uidProfissional,
    });
  }

  Future addServicoContratado(ServicoContratado servicoContratado) async {
    return await servicosContratados.add({
      "uidProfissional": servicoContratado.uidProfissional,
      "uidCliente": servicoContratado.uidCliente,
      "data": servicoContratado.data,
      "servico": servicoContratado.servico,
      "situacao": servicoContratado.situacao,
      "preco": servicoContratado.preco,
      "descricao": servicoContratado.descricao,
    });
  }

  Future updateServicoContratado(ServicoContratado servicoContratado) async {
    return await servicosContratados
        .document(servicoContratado.uidServicoContratado)
        .updateData({
      "uidProfissional": servicoContratado.profissional.uid,
      "uidCliente": servicoContratado.uidCliente,
      "data": servicoContratado.data,
      "servico": servicoContratado.servico,
      "situacao": servicoContratado.situacao,
      "preco": servicoContratado.preco,
      "descricao": servicoContratado.descricao,
    });
  }

  Stream<List<Servico>> ListaServicos(String condicao) {
    if(condicao.isEmpty)
      return servicos.orderBy("nome").snapshots().map(_servicosFromSnapshot);
    
    condicao = condicao[0].toUpperCase() + condicao.substring(1).toLowerCase();
    return servicos
    .orderBy('nome')
    .startAt([condicao])
    .endAt([condicao + "\uf8ff"])
    .snapshots().map(_servicosFromSnapshot);
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
      ret.uidServicoContratado = doc.documentID;
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

  Stream<List<Profissional>> get profissionaisPreferidos {
    return favorite
        .where("uidCliente", isEqualTo: uid)
        .snapshots()
        .map(_favoritosFromSnapshot);
  }

  List<Profissional> _favoritosFromSnapshot(QuerySnapshot snapshot) {
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
  }

  List<Endereco> _servicosContratadosListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Endereco.fromJson(doc.data);
    }).toList();
  }

  Future addFavorito(String uidProfissional) async {
    return await Firestore.instance.collection("avaliacao").add({
      "uidCliente": uid,
      "uidProfissional": uidProfissional,
    });
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

  Stream<List<Profissional>> profissionaisCategoria(String categoria) {
    return prof
        .where("servico", isEqualTo: categoria)
        .orderBy('nota')
        .snapshots()
        .map(_profissionaisCategoriaSnapshot);
  }

  List<Profissional> _profissionaisCategoriaSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      Profissional prof = Profissional.fromJson(doc.data);
      prof.uid = doc.documentID;
      return prof;
    }).toList();
  }

  List<Profissional> _profissionalListFromSnapshot(QuerySnapshot snapshot) {
    List<Profissional> p = snapshot.documents.map((doc) {
      Profissional ret = Profissional.fromJson(doc.data);
      ret.uid = doc.documentID;
      return ret;
    }).toList();

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
      double distanceInMeters = await Geolocator().distanceBetween(
          endereco.location.latitude,
          endereco.location.longitude,
          prof.location.latitude,
          prof.location.longitude);
      if (distanceInMeters < distance) profissionais.add(prof);
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
}
