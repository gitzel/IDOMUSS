import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admin/firebase_admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:idomuss/models/cliente.dart';
import 'package:idomuss/models/profissional.dart';
import 'package:idomuss/models/endereco.dart';
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
      Firestore.instance.collection("servico");
  final CollectionReference ranking =
      Firestore.instance.collection("ranking");


  Future updateUserData(Cliente cliente) async {
    return await collection.document(uid).setData({
      "rg": cliente.rg,
      "cpf": cliente.cpf,
      "email": cliente.email,
      "dataNascimento": cliente.dataNascimento,
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
    String uidProfissional =(await FirebaseAdmin.instance
              .initializeApp()
              .auth()
              .getUserByEmail(profissional.email))
              .uid;
    
    return await Firestore.instance.collection("avaliacao").add({
      "uidCliente": uid,
      "uidProfissional": uidProfissional,
      "texto": texto,
      "nota": nota
    });
    
    /*prof.document(uidProfissional).updateData({updateProf});*/
  }

  Future addServicoContratado(ServicoContratado servicoContratado) async {
    return await servicosContratados.add({
      "uidProfissional": servicoContratado.uidProfissional,
      "uidCliente": servicoContratado.uidCliente,
      "data": servicoContratado.data,
      "uidServico": servicoContratado.uidServico,
      "situacao": servicoContratado.situacao,
      "preco": servicoContratado.preco,
      "descricao": servicoContratado.descricao,
    });
  }

  Future updateServicoContratado(
      String uidServicoContratado, ServicoContratado servicoContratado) async {
    return await servicosContratados.document(uidServicoContratado).updateData({
      "uidProfissional": (await FirebaseAdmin.instance
              .initializeApp()
              .auth()
              .getUserByEmail(servicoContratado.profissional.email))
          .uid,
      "uidCliente": servicoContratado.uidCliente,
      "data": servicoContratado.data,
      "uidServico": servicoContratado.uidServico,
      "situacao": servicoContratado.situacao,
      "preco": servicoContratado.preco,
      "descricao": servicoContratado.descricao,
    });
  }
  
  Stream<List<String>> get ListaServicos{
    return servicos.snapshots().map(_servicosFromSnapshot);
  }
  
  List<String> _servicosFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return doc.data["nome"];  // antes era data.nome
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
      return ServicoContratado.fromJson(doc.data);
    }).toList();

    servicos.forEach((servico) async {
      var prof = await FirebaseAdmin.instance
          .initializeApp()
          .auth()
          .getUser(servico.uidProfissional);
      var cliente = await FirebaseAdmin.instance
          .initializeApp()
          .auth()
          .getUserByEmail(servico.uidCliente);
      /*servico.profissional = prof;
      servico.cliente = cliente;*/
    });

    return servicos;
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
    List<Cliente> cliente =
        await collection.document(uid).snapshots().map((doc) {
      return Cliente.fromJson(doc.data);
    }).toList();

    return cliente.first;
  }

  void deleteUserData() async {
    await collection.document(uid).delete();
  }
  
  Stream<List<Profissional>> get ListaProfissionaisByNota{ // o parametro estava como List<string>
    return servicos.orderBy("nota").snapshots().map(_profissionalListFromSnapshot);
  }

  Stream<List<Profissional>> get profissionais {
    return prof.snapshots().map(_profissionalListFromSnapshot);
  }

  List<Profissional> _profissionalListFromSnapshot(QuerySnapshot snapshot) {
    List<Profissional> profissionais = snapshot.documents.map((doc) {
      return Profissional.fromJson(doc.data);
    }).toList();

    profissionais.forEach((prof) async {
      var user = await FirebaseAdmin.instance
          .initializeApp()
          .auth()
          .getUserByEmail(prof.email);
      prof.nome = user.displayName;
      prof.foto = user.photoUrl;
      prof.numeroCelular = user.phoneNumber;
    });

    return profissionais;
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
              .where("nomeServico", isEqualTo: categoria)
              .orderBy("nota")
              .snapshots()
              .map((snapshot) {
        return snapshot.documents.map((doc) {
          return Profissional.fromJson(doc.data);
        }).toList();
      }).toList())
          .first;

    profissionais.forEach((prof) async {
      var user = await FirebaseAdmin.instance
          .initializeApp()
          .auth()
          .getUserByEmail(prof.email);
      prof.nome = user.displayName;
      prof.foto = user.photoUrl;
      prof.numeroCelular = user.phoneNumber;
    });

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
}
