import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:idomuss/components/servico_item.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';
import 'package:idomuss/models/servicoContratado.dart';
import 'package:idomuss/screens/home/busca.dart';
import 'package:idomuss/screens/home/infoServico.dart';
import 'package:idomuss/services/database.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendario extends StatefulWidget {
  @override
  _CalendarioState createState() => _CalendarioState();
}

class _CalendarioState extends State<Calendario> {
  DateTime dataSelecionada;
  CalendarController controller = new CalendarController();
  final List<String> diasDaSemana = [
    "Seg",
    "Ter",
    "Qua",
    "Qui",
    "Sex",
    "Sáb",
    "Dom"
  ];
  final List<String> mesesDoAno = [
    "Janeiro",
    "Fevereiro",
    "Março",
    "Abril",
    "Maio",
    "Junho",
    "Julho",
    "Agosto",
    "Setembro",
    "Outubro",
    "Novembro",
    "Dezembro"
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime now = DateTime.now();
    dataSelecionada = DateTime(now.year, now.month);
  }

  StreamController<double> streamController = StreamController.broadcast();
  double position;
  Map<DateTime, List<ServicoContratado>> gerarLista(
      List<ServicoContratado> lista) {
    DateTime firstDay =
        new DateTime(dataSelecionada.year, dataSelecionada.month);
    DateTime nextMonth =
        new DateTime(dataSelecionada.year, dataSelecionada.month + 1);
    Map<DateTime, List<ServicoContratado>> servicoPorDia = new Map();

    for (var serv in lista) {
      if (servicoPorDia.containsKey(
          DateTime(serv.data.year, serv.data.month, serv.data.day)))
        servicoPorDia[
            DateTime(serv.data.year, serv.data.month, serv.data.day)] += [serv];
      else
        servicoPorDia[
            DateTime(serv.data.year, serv.data.month, serv.data.day)] = [serv];
    }

    return servicoPorDia;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              color: ColorSys.primary,
              height: 75,
              width: double.infinity,
              padding: const EdgeInsets.all(paddingSmall),
              child: Text(
                "Calendário",
                style: TextStyle(
                    fontSize: fontSizeSubTitle,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    color: Colors.white),
              )),
          StreamBuilder(
            stream:
                DatabaseService(uid: user.uid).diasOcupados(dataSelecionada),
            builder: (context, servicos) {
              if (!servicos.hasData) return LoadPage();

              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          color: ColorSys.primary,
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(20))),
                      child: TableCalendar(
                        events: gerarLista(servicos.data),
                        calendarController: controller,
                        initialCalendarFormat: CalendarFormat.month,
                        formatAnimation: FormatAnimation.slide,
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        availableGestures: AvailableGestures.none,
                        availableCalendarFormats: const {
                          CalendarFormat.month: 'Mês',
                        },
                        onDaySelected: (day, events, holidays) {
                          if (events.isNotEmpty)
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    decoration: background,
                                    height: MediaQuery.of(context).size.height *
                                        0.8,
                                    width: double.infinity,
                                    child: ListView.builder(
                                        itemCount: events.length,
                                        itemBuilder: (ctx, index) {
                                          return FutureBuilder<bool>(
                                              future:
                                                  DatabaseService(uid: user.uid)
                                                      .temMensagem([
                                                'Pendente'
                                              ], events[index].uidCliente),
                                              builder: (context, temMensagem) {
                                                if (!temMensagem.hasData)
                                                  return Container(
                                                    child: null,
                                                  );
                                                return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return InfoServico(
                                                          events[index]);
                                                    }));
                                                  },
                                                  child: Stack(
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.all(
                                                            paddingSmall),
                                                        child: ServicoItem(
                                                          events[index],
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              paddingSmall * 2,
                                                        ),
                                                      ),
                                                      !temMensagem.data
                                                          ? SizedBox.shrink()
                                                          : Positioned(
                                                              left:
                                                                  paddingSmall /
                                                                      2,
                                                              top: 0,
                                                              child: Container(
                                                                padding:
                                                                    EdgeInsets.all(
                                                                        paddingTiny),
                                                                decoration: BoxDecoration(
                                                                    color: ColorSys
                                                                        .primary,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                                child: Text(
                                                                  temMensagem
                                                                          .data
                                                                      ? "Novas mensagens"
                                                                      : "",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                            )
                                                    ],
                                                  ),
                                                );
                                              });
                                        }),
                                  );
                                });
                        },
                        startDay: DateTime.now(),
                        calendarStyle: CalendarStyle(
                            weekdayStyle: TextStyle(color: Colors.white),
                            weekendStyle: TextStyle(color: Colors.white),
                            outsideStyle:
                                TextStyle(color: Colors.white.withOpacity(0.6)),
                            unavailableStyle:
                                TextStyle(color: Colors.white.withOpacity(0.6)),
                            outsideWeekendStyle:
                                TextStyle(color: Colors.white.withOpacity(0.6)),
                            markersColor: Colors.white),
                        daysOfWeekStyle: DaysOfWeekStyle(
                          dowTextBuilder: (date, locale) {
                            return diasDaSemana[date.weekday - 1];
                          },
                          weekdayStyle: TextStyle(color: Colors.white),
                          weekendStyle: TextStyle(color: Colors.white),
                        ),
                        headerStyle: HeaderStyle(
                            titleTextBuilder: (date, locale) {
                              return mesesDoAno[date.month - 1] +
                                  " " +
                                  date.year.toString();
                            },
                            leftChevronIcon: Icon(
                              Icons.chevron_left,
                              color: Colors.white,
                            ),
                            rightChevronIcon: Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                            ),
                            titleTextStyle: TextStyle(
                                color: Colors.white,
                                fontSize: fontSizeRegular * 1.5,
                                fontWeight: FontWeight.bold)),
                        builders: CalendarBuilders(
                          selectedDayBuilder: (context, date, _) {
                            return Container(
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                              margin: const EdgeInsets.all(4.0),
                              width: 100,
                              height: 100,
                              child: Center(
                                child: Text(
                                  '${date.day}',
                                  style: TextStyle(
                                    color: ColorSys.black,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
