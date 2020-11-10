import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:idomussprofissional/helpers/ColorsSys.dart';
import 'package:idomussprofissional/helpers/constantes.dart';
import 'package:idomussprofissional/helpers/loadPage.dart';
import 'package:idomussprofissional/models/servicoContrado.dart';
import 'package:idomussprofissional/services/database.dart';

class AvaliarOrcamento extends StatefulWidget {

  ServicoContratado servicoContratado;

  AvaliarOrcamento(this.servicoContratado);

  @override
  _AvaliarOrcamentoState createState() => _AvaliarOrcamentoState();
}

class _AvaliarOrcamentoState extends State<AvaliarOrcamento> {

  TextEditingController orcamentoController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<int>>(
      stream: DatabaseService(uid: widget.servicoContratado.uidProfissional).limites,
      builder: (context, snapshot) {
        if(!snapshot.hasData)
          return Container(color: Colors.white, child: LoadPage());

        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            decoration: background,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).viewPadding.top,),
                IconButton(
                  icon: Icon(Icons.arrow_back, color: ColorSys.primary, size: 32,),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: paddingSmall),
                  child: AutoSizeText("Descrição do problema",
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: fontSizeSubTitle * 0.75,
                      color: ColorSys.black
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(paddingSmall,),
                  padding: EdgeInsets.all(paddingSmall),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: shadow,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: -1,
                        child: Container(margin: EdgeInsets.only(right: paddingSmall),
                        child: Icon(Icons.description, color: ColorSys.primary,)),
                      ),
                      Expanded(
                        child: Text(
                          widget.servicoContratado.descricao,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                 padding: EdgeInsets.symmetric(horizontal: paddingSmall),
                  child: AutoSizeText("Lembrando que sua cobrança varia de: ",
                    maxLines: 2,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: fontSizeSubTitle * 0.75,
                      color: ColorSys.black
                    ),
                  ),
                ),
               Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(paddingSmall,),
                  padding: EdgeInsets.all(paddingSmall),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: shadow,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: -1,
                        child: Container(margin: EdgeInsets.only(right: paddingSmall),
                        child: Icon(Icons.monetization_on, color: ColorSys.primary,)),
                      ),
                      Expanded(
                        child: Text(
                          "R\$${snapshot.data[0]},00 até R\$${snapshot.data[1]},00",
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                 padding: EdgeInsets.symmetric(horizontal: paddingSmall),
                  child: AutoSizeText("Forneça o orçamento",
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: fontSizeSubTitle * 0.75,
                      color: ColorSys.black
                    ),
                  ),
                ),
                Padding(
                 padding: EdgeInsets.all(paddingSmall),
                  child: TextFormField(
                    keyboardType: TextInputType.numberWithOptions(decimal:true),
                    controller: orcamentoController,
                    decoration: InputDecoration(
                      labelText: "Orçamento",
                      hintText: "R\$XX,00",
                      border:OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: FlatButton(
            disabledColor: ColorSys.secundarygray,
            padding: EdgeInsets.all(paddingLarge),
            child: Text(
              "Enviar orçamento",
              style: TextStyle(color: Colors.white,
                fontSize: fontSizeRegular
              ),
            ),
            color: ColorSys.primary,
            onPressed: orcamentoController.text.isEmpty? null : (){
              
                AwesomeDialog(
                                context: context,
                                dialogType: DialogType.INFO,
                                animType: AnimType.TOPSLIDE,
                                title: 'Confirme o envio do orçamento',
                                desc: 'Ao pressionar OK, seu cliente receberá o orçamento',
                                btnCancelOnPress: () {},
                                btnOkOnPress: (){
                                    DatabaseService(uid: widget.servicoContratado.uidProfissional).sendOrcamento(widget.servicoContratado, orcamentoController.text);
                                    Navigator.popUntil(context,
                                                (route) => route.isFirst);
                                },
                              )..show();
                
            },
          ),
        );
      }
    );
  }
}