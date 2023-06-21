import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:lottie/lottie.dart' as lt;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../Helpers/constants.dart' as constants;
import '../../entities/address.dart';
import '../config.dart';

class PageLocationViewer extends StatefulWidget {
  const PageLocationViewer(
      {Key? key, required this.pickUpAddress, this.destinationAddress})
      : super(key: key);

  final Address pickUpAddress;
  final Address? destinationAddress;

  @override
  State<PageLocationViewer> createState() => _PageLocationViewerState();
}

class _PageLocationViewerState extends State<PageLocationViewer> {
  // map variables and controllers
  final Completer<GoogleMapController> _googleMapController = Completer();
  CameraPosition? _cameraPosition;

  late LatLng _pickupLatLng;
  late LatLng _userLatLng;
  late LatLng _destinationLatLng;

  late Marker _pickupMarker;
  late Marker _userMarker;
  late Marker _destinationMarker;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Address get _pickUpAddress => widget.pickUpAddress;
  Address? get _destinationAddress => widget.destinationAddress;

  double _zoomLevel = 14.5;
  final double _maxZoomLevel = 20;
  final double _minZoomLevel = 3;

  bool _isMapReady = false;

  var _distanceToPickUp = '';
  var _distanceToDestination = '';

  var _durationToPickUp = '';
  var _durationToDestination = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    _pickupLatLng = LatLng(_pickUpAddress.latitude, _pickUpAddress.longitude);
    _pickupMarker = getPickUpMarker();
    markers[_pickupMarker.markerId] = _pickupMarker;

    // sometimes destination address is not provided (for service type pet walking for example)
    if (_destinationAddress != null) {
      _destinationLatLng =
          LatLng(_destinationAddress!.latitude, _destinationAddress!.longitude);
      _destinationMarker = getDestinationMarker();
      markers[_destinationMarker.markerId] = _destinationMarker;
    }

    // set camera position to Palas Iasi with zoom 17.5
    _cameraPosition = CameraPosition(target: _pickupLatLng, zoom: _zoomLevel);

    getCurrentPostionMarker()
        .then((_) => generateRoute().then((_) => calculeteDistances()));
  }

  getPickUpMarker() {
    return Marker(
      markerId: const MarkerId('pickup'),
      position: _pickupLatLng,
      infoWindow:
          InfoWindow(title: 'Pet location', snippet: _pickUpAddress.street),
      onTap: () => displayDialogBox(' Pet Pickup', _pickUpAddress.street,
          _distanceToPickUp, _durationToPickUp),
    );
  }

  getDestinationMarker() {
    return Marker(
      markerId: const MarkerId('destination'),
      position: _destinationLatLng,
      infoWindow: InfoWindow(
          title: 'Destination', snippet: _destinationAddress!.street),
      onTap: () => displayDialogBox(' Destination', _destinationAddress!.street,
          _distanceToDestination, _durationToDestination),
    );
  }

  displayDialogBox(String title, String address, String distance, String time) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.home, color: Colors.green[900]),
            Text(
              title,
              style: const TextStyle(color: constants.MyColors.dustBlue),
            ),
          ],
        ),
        content: SizedBox(
          height: MediaQuery.of(context).size.height * .175,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.red),
                  Flexible(child: Text(' Address: $address')),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  const Icon(Icons.directions_walk, color: Colors.teal),
                  Text(' Distance: $distance'),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  const Icon(Icons.timer, color: Colors.amber),
                  Text(' Duration: $time'),
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  getCurrentPostionMarker() async {
    Position position = await getCurrentLocation();

    _userLatLng = LatLng(position.latitude, position.longitude);

    _userMarker = Marker(
      markerId: const MarkerId('user'),
      position: _userLatLng,
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: const InfoWindow(
        title: 'Your current location',
        snippet: 'You are here',
      ),
    );

    markers[_userMarker.markerId] = _userMarker;
  }

  List<LatLng> routePoints = [];

  generateRoute() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleDirectionApiKey,
      PointLatLng(_userLatLng.latitude, _userLatLng.longitude),
      PointLatLng(_pickupLatLng.latitude, _pickupLatLng.longitude),
      travelMode: TravelMode.walking,
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        routePoints.add(LatLng(point.latitude, point.longitude));
      }
    }

    if (_destinationAddress != null) {
      result = await polylinePoints.getRouteBetweenCoordinates(
        googleDirectionApiKey,
        PointLatLng(_pickupLatLng.latitude, _pickupLatLng.longitude),
        PointLatLng(_destinationLatLng.latitude, _destinationLatLng.longitude),
        travelMode: TravelMode.walking,
      );

      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          routePoints.add(LatLng(point.latitude, point.longitude));
        }
      }
    }
  }

  calculeteDistances() {
    setState(() {
      _pathInfo(_userLatLng, _pickupLatLng).then((value) {
        _distanceToPickUp = value[0];
        _durationToPickUp = value[1];
      });

      if (_destinationAddress != null) {
        _pathInfo(_pickupLatLng, _destinationLatLng).then((value) {
          _distanceToDestination = value[0];
          _durationToDestination = value[1];
        });
      }

      _isMapReady = true;
    });
  }

  _pathInfo(LatLng from, LatLng to) async {
    Dio dio = Dio();

    var url = 'https://maps.googleapis.com/maps/api/distancematrix/json';
    url += '?units=metric';
    url += '&mode=walking';
    url += '&origins=${from.latitude},${from.longitude}';
    url += '&destinations=${to.latitude},${to.longitude}';
    url += '&key=$googleMapApiKey';

    Response response = await dio.get(url);

    var distance = response.data['rows'][0]['elements'][0]['distance']['text'];
    var duration = response.data['rows'][0]['elements'][0]['duration']['text'];

    return [distance, duration];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return !_isMapReady
        ? Center(
            child: SizedBox(
            height: size.width * .8,
            width: size.width * .8,
            child: lt.Lottie.asset('assets/icons/loading_map.json'),
          ))
        : Scaffold(
            floatingActionButton: Padding(
              padding: EdgeInsets.only(bottom: size.height * .025),
              child: FloatingActionButton(
                onPressed: () => Navigator.pop(context),
                backgroundColor: constants.MyColors.darkBlue,
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,
            body: buildBody(size),
          );
  }

  Widget buildBody(Size size) {
    return Stack(
      children: [
        showMap(),
        showMapZoomControlls(size),
        // showAddress(size),
      ],
    );
  }

  Widget showMap() {
    return GoogleMap(
      initialCameraPosition: _cameraPosition!,
      mapType: MapType.normal,
      zoomControlsEnabled: false,
      tiltGesturesEnabled: false,
      onCameraMove: (position) => _userLatLng = position.target,
      onMapCreated: (GoogleMapController controller) {
        if (!_googleMapController.isCompleted) {
          _googleMapController.complete(controller);
        }
      },
      markers: Set<Marker>.of(markers.values),
      polylines: {
        Polyline(
          polylineId: const PolylineId('toPickUpLocation'),
          points: routePoints,
          color: constants.pathColor,
          width: 5,
        ),
      },
    );
  }

  Widget showMapZoomControlls(Size size) {
    return Positioned(
      bottom: size.height * .08,
      right: size.width * .025,
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
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: _userLatLng,
        zoom: _zoomLevel,
      )));
    });
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
              '${_pickUpAddress.city}, ${_pickUpAddress.street}',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
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
