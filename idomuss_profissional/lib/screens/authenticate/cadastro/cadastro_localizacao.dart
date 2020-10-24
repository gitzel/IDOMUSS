import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:idomussprofissional/components/textFieldOutline.dart';
import 'package:idomussprofissional/components/titulo_cadastro.dart';
import 'package:idomussprofissional/helpers/ColorsSys.dart';
import 'package:idomussprofissional/helpers/constantes.dart';
import 'package:idomussprofissional/helpers/loadPage.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:search_cep/search_cep.dart';

class CadastroLocalizacao extends StatefulWidget {
  @override
  _CadastroLocalizacaoState createState() => _CadastroLocalizacaoState();
}

class _CadastroLocalizacaoState extends State<CadastroLocalizacao> {
  GoogleMapController mapController;
  double lat = -23.1134553, lng = -47.5248015;
  bool readOnlyText = true;
  Set<Marker> markers = new Set<Marker>();
  List<Placemark> placemarks = [Placemark(name: "")];
  TextEditingController controllerText;

  var maskCEP = new MaskTextInputFormatter(
      mask: '#####-### ', filter: {"#": RegExp(r'[0-9]')});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readOnlyText = true;
    getUserLocation();
  }

  getUserLocation() async {
    LocationPermission status = await checkPermission();
    if (status.index == 0)
      LocationPermission permission = await requestPermission();
    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    lat = position.latitude;
    lng = position.longitude;
    placemarks = await placemarkFromCoordinates(lat, lng);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: StreamBuilder<Position>(
          stream: getPositionStream(desiredAccuracy: LocationAccuracy.high),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LoadPage();

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: paddingSmall,
                      top: paddingExtraLarge,
                      right: paddingSmall),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BackButton(color: ColorSys.primary),
                      IconButton(
                        icon: Icon(
                          Icons.help,
                          color: ColorSys.primary,
                        ),
                        onPressed: () {},
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: paddingSmall),
                  child: TextCadastro("Onde você costuma atuar?"),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: paddingSmall, vertical: paddingTiny),
                    child: Container(
                      width: double.infinity,
                      decoration: box,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.location_on,
                              color: ColorSys.primary,
                            ),
                          ),
                          Flexible(
                              child: Text(placemarks[0].street ??
                                  "" + " - " + placemarks[0].subLocality ??
                                  ""))
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: paddingSmall, vertical: paddingTiny),
                    child: Container(
                      width: double.infinity,
                      decoration: box,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.location_city,
                              color: ColorSys.primary,
                            ),
                          ),
                          Flexible(
                              child: Text(placemarks[0].subAdministrativeArea ??
                                  "" +
                                      ", " +
                                      placemarks[0].administrativeArea ??
                                  ""))
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: paddingSmall, vertical: paddingTiny),
                    child: Container(
                        width: double.infinity,
                        decoration: box,
                        child: InkWell(
                          onDoubleTap: () {
                            setState(() {
                              readOnlyText = false;
                            });
                          },
                          child: TextFormField(
                            controller: controllerText,
                            readOnly: readOnlyText,
                            inputFormatters: [maskCEP],
                            maxLength: 9,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.confirmation_number,
                                  color: ColorSys.primary),
                              counterText: '',
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                          ),
                        )),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: GoogleMap(
                      myLocationEnabled: true,
                      tiltGesturesEnabled: false,
                      initialCameraPosition:
                          CameraPosition(target: LatLng(lat, lng), zoom: 15.0),
                      onTap: (LatLng pos) {
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
                ),
              ],
            );
          }),
      bottomNavigationBar: FlatButton(
        disabledColor: ColorSys.secundarygray,
        padding: EdgeInsets.all(paddingLarge),
        child: Text(
          "Continuar",
          style: TextStyle(color: Colors.white),
        ),
        color: ColorSys.primary,
        onPressed: () {},
      ),
    );
  }

  getPlaces(Marker marker) async {
    placemarks = await placemarkFromCoordinates(
        marker.position.latitude, marker.position.longitude);
    controllerText = TextEditingController(text: placemarks[0].postalCode);
  }

  getPosition(String cep) async {
    cep = cep.replaceAll('-', "");
    var endereco = await ViaCepSearchCep().searchInfoByCep(cep: cep);

    endereco.fold((exception) {}, (tokenModel) async {
      List<Location> locations = await locationFromAddress(
          "${tokenModel.logradouro}, ${tokenModel.localidade}");
      final Marker marker = Marker(
        markerId: MarkerId("position"),
        position: LatLng(locations.first.latitude, locations.first.latitude),
      );
      setState(() {
        markers.add(marker);
        getPlaces(marker);
      });
    });
  }
}
