import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapIntegration extends StatefulWidget {
  @override
  _MapIntegrationState createState() => _MapIntegrationState();
}

class _MapIntegrationState extends State<MapIntegration> {
  GoogleMapController? mapController;
  LatLng _center = const LatLng(45.521563, -122.677433); // Default center
  late LatLng _lastMapPosition = _center;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Integration'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        onCameraMove: _onCameraMove,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (mapController != null) {
            mapController!.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: _lastMapPosition,
                  zoom: 14.0,
                ),
              ),
            );
          }
        },
        label: Text('Go to Last Position'),
        icon: Icon(Icons.location_pin),
      ),
    );
  }
}
