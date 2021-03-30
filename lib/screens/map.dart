import 'dart:async';
import 'dart:ui';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:prampracha_app/myStyle/mystyle.dart';



class MapRoute extends StatefulWidget {
  @override
  _MapRouteState createState() => _MapRouteState();
}

class _MapRouteState extends State<MapRoute> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: MyStyle().colorbg2(),
          centerTitle: true,
          title: Text(
            'แผนที่สถานี',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(18.801213, 99.017280),
            zoom: 20,
          ),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ));
  }
}
