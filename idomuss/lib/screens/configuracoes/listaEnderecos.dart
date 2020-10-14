import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';
import 'package:idomuss/models/endereco.dart';
import 'package:idomuss/screens/configuracoes/addEndereco.dart';
import 'package:idomuss/services/database.dart';

class ListaEnderecos extends StatelessWidget {
  
  List<Endereco> list;
  String uid;
  ListaEnderecos(this.list, this.uid);

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
 Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AdicionarEndereco(),
                                    ));
                },
                child: Text("Você pode adicioná-los clicando aqui!"),
                onLongPress: () {
                  print("a");
                },
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
                          Navigator.pop(context, [LatLng(list[index].location.latitude,list[index].location.longitude), list[index].numero]);
                        },
                        padding: EdgeInsets.all(paddingSmall),
                        child: 
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                            Expanded(
                              child:  Icon(Icons.home, color: ColorSys.primary,),
                              flex: -1,
                            ),
                                Expanded(child: Padding(
                              padding: EdgeInsets.symmetric(horizontal:paddingTiny),
                              child: Text("${list[index].rua}\n${list[index].numero}, ${list[index].complemento} - ${list[index].bairro}, ${list[index].cidade}",
                                  textAlign: TextAlign.center,),
                            ), ),
                               Expanded(
                                 child: IconButton(
                                   icon: Icon(Icons.delete, color: ColorSys.primary,),
                                 
                                    onPressed: (){
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.WARNING,
                                          animType: AnimType.TOPSLIDE,
                                          title: "Deseja mesmo remover este endereço?",
                                          desc: "Após removido, você terá que adicioná-lo novamente para desfazer a ação!",
                                          btnCancelOnPress: () {},
                                          btnOkOnPress: (){
                                            DatabaseService(uid: uid).removeUserAddress(list[index].location);
                                            },
                                          )..show();
                                  
                                    },
                                 ),
                                 flex: -1,
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