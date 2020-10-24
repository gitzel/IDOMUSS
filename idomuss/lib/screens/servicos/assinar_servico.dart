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
import 'package:idomuss/services/database.dart';
import 'package:provider/provider.dart';

class AssinarServico extends StatefulWidget {
  String uidProf;
  AssinarServico(this.uidProf);

  @override
  _AssinarServicoState createState() => _AssinarServicoState();
}

class _AssinarServicoState extends State<AssinarServico> {
  DateTime dataSelecionada;
  DateTime horaSelecionada;
  List<DateTime> horariosOcupados;

  String descricao;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataSelecionada = DateTime.now();
    descricao = "";
    DateTime now = DateTime.now();
    int minutes = 30;
    int hour = now.hour;
    if (now.minute > 30) {
      now.add(Duration(hours: 1));
      minutes = 0;
    }
    horaSelecionada = DateTime(now.year, now.month, now.day, now.hour, minutes);
  }

  Future<DateTime> dialogData() async {
    final DateTime data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (data != null) {
      setState(() {
        dataSelecionada = data;
      });
    }
  }

  String DataToString() {
    return "${dataSelecionada.day.toString().padLeft(2, '0')}/${dataSelecionada.month.toString().padLeft(2, '0')}/${dataSelecionada.year.toString()}";
  }

  String HoraToString(DateTime hora) {
    return "${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}";
  }

  Future<void> dialogHora() async {
    bool valido = true;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selecione a hora desejada'),
          content: SingleChildScrollView(
              child: TimePickerSpinner(
            is24HourMode: true,
            isForce2Digits: true,
            minutesInterval: 30,
            onTimeChange: (time) {
              setState(() {
                horaSelecionada = time;
              });
            },
          )),
          actions: <Widget>[
            FlatButton(
              child: Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets paddingScreen = MediaQuery.of(context).padding;
    final user = Provider.of<FirebaseUser>(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: StreamBuilder<List<DateTime>>(
            stream: DatabaseService(uid: user.uid)
                .horarioDisponivel(widget.uidProf, horaSelecionada),
            builder: (context, snapshot) {
              horariosOcupados = snapshot.data;
              return Container(
                decoration: BoxDecoration(color: ColorSys.primary),
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
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
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Expanded(
                                  child: Image.asset(
                                      "assets/geral/accept_service.png")),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    TextFieldOutline(
                                      maxLine: 3,
                                      hint: "Descreva o que precisa",
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        dialogData();
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Data:",
                                            style: TextStyle(
                                                fontSize: fontSizeRegular,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(DataToString()),
                                          Icon(
                                            Icons.arrow_drop_down,
                                            color: ColorSys.primary,
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        dialogHora();
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Hora:",
                                            style: TextStyle(
                                                fontSize: fontSizeRegular,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(HoraToString(horaSelecionada)),
                                          Icon(
                                            Icons.arrow_drop_down,
                                            color: ColorSys.primary,
                                          ),
                                        ],
                                      ),
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
                                            AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.WARNING,
                                              animType: AnimType.TOPSLIDE,
                                              title: "Deseja mesmo contatar este profissional?",
                                              desc:
                                                  "Ao pressionar ok, o profissional entrará em contato contigo!",
                                              btnCancelOnPress: () {},
                                              btnOkOnPress: () {
                                                DatabaseService(uid: user.uid)
                                                   .addServicoContratado(ServicoContratado(_descricao, _preco, _data, _situacao, _uidProfissional, _uidCliente, _servico))
                                              },
                                            )..show();
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
              );
            }));
  }
}
