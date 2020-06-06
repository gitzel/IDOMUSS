import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class Add_Adress extends StatefulWidget {
  @override
  _Add_AdressState createState() => _Add_AdressState();
}

class _Add_AdressState extends State<Add_Adress> {
  String searchAddr;

  Geolocator geolocator = Geolocator();
  Position userLocation;

  @override
  void initState() {
    super.initState();
    _getLocation().then((position) {
      userLocation = position;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    );
  }

   /*
     onPressed: () {
      _getLocation().then((value) {
        setState(() {
          userLocation = value;
        });
      });
   */
  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  Position searchandNavigate() {
    Position currentLocation;
    Geolocator().placemarkFromAddress(searchAddr).then((result){
        currentLocation = Position(longitude: result[0].position.longitude, latitude: result[0].position.latitude);
    });
    //para o mapa
    /*
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:
              LatLng(result[0].position.latitude, result[0].position.longitude),
          zoom: 10.0)));
    * */

    return currentLocation;
  }
}
