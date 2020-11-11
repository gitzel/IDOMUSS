import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';
import 'package:idomuss/models/servicoContratado.dart';
import 'package:idomuss/screens/home/busca.dart';
import 'package:idomuss/screens/servicos/confirmar_servico.dart';
import 'package:idomuss/services/database.dart';
import 'package:provider/provider.dart';

class DataServico extends StatefulWidget {
  ServicoContratado servicoContratado;
  String nomeProfissional;
  DataServico(this.servicoContratado, this.nomeProfissional);

  @override
  _DataServicoState createState() => _DataServicoState();
}

class _DataServicoState extends State<DataServico> {
  DateTime dataSelecionada;
  DateTime horaSelecionada;

  List<DateTime> horariosOcupados;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataSelecionada = DateTime.now();
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

  String horaToString(hora) {
    return "${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}";
  }

  List<Widget> gerarLista(List<DateTime> excecoes) {
    var original = DateTime(dataSelecionada.year, dataSelecionada.month,
        dataSelecionada.day, 8, 0, 0);
    var aux = DateTime(dataSelecionada.year, dataSelecionada.month,
        dataSelecionada.day, 8, 0, 0);
    return List.generate(24, (index) {
      bool disponivel = DateTime.now().difference(aux).isNegative &&
          excecoes.where((hora) {
            return hora.hour == aux.hour && hora.minute == aux.minute;
          }).isEmpty;
      Widget ret = GestureDetector(
        onTap: !disponivel
            ? null
            : () {
                widget.servicoContratado.data =
                    original.add(Duration(minutes: 30 * index));
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConfirmarServico(
                          widget.servicoContratado, widget.nomeProfissional),
                    ));
              },
        child: Container(
            decoration: BoxDecoration(
                color: disponivel ? Colors.deepPurple : Colors.grey,
                borderRadius: BorderRadius.circular(10),
                boxShadow: shadow),
            child: Center(
                child: Text(
              horaToString(aux),
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ))),
      );

      aux = aux.add(Duration(minutes: 30));
      return ret;
    });
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
            stream: DatabaseService(uid: user.uid).horarioDisponivel(
                widget.servicoContratado.uidProfissional, dataSelecionada),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return LoadPage();

              return Container(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: paddingSmall),
                                child: Text(
                                  "Selecione a data e hora pretendida",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: fontSizeRegular),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  dialogData();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(paddingSmall),
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(paddingSmall),
                                    decoration: BoxDecoration(
                                        color: ColorSys.lightGray,
                                        boxShadow: shadow),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.calendar_today,
                                            color: ColorSys.primary),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: paddingSmall),
                                          child: Text(
                                            DataToString(),
                                            style: TextStyle(
                                                color: ColorSys.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GridView.count(
                                    padding: EdgeInsets.all(paddingSmall),
                                    crossAxisCount: 4,
                                    childAspectRatio: 1.1,
                                    mainAxisSpacing: paddingSmall,
                                    crossAxisSpacing: paddingSmall,
                                    children: gerarLista(snapshot.data)),
                              ),
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
