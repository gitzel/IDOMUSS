import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:search_cep/search_cep.dart';

class MapaLocalizacao extends StatefulWidget {
  
  LatLng pos;
  Placemark placemark;
  MapaLocalizacao(this.pos, this.placemark);

  @override
  _MapaLocalizacaoState createState() => _MapaLocalizacaoState();
}

class _MapaLocalizacaoState extends State<MapaLocalizacao> {

  Set<Marker> markers = new Set<Marker>();
  List<Placemark> placemarks = new List();
  bool readOnlyText = true;
  TextEditingController controllerText;
  var maskCEP = new MaskTextInputFormatter(
      mask: '#####-### ', filter: {"#": RegExp(r'[0-9]')});

  getPlaces(Marker marker) async{
    placemarks = await placemarkFromCoordinates(marker.position.latitude, marker.position.longitude);
    controllerText = TextEditingController(text: placemarks[0].postalCode);
  }
  
  getPosition(String cep) async{
    cep = cep.replaceAll('-', "");
    var endereco = await ViaCepSearchCep().searchInfoByCep(cep: cep);
   
    endereco.fold(
    (exception) {}, 
    (tokenModel) async{
      List<Location> locations = await locationFromAddress("${tokenModel.logradouro}, ${tokenModel.localidade}");
      final Marker marker = Marker(
                        markerId: MarkerId("position"),
                        position: LatLng(locations.first.latitude,locations.first.latitude),
                      );
      setState(() {
        markers.add(marker);
        getPlaces(marker);
      });
    }
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    placemarks.add(widget.placemark);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(elevation: 0,),
      body: Column(children: [
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
                        Flexible(child: Text(placemarks[0].street + " - " + placemarks[0].subLocality))
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
                      target: LatLng(widget.pos.latitude, widget.pos.longitude),
                      zoom: 15.0
                    ),
                    onTap: (LatLng pos){
                      final Marker marker = Marker(
                        markerId: MarkerId("position"),
                        position: pos,
                      );
                       setState(() {
                        markers.add(marker);
                        getPlaces(marker);
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
            onPressed: (){},
          ),),
        )
      ],),
    );
  }
}