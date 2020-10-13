import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';
import 'package:idomuss/screens/home/busca.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:search_cep/search_cep.dart';

class MapaLocalizacao extends StatefulWidget {
  
  @override
  _MapaLocalizacaoState createState() => _MapaLocalizacaoState();
}

class _MapaLocalizacaoState extends State<MapaLocalizacao> {

  Set<Marker> markers = new Set<Marker>();
  
  String rua, bairro, numero;
  LatLng latLng;

  @override
  void initState() {
    super.initState();
    rua = bairro = numero = "";
  }
  void getAdress(pos) async{
    var placemarkers = await placemarkFromCoordinates(pos.latitude, pos.longitude);
    setState(() {
        rua = placemarkers.first.street;
        bairro = placemarkers.first.subLocality;
        numero = placemarkers.first.name;
    });
   
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(elevation: 0,),
      body: FutureBuilder<Position>(
        future: getCurrentPosition(desiredAccuracy: LocationAccuracy.high),
        builder: (context, pos) {
          if(!pos.hasData)
            return LoadPage();

          return FutureBuilder<List<Placemark>>(
            future: placemarkFromCoordinates(pos.data.latitude,pos.data.longitude),
            builder: (context, placemarks) {

              if(!placemarks.hasData)
                return LoadPage();

              if(rua.isEmpty){
                rua = placemarks.data[0].street;
                bairro = placemarks.data[0].subLocality;
              }
                

              return Column(children: [
                 Expanded(
                        flex: -1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal:paddingSmall, vertical:paddingTiny),
                          child: Container(
                            width: double.infinity,
                            decoration: box,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.location_on, color: ColorSys.primary,),
                                ),
                                Flexible(child: Text(rua + " - " + bairro))
                              ],
                            ),
                          ),
                        ),
                      ),
                Expanded(
                  child: GoogleMap(
                            myLocationEnabled: true,
                            tiltGesturesEnabled: false,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(pos.data.latitude, pos.data.longitude),
                              zoom: 15.0
                            ),
                            onTap: (LatLng pos){
                              final Marker marker = Marker(
                                markerId: MarkerId("position"),
                                position: pos,
                              );
                               setState(() {
                                markers.add(marker);
                                latLng = LatLng(pos.latitude, pos.longitude);
                                getAdress(pos);
                              });
                            },
                            markers: markers,
                            
                          ),
                ),
                Expanded(
                  flex: -1,
                  child: Padding(padding: EdgeInsets.all(paddingSmall),
                  child: RaisedButton(
                    child: Text("Salvar"),
                    onPressed: (){
                      Navigator.pop(context, [latLng, numero]);
                    },
                  ),),
                )
              ],);
            }
          );
        }
      ),
    );
  }
}