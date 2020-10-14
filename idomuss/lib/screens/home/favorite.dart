import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:idomuss/components/profissional_item.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';
import 'package:idomuss/models/profissional.dart';
import 'package:idomuss/screens/home/busca.dart';
import 'package:idomuss/screens/home/profissional_perfil.dart';
import 'package:idomuss/services/database.dart';
import 'package:provider/provider.dart';

class Favorite extends StatefulWidget {
  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    return Container(
      decoration: BoxDecoration(color: ColorSys.primary),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(paddingSmall,
                2 * paddingExtraLarge, paddingSmall, paddingSmall),
            child: Text(
              "Favoritos",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSizeSubTitle,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 226.0,
            decoration: BoxDecoration(
              color: ColorSys.gray,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
            ),
            child: StreamBuilder<List<Profissional>>(
                stream: DatabaseService(uid: user.uid).profissionaisPreferidos,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return LoadPage();

                  if (snapshot.data.isEmpty)
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                            child:
                                Image.asset("assets/geral/no_favorites.png")),
                        Padding(
                          padding: EdgeInsets.fromLTRB(paddingSmall,
                              paddingMedium, paddingSmall, paddingSmall),
                          child: Text(
                            "Você ainda não favoritou profissional algum!",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: paddingSmall),
                          child: Text(
                            "Selecione o icone central para conhecer os melhores trabalhadores perto de você!",
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    );

                  final profissionais = snapshot.data;
                  profissionais.sort((a, b) =>
                      a.nomeServico.toString().compareTo(b.nomeServico));

                  List<Profissional> vips = new List<Profissional>();
                  double height = MediaQuery.of(context).size.height * 0.2;
                  int indiceColor = 0;
                  profissionais.removeWhere((element) {
                    element.favoritado = true;
                    if (element.vip) vips.add(element);
                    return element.vip;
                  });

                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 75,
                        ),
                        vips.length <= 0
                            ? SizedBox.shrink()
                            : Padding(
                                padding:
                                    const EdgeInsets.only(left: paddingSmall),
                                child: Text(
                                  "Premium",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: fontSizeRegular),
                                ),
                              ),
                        vips.length <= 0
                            ? SizedBox.shrink()
                            : Container(
                                height: height,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: vips.length,
                                  itemBuilder: (context, index) {
                                    if (indiceColor > 5) indiceColor = 0;
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: paddingMedium,
                                          vertical: paddingSmall),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PerfilPrestador(
                                                        vips[index]),
                                              ));
                                        },
                                        child: ProfissionalItem(
                                          vips[index],
                                          vips[index].favoritado,
                                          true,
                                          height,
                                          () {
                                            if (!vips[index].favoritado)
                                              DatabaseService(uid: user.uid)
                                                  .addFavoritos(vips[index].uid)
                                                  .then((value) {
                                                setState(() {
                                                  vips[index].favoritado =
                                                      !vips[index].favoritado;
                                                });
                                              });
                                            else
                                              DatabaseService(uid: user.uid)
                                                  .removerFavoritos(
                                                      vips[index].uid)
                                                  .then((value) {
                                                setState(() {
                                                  vips[index].favoritado =
                                                      !vips[index].favoritado;
                                                });
                                              });
                                          },
                                          colorPremium: indiceColor++,
                                          uidUser: user.uid,
                                          servico: vips[index].nomeServico,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: profissionais.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: paddingMedium,
                                    vertical: paddingSmall),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PerfilPrestador(
                                              profissionais[index]),
                                        ));
                                  },
                                  child: ProfissionalItem(
                                    profissionais[index],
                                    profissionais[index].favoritado,
                                    false,
                                    height,
                                    () {
                                      if (!profissionais[index].favoritado)
                                        DatabaseService(uid: user.uid)
                                            .addFavoritos(
                                                profissionais[index].uid)
                                            .then((value) {
                                          setState(() {
                                            profissionais[index].favoritado =
                                                !profissionais[index]
                                                    .favoritado;
                                          });
                                        });
                                      else
                                        DatabaseService(uid: user.uid)
                                            .removerFavoritos(
                                                profissionais[index].uid)
                                            .then((value) {
                                          setState(() {
                                            profissionais[index].favoritado =
                                                !profissionais[index]
                                                    .favoritado;
                                          });
                                        });
                                    },
                                    uidUser: user.uid,
                                    servico: profissionais[index].nomeServico,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ]);
                }),
          )
        ],
      ),
    );
  }
}
