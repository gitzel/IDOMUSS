import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';
import 'package:idomuss/models/profissional.dart';
import 'package:idomuss/models/servicoContratado.dart';
import 'package:idomuss/screens/home/busca.dart';
import 'package:idomuss/services/database.dart';

class ServicoItem extends StatefulWidget {
  ServicoContratado servico;
  double width, height;
  ServicoItem(this.servico, {this.width = null, this.height = null});

  @override
  _State createState() => _State();
}

class _State extends State<ServicoItem> with TickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget getFrase() {
    var frase = "";
    switch (widget.servico.situacao) {
      case "Solicitando":
        frase = "Aguardando orçamento";
        break;
      case "Analisando":
        frase = "Aprove ou não o orçamento";
        break;
      case "Pendente":
        frase =
            "${widget.servico.data.day.toString().padLeft(2, '0')}/${widget.servico.data.month.toString().padLeft(2, '0')}/${widget.servico.data.year} ${widget.servico.data.hour.toString().padLeft(2, '0')}:${widget.servico.data.minute.toString().padLeft(2, '0')}";
        break;
    }

    return Text(
      frase,
      style: TextStyle(
          fontSize: fontSizeSmall,
          fontWeight: FontWeight.bold,
          color: ColorSys.black),
    );
  }

  IconData getIcon() {
    switch (widget.servico.situacao) {
      case "Solicitando":
        return Icons.monetization_on;
        break;
      case "Analisando":
        return Icons.timer;
        break;
      case "Pendente":
        return Icons.info;
        break;
      default:
        return Icons.ac_unit;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Profissional>(
        stream:
            DatabaseService().getProfissional(widget.servico.uidProfissional),
        builder: (context, cliente) {
          if (!cliente.hasData)
            return Container(
              decoration: BoxDecoration(
                  color: ColorSys.gray,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: shadow),
              child: LoadPage(),
            );

          return FutureBuilder<List<Placemark>>(
              future: placemarkFromCoordinates(
                  widget.servico.localizacao.latitude,
                  widget.servico.localizacao.longitude),
              builder: (context, localizacao) {
                if (!localizacao.hasData)
                  return Container(
                    decoration: BoxDecoration(
                        color: ColorSys.gray,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: shadow),
                    child: LoadPage(),
                  );
                return Container(
                  width: widget.width == null
                      ? MediaQuery.of(context).size.width
                      : widget.width,
                  decoration: BoxDecoration(
                      color: ColorSys.gray,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: shadow),
                  padding: EdgeInsets.all(paddingSmall),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: -1,
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: shadow,
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(cliente.data.foto),
                            backgroundColor: Colors.white,
                            radius: MediaQuery.of(context).size.width * 0.1,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: paddingSmall),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      cliente.data.nome,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: ColorSys.black),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: ColorSys.primary,
                                          size: fontSizeSmall,
                                        ),
                                        Flexible(
                                          child: Text(
                                            localizacao.data.first.street +
                                                "\nNº ${widget.servico.numero}, ${widget.servico.complemento}",
                                            style: TextStyle(
                                                fontSize: fontSizeSmall / 1.5,
                                                color: ColorSys.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                getFrase()
                              ],
                            ),
                          ),
                        ),
                      ),
                      Icon(
                        getIcon(),
                        color: ColorSys.primary,
                      )
                    ],
                  ),
                );
              });
        });
  }
}
