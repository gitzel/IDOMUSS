import 'package:firebase_admin/firebase_admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:idomuss/components/textFieldOutline.dart';
import 'package:idomuss/components/titulo_cadastro.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';
import 'package:idomuss/models/endereco.dart';
import 'package:idomuss/screens/home/busca.dart';
import 'package:idomuss/screens/home/mapaLocalizacao.dart';
import 'package:idomuss/services/database.dart';
import 'package:provider/provider.dart';

class Enderecos extends StatefulWidget {

  LatLng pos;
  Placemark location;
  Enderecos(this.pos, this.location);

  @override
  _EnderecosState createState() => _EnderecosState();
}

class _EnderecosState extends State<Enderecos> {

 

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      appBar: AppBar(elevation: 0,),
      body: StreamBuilder<List<Endereco>>(
        stream: DatabaseService(uid: user.uid).enderecosFromCliente,
        builder: (context, snapshot) {

          return SingleChildScrollView(
                      child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(paddingSmall),
                  child: TextFormField(
                      readOnly: true,
                      onTap: (){
                         Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MapaLocalizacao(widget.pos, widget.location),
                                    ));
                      },
                      decoration: InputDecoration(
                        hintText: "Digite seu endereço e número",
                        prefixIcon: Icon(Icons.search),
                        fillColor: ColorSys.lightGray,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              width: 0, 
                              style: BorderStyle.none,
                          ),
                                               
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(paddingSmall),
                  child: RaisedButton(
                    onPressed: (){
                      Navigator.pop(context, null);
                    },
                    padding: EdgeInsets.all(paddingSmall),
                    child: 
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                         Icon(Icons.my_location, color: Colors.white,),
                           Column(children: [
                              Text("Localização atual", style: TextStyle(fontWeight: FontWeight.bold),),
                              Text(widget.location.street + ", " + widget.location.subLocality)
                            ],
                          )
                        ],
                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(paddingSmall),
                  child: Text("Endereços salvos",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                  ),
                  )
                ),  
                ListaEnderecos(snapshot.data)
              ],
            ),
          );
        }
      ),
    );
  }

}

class ListaEnderecos extends StatelessWidget {
  
  List<Endereco> list;

  ListaEnderecos(this.list);

  @override
  Widget build(BuildContext context) {
    if(list == null || list.isEmpty)
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            //TODO add img
            Padding(
              padding: const EdgeInsets.all(paddingSmall),
              child: Text("Infelizmente você ainda não adicionou nenhum endereço!", textAlign: TextAlign.center,),
            ),
            RaisedButton(
                onPressed: (){

                },
                child: Text("Você pode adicioná-los clicando aqui!"),
              ),
    
          ],
        ),
      );
    
    return  Container(
       height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          itemCount: list.length,
          shrinkWrap: true,
          itemBuilder: (ctx, index){
            return Padding(
                      padding: const EdgeInsets.all(paddingSmall),
                      child: RaisedButton(
                        color: ColorSys.lightGray,
                        onPressed: (){
                          
                        },
                        padding: EdgeInsets.all(paddingSmall),
                        child: 
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                             Icon(Icons.home, color: ColorSys.primary,),
                               Column(children: [
                                  Text(list[index].filtro, style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text(list[index].rua + ", " + list[index].bairro)
                                ],
                              )
                            ],
                          )
                      ),
            );
          },
        ),

    );
  }
}