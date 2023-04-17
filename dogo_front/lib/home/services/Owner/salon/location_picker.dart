import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import '../../../../../Helpers/constants.dart' as constants;

class PageLocationPicker extends StatefulWidget {
  const PageLocationPicker({Key? key}) : super(key: key);

  @override
  _PageLocationPickerState createState() => _PageLocationPickerState();
}

class _PageLocationPickerState extends State<PageLocationPicker> {
  final Completer<GoogleMapController> _googleMapController = Completer();
  CameraPosition? _cameraPosition;
  late LatLng _initialLatLng;
  late LatLng _currentLatLng;

  String _selectedAddress = '';
  double _zoomLevel = 17;

  @override
  void initState() {
    init();
    super.initState();
  }

  init() {
    // default map location is Palas Iasi
    _initialLatLng = const LatLng(47.157665, 27.58954);

    // set camera position to Palas Iasi with zoom 17.5
    _cameraPosition = CameraPosition(
      target: _initialLatLng,
      zoom: _zoomLevel,
    );

    // move map to user current location
    moveToUserCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // moveToUserCurrentLocation();
          Navigator.pop(context, _selectedAddress);
        },
        backgroundColor: constants.Colors.darkBlue,
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
      body: buildBody(size),
    );
  }

  Widget buildBody(Size size) {
    return Stack(
      children: [
        getMap(),
        mapZoomControlls(size),
        getMarker(size),
        showAddress(size),
      ],
    );
  }

  Widget getMap() {
    return GoogleMap(
        initialCameraPosition: _cameraPosition!,
        mapType: MapType.normal,
        zoomControlsEnabled: false,
        tiltGesturesEnabled: false,
        onCameraIdle: () => getAddress(_currentLatLng),
        onCameraMove: (CameraPosition position) =>
            _currentLatLng = position.target,
        onMapCreated: (GoogleMapController controller) {
          if (!_googleMapController.isCompleted) {
            _googleMapController.complete(controller);
          }
        });
  }

  Widget mapZoomControlls(Size size) {
    return Positioned(
      top: size.height * .125,
      left: size.width * .025,
      child: Card(
        elevation: 2,
        child: Container(
          color: constants.Colors.grey,
          width: size.width * .1,
          height: size.height * .131,
          child: Column(
            children: <Widget>[
              IconButton(
                  icon: const Icon(Icons.add),
                  hoverColor: constants.Colors.dustBlue,
                  onPressed: () async {
                    _zoomLevel += _zoomLevel > 20 ? 0 : 1;

                    _googleMapController.future.then((controller) {
                      controller.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: _currentLatLng,
                            zoom: _zoomLevel,
                          ),
                        ),
                      );
                    });
                  }),
              const SizedBox(height: 2),
              IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () async {
                    _zoomLevel -= _zoomLevel < 5 ? 0 : 1;

                    _googleMapController.future.then((controller) {
                      controller.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: _currentLatLng,
                            zoom: _zoomLevel,
                          ),
                        ),
                      );
                    });
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget getMarker(Size size) {
    return Center(
      child: SizedBox(
        width: min(size.width, size.height) * .75,
        height: min(size.width, size.height) * .75,
        child: Lottie.asset('assets/icons/marker.json'),
      ),
    );
  }

  Widget showAddress(Size size) {
    return SafeArea(
      child: Container(
        width: size.width,
        height: size.height * .075,
        decoration: const BoxDecoration(
          color: constants.Colors.blackBlue,
        ),
        child: Center(
          child: Text(
            _selectedAddress,
            style: const TextStyle(
              color: constants.Colors.grey,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }

  Future getAddress(LatLng position) async {
    // list all addresses around the position
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark address = placemarks[0];
    String addressStr = '${address.street}, ${address.locality}';

    setState(() {
      _selectedAddress = addressStr;
    });
  }

  Future moveToUserCurrentLocation() async {
    Position position = await getCurrentLocation();
    goToPostion(LatLng(position.latitude, position.longitude));
  }

  Future goToPostion(LatLng position) async {
    final GoogleMapController controller = await _googleMapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: position,
        zoom: 17.5,
      ),
    ));

    getAddress(position);
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return position;

    // LatLng location = LatLng(position.latitude, position.longitude);

    // setState(() {
    //   initialLatLng = location;
    //   isLocationSet = true;
    // });
  }
}
