import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:idomussprofissional/components/profissiona_info.dart';
import 'package:idomussprofissional/components/radial_progress.dart';
import 'package:idomussprofissional/helpers/ColorsSys.dart';
import 'package:idomussprofissional/helpers/constantes.dart';
import 'package:idomussprofissional/helpers/loadPage.dart';
import 'package:idomussprofissional/models/profissional.dart';
import 'package:idomussprofissional/services/database.dart';
import 'package:provider/provider.dart';

class PerfilPrestador extends StatefulWidget {
  @override
  _PerfilPrestadorState createState() => _PerfilPrestadorState();
}

class _PerfilPrestadorState extends State<PerfilPrestador> {
  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      body: StreamBuilder<Profissional>(
        stream: DatabaseService(uid: user.uid).profissional,
        builder: (context, profissional) {

          if(!profissional.hasData)
            return LoadPage();
          return Column(
                  children: <Widget>[
                    Expanded(
                        flex: 2,
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(profissional.data.foto),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              color: ColorSys.primary.withOpacity(0.6),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: RadialProgress(
                                        width: 4,
                                        goalCompleted: 0.9,
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              profissional.data.foto),
                                          radius: screen.width * 0.15,
                                        ),
                                      ),
                                    ),
                                    profissional.data.vip
                                        ? Positioned(
                                            left:
                                                MediaQuery.of(context).size.width /
                                                        2 +
                                                    60,
                                            top: 0,
                                            child: Image.asset(
                                                "assets/geral/premium_white.png"))
                                        : SizedBox.shrink()
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: paddingSmall),
                                  child: Container(
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        profissional.data.nome,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: fontSizeSubTitle,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: paddingSmall),
                                  child: Container(
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        profissional.data.nomeServico,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: fontSizeRegular,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                           
                          ],
                        )),
                    Expanded(
                      flex: 3,
                      child: Container(
                        color: ColorSys.gray,
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ProfissionalInfo(
                                        profissional.data.nota == -1
                                            ? Align(
                                                alignment: Alignment.center,
                                                child: Text("Não avaliado"))
                                            : Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceEvenly,
                                                children: [
                                                    Icon(
                                                      Icons.star,
                                                      color: ColorSys.primary,
                                                    ),
                                                    Text(
                                                      profissional.data.nota
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: fontSizeRegular),
                                                    )
                                                  ]),
                                      )),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ProfissionalInfo(
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              profissional.data.servicosPrestados
                                                  .toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: ColorSys.black,
                                                fontSize: fontSizeRegular,
                                              ),
                                            ),
                                            Text(
                                              "serviços",
                                              style: TextStyle(
                                                color: ColorSys.black,
                                              ),
                                            )
                                          ],
                                        ),
                                      )),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ProfissionalInfo(
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(
                                              Icons.favorite,
                                              color: ColorSys.primary,
                                            ),
                                            Text(
                                              profissional.data.curtidas.toString(),
                                              style: TextStyle(
                                                  fontSize: fontSizeRegular),
                                            )
                                          ],
                                        ),
                                      )),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(paddingSmall),
                              child: ProfissionalInfo(
                                Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(
                                    Icons.monetization_on,
                                    color: ColorSys.primary,
                                  ),
                                  Text(
                                    "R\$" +
                                        profissional.data.limite[0]
                                            .toStringAsFixed(2) +
                                        " ~ " +
                                        profissional.data.limite[1]
                                            .toStringAsFixed(2),
                                    style: TextStyle(
                                        color: ColorSys.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              )),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: paddingSmall, vertical: paddingTiny),
                              child: RaisedButton(
                                 padding: EdgeInsets.all(paddingSmall),
                                child: Row(
                                  children: [
                                    Expanded(flex: -1, child: Icon(Icons.location_on)),
                                    Expanded(child: Text("Alterar localização"))
                                  ],
                                ),
                                onPressed: (){
                                  
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: paddingSmall, vertical: paddingTiny),
                              child: RaisedButton(
                                padding: EdgeInsets.all(paddingSmall),
                                child: Row(
                                  children: [
                                    Expanded(flex: -1, child: Icon(Icons.person)),
                                    Expanded(child: Text("Alterar perfil"))
                                  ],
                                ),
                                onPressed: (){
                                  
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: paddingSmall, vertical: paddingTiny),
                              child: RaisedButton(
                                padding: EdgeInsets.all(paddingSmall),
                                child: Row(
                                  children: [
                                    Expanded(flex: -1, child: Icon(Icons.settings)),
                                    Expanded(child: Text("Configurações"))
                                  ],
                                ),
                                onPressed: (){
                                  
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
        }
      )
    );
  }
}
