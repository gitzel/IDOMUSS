import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Add_Adress extends StatefulWidget {
  @override
  _Add_AdressState createState() => _Add_AdressState();
}

class _Add_AdressState extends State<Add_Adress> {
  String searchAddr;

  Geolocator geolocator = Geolocator();

  Position userLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[
            Positioned(
              top: 30.0,
              right: 15.0,
              left: 15.0,
              child: Container(
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0), color: Colors.white),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: 'Enter Address',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                      suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            searchandNavigate();
                            print(userLocation);
                          },
                          iconSize: 30.0)),
                  onChanged: (val) {
                    setState(() {
                      searchAddr = val;
                    });
                  },
                ),
              ),
            )
          ],
        ));
  }

  searchandNavigate() {
    Geolocator().placemarkFromAddress(searchAddr).then((result){
      userLocation = Position(longitude: result[0].position.longitude, latitude: result[0].position.latitude);
    });
    //para o mapa
    /*
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:
              LatLng(result[0].position.latitude, result[0].position.longitude),
          zoom: 10.0)));
          Geolocator().placemarkFromAddress(searchAddr).then((result) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:
          LatLng(result[0].position.latitude, result[0].position.longitude),
          zoom: 10.0)));
    });
    * */
  }
}
