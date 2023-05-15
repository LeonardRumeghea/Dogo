import 'dart:async';
import 'dart:math';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import '../../../Helpers/constants.dart' as constants;
import '../../entities/address.dart';

class PageLocationPicker extends StatefulWidget {
  const PageLocationPicker({Key? key}) : super(key: key);

  @override
  State<PageLocationPicker> createState() => _PageLocationPickerState();
}

class _PageLocationPickerState extends State<PageLocationPicker> {
  // map variables and controllers
  final Completer<GoogleMapController> _googleMapController = Completer();
  CameraPosition? _cameraPosition;
  late LatLng _initialLatLng;
  late LatLng _currentLatLng;

  String _selectedAddressStr = '';
  double _zoomLevel = 17;

  final double _maxZoomLevel = 20;
  final double _minZoomLevel = 3;

  // final result - selected address from map
  Address _selectedAddress = Address();

  String _darkMapStyle = '';

  @override
  void initState() {
    super.initState();
    init();
    _loadMapStyles().then((value) => _googleMapController.future
        .then((controller) => controller.setMapStyle(_darkMapStyle)));
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

  Future _loadMapStyles() async {
    _darkMapStyle =
        await rootBundle.loadString('assets/json/dark_mode_map.json');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context, _selectedAddress),
        backgroundColor: constants.MyColors.darkBlue,
        child: const Icon(Icons.done, color: Colors.white),
      ),
      body: buildBody(size),
    );
  }

  Widget buildBody(Size size) {
    return Stack(
      children: [
        showMap(),
        showMapZoomControlls(size),
        showMarker(size),
        showAddress(size),
      ],
    );
  }

  Widget showMap() {
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

  Widget showMapZoomControlls(Size size) {
    return Positioned(
      top: size.height * .175,
      left: size.width * .025,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: constants.MyColors.darkBlue,
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 66, 66, 66).withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        width: size.width * .11,
        height: size.height * .131,
        child: Center(
          child: Column(
            children: <Widget>[
              IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () async {
                    _zoomLevel += _zoomLevel > _maxZoomLevel ? 0 : 0.5;
                    refreshMap();
                  }),
              const SizedBox(height: 2),
              IconButton(
                  icon: const Icon(Icons.remove, color: Colors.white),
                  onPressed: () async {
                    _zoomLevel -= _zoomLevel < _minZoomLevel ? 0 : 0.5;
                    refreshMap();
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void refreshMap() {
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
  }

  Widget showMarker(Size size) {
    return Center(
      child: IgnorePointer(
        child: SizedBox(
          width: min(size.width, size.height) * .30,
          height: min(size.width, size.height) * .30,
          child: Lottie.asset('assets/icons/map_marker.json'),
        ),
      ),
    );
  }

  Widget showAddress(Size size) {
    return SafeArea(
      child: Center(
        heightFactor: 1.25,
        child: Container(
          width: size.width * .9,
          height: size.height * .09,
          decoration: const BoxDecoration(
            color: constants.MyColors.darkBlue,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: constants.MyColors.blackBlue,
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: Center(
            child: Text(
              _selectedAddressStr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Future getAddress(LatLng position) async {
    // list all addresses around the position
    var placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    var address = placemarks[0];

    var addressStr =
        '${address.thoroughfare} ${address.subThoroughfare}, ${address.postalCode}';

    var addressEntity = Address(
        street:
            '${address.thoroughfare!} ${int.parse(address.subThoroughfare!)}',
        city: address.locality!,
        state: address.administrativeArea!,
        zipCode: address.postalCode!,
        latitude: _currentLatLng.latitude,
        longitude: _currentLatLng.longitude);

    developer.log('LocationPicker: Address: $addressEntity');

    setState(() {
      _selectedAddressStr = addressStr;
      _selectedAddress = addressEntity;
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
        zoom: _zoomLevel,
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
  }
}
