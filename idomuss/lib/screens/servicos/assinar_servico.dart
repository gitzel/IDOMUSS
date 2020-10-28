import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_admin/firebase_admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idomuss/components/textFieldOutline.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:idomuss/models/servicoContratado.dart';
import 'package:idomuss/screens/servicos/data_servico.dart';
import 'package:idomuss/services/database.dart';
import 'package:provider/provider.dart';

class AssinarServico extends StatefulWidget {

  String uidProf, nomeProfissional;
  AssinarServico(this.uidProf, this.nomeProfissional);

  @override
  _AssinarServicoState createState() => _AssinarServicoState();
}

class _AssinarServicoState extends State<AssinarServico> {
 
  TextEditingController controller = new TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets paddingScreen = MediaQuery.of(context).padding;
    final user = Provider.of<FirebaseUser>(context);
    
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body:  Container(
                decoration: BoxDecoration(color: ColorSys.primary),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height -
                            kToolbarHeight -
                            paddingScreen.top,
                        decoration: BoxDecoration(
                          color: ColorSys.gray,
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(75.0)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(paddingSmall),
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                  child: Image.asset(
                                      "assets/geral/accept_service.png")),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Descreva seu problema",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: fontSizeRegular
                                    ),
                                    ),
                                    TextFieldOutline(
                                      maxLine: 8,
                                      controller: controller,
                                      hint: "Descreva o que precisa",
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: double.infinity,
                                        child: RaisedButton(
                                          color: ColorSys.primary,
                                          child: Icon(
                                            Icons.check,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            var servico = ServicoContratado.empty();
                                            servico.descricao = controller.text;
                                            servico.uidProfissional = widget.uidProf;
                                            servico.uidCliente = user.uid;
                                            Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => DataServico(
                                                servico,
                                                widget.nomeProfissional
                                              ),
                                            ));
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
            
          ));
  }
}