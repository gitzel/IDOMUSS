import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';
import 'package:idomuss/models/cliente.dart';
import 'package:idomuss/models/mensagem.dart';
import 'package:idomuss/models/profissional.dart';
import 'package:idomuss/screens/home/busca.dart';
import 'package:idomuss/services/database.dart';
import 'package:provider/provider.dart';

class Chat extends StatefulWidget {
  Profissional profissional;
  String fotoCliente;

  Chat(this.profissional);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  TextEditingController msgController = new TextEditingController();

  _bolhaMensagem(String message, DateTime data, bool ehCliente, bool semFoto) {
    return Column(
      children: <Widget>[
        Container(
          alignment: !ehCliente ? Alignment.topLeft : Alignment.topRight,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            padding: EdgeInsets.all(paddingSmall),
            margin: EdgeInsets.symmetric(vertical: paddingSmall),
            decoration: BoxDecoration(
              color: !ehCliente ? Colors.white : ColorSys.primary,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Text(
              message,
              style: TextStyle(
                color: !ehCliente ? Colors.black54 : Colors.white,
              ),
            ),
          ),
        ),
        !semFoto
            ? Row(
                mainAxisAlignment: !ehCliente
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.end,
                children: ehCliente
                    ? [
                        Text(
                          "${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black45,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundImage: NetworkImage(widget.fotoCliente),
                          ),
                        ),
                      ]
                    : [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundImage:
                                NetworkImage(widget.profissional.foto),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black45,
                          ),
                        ),
                      ],
              )
            : Container(
                child: null,
              ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.profissional.nome,
          textAlign: TextAlign.center,
          style:
              TextStyle(fontWeight: FontWeight.bold, fontSize: fontSizeSmall),
        ),
      ),
      body: StreamBuilder<Cliente>(
          stream: DatabaseService(uid: user.uid).cliente,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LoadPage();

            widget.fotoCliente = snapshot.data.foto;

            return Column(
              children: [
                Expanded(
                  child: Container(
                      width: double.infinity,
                      decoration: background,
                      child: StreamBuilder<List<Mensagem>>(
                        stream: DatabaseService(uid: user.uid)
                            .getMensagensProfissional(widget.profissional.uid),
                        builder: (context, mensagens) {
                          if (!mensagens.hasData) return LoadPage();

                          return ListView.builder(
                            reverse: true,
                            padding: EdgeInsets.all(paddingSmall),
                            itemCount: mensagens.data.length,
                            itemBuilder: (context, index) {
                              if (mensagens.data[index].autorCliente &&
                                  !mensagens.data[index].visualizado)
                                DatabaseService(uid: user.uid)
                                    .visualizarMensagem(
                                        mensagens.data[index].uidMensagem);

                              var semFoto = true;
                              if (mensagens.data.length <= 1)
                                semFoto = false;
                              else if (index <= 0)
                                semFoto = false;
                              else if (mensagens.data[index].autorCliente !=
                                  mensagens.data[index - 1].autorCliente)
                                semFoto = false;

                              return _bolhaMensagem(
                                  mensagens.data[index].mensagem,
                                  mensagens.data[index].data,
                                  mensagens.data[index].autorCliente,
                                  semFoto);
                            },
                          );
                        },
                      )),
                ),
                Expanded(
                  flex: -1,
                  child: Container(
                    padding: EdgeInsets.all(paddingSmall),
                    decoration: BoxDecoration(color: ColorSys.darkGray),
                    child: Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(right: paddingTiny),
                          child: Container(
                            decoration: BoxDecoration(
                                color: ColorSys.gray,
                                borderRadius: BorderRadius.circular(50)),
                            child: TextFormField(
                              controller: msgController,
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 25),
                                  hintText: "Digite uma mensagem...",
                                  border: InputBorder.none),
                            ),
                          ),
                        )),
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: ColorSys.primary),
                          child: IconButton(
                            onPressed: () {
                              if (msgController.text.isNotEmpty) {
                                DatabaseService(uid: user.uid).sendMessage(
                                    widget.profissional.uid,
                                    msgController.text);
                                msgController.clear();
                              }
                            },
                            icon: Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
