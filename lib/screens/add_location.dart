
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hunarmand_app/screens/place_order.dart';

import 'package:search_map_place_updated/search_map_place_updated.dart';

const String apiKEY = "AIzaSyAnwvNqlOi62hWaoXAPWXc0VtiO3ouQ0Rc";


String lat = "0";
String lang = "0";



class AddLocation extends StatefulWidget {
  @override
  State<AddLocation> createState() => MapSampleState();
}

class MapSampleState extends State<AddLocation> with SingleTickerProviderStateMixin {
  Completer<GoogleMapController> _mapController = Completer();

  LatLng latLng = LatLng(0, 0);
  String? _mapStyle;
  List<LatLng> _polylinePoints = [];
  Set<Marker> _markers = {};

  AnimationController? _ac;
  Animation<Offset>? _animation;

  Place? _selectedPlace;

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value){
    }).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR"+error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  final List<Marker> _markerss = <Marker>[
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(34.0289432712712, 71.44598928191954),
        infoWindow: InfoWindow(
          title: 'My Position',
        )
    ),
  ];

  bool load = false;
  final CameraPosition _initialCamera = CameraPosition(
    target: LatLng(34.0289432712712, 71.44598928191954),
    zoom: 14,
  );

  @override
  void initState() {
    super.initState();

    // Loads MapStyle file

    //
    _ac = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 750),
    );
    _animation = Tween<Offset>(
      begin: Offset(-1.0, 2.75),
      end: Offset(0.05, 2.75),
    ).animate(CurvedAnimation(
      curve: Curves.easeOut,
      parent: _ac!,
    ));

    setState(() {
      load = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:load ?  Stack(
        children: <Widget>[
          // Map widget
          GoogleMap(
            initialCameraPosition: _initialCamera,
            onMapCreated: (GoogleMapController controller) async {
              _mapController.complete(controller);
            },
          ),

          // SearchMapPlace widget
          Positioned(
            top: 60,
            left: MediaQuery.of(context).size.width * 0.05,
            child: SearchMapPlaceWidget(
              apiKey: apiKEY,
              icon: IconData(0xE8BD, fontFamily: 'feather'),
              clearIcon: IconData(0xE8F6, fontFamily: 'feather'),
              iconColor: Colors.teal[200]!.withOpacity(0.8),
              placeType: PlaceType.establishment,
              location: _initialCamera.target,
              radius: 30000,
              onSelected: (place) async {
                final geolocation = await place.geolocation;


                // Adding marker to the selected location using a custom icon.


                final GoogleMapController controller = await _mapController.future;
                setState((){
                  _selectedPlace = place;
                });

                final res = geolocation!.coordinates;
                latLng = res;

                lat = latLng.latitude.toString();
                lang = latLng.longitude.toString();


                // Animates the Google Maps camera
                controller.animateCamera(CameraUpdate.newLatLng(geolocation!.coordinates));
                controller.animateCamera(CameraUpdate.newLatLngBounds(geolocation.bounds, 100));

                // Animates the "start route" box in to the screen
                _ac!.forward();
              },
            ),
          ),

          Positioned(
            bottom: 60,
            left: MediaQuery.of(context).size.width * 0.05,
            child: Row(

              children: [
                ElevatedButton(
                  onPressed: (){
                    Get.back();
                  },
                  child: Text("Pick Location"),
                ),
                SizedBox(width: 30,),
                ElevatedButton(
                  onPressed: (){
                    getUserCurrentLocation().then((value) async {


                      final marker2 = Marker(
                        markerId: MarkerId("2"),
                        position: LatLng(value.latitude, value.longitude),
                        icon: BitmapDescriptor.defaultMarker,
                        infoWindow: InfoWindow(
                          title: 'My Current Location',
                        ),
                      );
                      setState(() {
                        _markerss.add(marker2);
                      });

                      // specified current users location
                      CameraPosition cameraPosition = new CameraPosition(
                        target: LatLng(value.latitude, value.longitude),
                        zoom: 14,
                      );

                      lat = value.latitude.toString();
                      lang = value.longitude.toString();
                      final GoogleMapController controller = await _mapController.future;
                      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
                      setState(() {
                      });
                    });
                  },
                  child: Text("Current Location"),
                ),
              ],
            ),
          ),

          // Box that will be animated in to the screen when user selects place.

        ],
      ) : Center(child: CircularProgressIndicator(),),
    );
  }

  // Widget confirmationBox() {
  //   return SlideTransition(
  //     position: _animation!,
  //     child: Container(
  //       width: MediaQuery.of(context).size.width * 0.9,
  //       padding: const EdgeInsets.all(20),
  //       height: 200,
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(15),
  //         boxShadow: [
  //           BoxShadow(
  //             blurRadius: 10,
  //             color: Colors.black12,
  //             spreadRadius: 15.0,
  //           ),
  //         ],
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: <Widget>[
  //         ],
  //       ),
  //     ),
  //   );
  // }
}