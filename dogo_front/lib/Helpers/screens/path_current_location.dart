import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart' as lt;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../Helpers/constants.dart' as constants;
import '../../../Helpers/config.dart' as config;
import '../../entities/address.dart';
import '../../entities/appointment.dart';
import '../fetches.dart';
import '../puts.dart';

class PagePathViewer extends StatefulWidget {
  const PagePathViewer({
    Key? key,
    required this.appointment,
  }) : super(key: key);

  final Appointment appointment;

  @override
  State<PagePathViewer> createState() => _PagePathViewerState();
}

class _PagePathViewerState extends State<PagePathViewer> {
  // map variables and controllers
  final Completer<GoogleMapController> _googleMapController = Completer();
  CameraPosition? _cameraPosition;

  late LatLng _pickupLatLng;
  late LatLng _startLatLng;
  late LatLng _destinationLatLng;
  late LatLng _currentLatLng;

  late Marker _pickupMarker;
  late Marker _startMarker;
  late Marker _destinationMarker;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  // Current user position marker
  late final MarkerId _cupmId = const MarkerId('current');

  late Address _pickUpAddress;
  late String _petId;
  late String _walkerId;
  Address? _destinationAddress;

  get _appointment => widget.appointment;

  double _zoomLevel = 16.5;
  final double _maxZoomLevel = 20;
  final double _minZoomLevel = 3;

  bool _isMapReady = false;

  final List<LatLng> _routePoints = [];

  var _distanceToPickUp = '';
  var _distanceToDestination = '';

  var _durationToPickUp = '';
  var _durationToDestination = '';

  double _distaceToPickUpInMeters = 0;
  double _distaceToDestinationInMeters = 0;

  var _pathStage = 0;
  late String _appointmentType;

  final LocationSettings _locationSettings = AndroidSettings(
    accuracy: LocationAccuracy.bestForNavigation,
    distanceFilter: 0,
    // forceLocationManager: true,
    // foregroundNotificationConfig: const ForegroundNotificationConfig(
    //   notificationText:
    //       "For the best experience, please keep the app running in the background",
    //   notificationTitle: "Background location tracking",
    // enableWakeLock: true,
    // ),
  );

  late StreamSubscription<Position> _streamSubscription;

  @override
  void initState() {
    super.initState();

    _walkerId = _appointment.walkerId;
    _petId = _appointment.petId;
    _appointmentType = _appointment.type;
    if (_appointment.type == constants.vet ||
        _appointment.type == constants.salon) {
      _destinationAddress = _appointment.address;
    }

    getPetOwnerAddress();
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
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

    // getStartPostionMarker();
    getStartPostionMarker().then((_) => generateRoute().then((_) {
          calculeteDistances();
          startUserTracking();
          _cameraPosition =
              CameraPosition(target: _currentLatLng, zoom: _zoomLevel);
        }));
  }

  getPetOwnerAddress() {
    fetchPet(_petId).then((value) {
      fetchUser(json.decode(value)['ownerId']).then((value) {
        _pickUpAddress = Address.fromJson(json.decode(value)['address']);
        init();
      });
    });
  }

  completeAppointment(BuildContext context) {
    log('Accepting appointment');

    complete(_appointment.id, _walkerId).then((value) {
      if (value == HttpStatus.noContent) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
              const SnackBar(
                content: Text('Appointment completed'),
                backgroundColor: constants.MyColors.dustGreen,
              ),
            )
            .closed
            .then((_) => Navigator.pop(context, true));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong, try again later'),
            backgroundColor: constants.MyColors.dustRed,
          ),
        );
      }
    });
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

  calculeteDistances() {
    setState(() {
      calculateDistanceToPickUp();

      if (_destinationAddress != null) {
        _pathInfo(_pickupLatLng, _destinationLatLng).then((value) {
          _distanceToDestination = value[0];
          _durationToDestination = value[1];
        });
      }

      _isMapReady = true;
    });
  }

  calculateDistanceToPickUp() {
    _pathInfo(_currentLatLng, _pickupLatLng).then((value) {
      _distanceToPickUp = value[0];
      _durationToPickUp = value[1];
      _distaceToPickUpInMeters = value[2].toDouble();

      log('Distance to pick up: $_distaceToPickUpInMeters');
    });
  }

  calculateDistanceToDestination() {
    _pathInfo(_currentLatLng, _destinationLatLng).then((value) {
      _distanceToDestination = value[0];
      _durationToDestination = value[1];
      _distaceToDestinationInMeters = value[2].toDouble();

      log('Distance to destination: $_distaceToDestinationInMeters');
    });
  }

  _pathInfo(LatLng from, LatLng to) async {
    Dio dio = Dio();

    var url = 'https://maps.googleapis.com/maps/api/distancematrix/json';
    url += '?units=metric';
    url += '&mode=walking';
    url += '&origins=${from.latitude},${from.longitude}';
    url += '&destinations=${to.latitude},${to.longitude}';
    url += '&key=${config.googleMapApiKey}';

    Response response = await dio.get(url);

    var distance = response.data['rows'][0]['elements'][0]['distance']['text'];
    var duration = response.data['rows'][0]['elements'][0]['duration']['text'];
    var distanceInMeters =
        response.data['rows'][0]['elements'][0]['distance']['value'];

    return [distance, duration, distanceInMeters];
  }

  createCurrentUserPositionMarker(LatLng position) {
    return Marker(
      markerId: _cupmId,
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      infoWindow: const InfoWindow(title: 'You are here'),
    );
  }

  getStartPostionMarker() async {
    Position position = await getCurrentLocation();

    _startLatLng =
        _currentLatLng = LatLng(position.latitude, position.longitude);

    _startMarker =
        Marker(markerId: const MarkerId('start'), position: _startLatLng);

    markers[_startMarker.markerId] = _startMarker;
    markers[_cupmId] = createCurrentUserPositionMarker(_currentLatLng);
  }

  generateRoute() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      config.googleDirectionApiKey,
      PointLatLng(_startLatLng.latitude, _startLatLng.longitude),
      PointLatLng(_pickupLatLng.latitude, _pickupLatLng.longitude),
      travelMode: TravelMode.walking,
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        _routePoints.add(LatLng(point.latitude, point.longitude));
      }
    }

    if (_destinationAddress != null) {
      result = await polylinePoints.getRouteBetweenCoordinates(
        config.googleDirectionApiKey,
        PointLatLng(_pickupLatLng.latitude, _pickupLatLng.longitude),
        PointLatLng(_destinationLatLng.latitude, _destinationLatLng.longitude),
        travelMode: TravelMode.walking,
      );

      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          _routePoints.add(LatLng(point.latitude, point.longitude));
        }
      }
    }
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
            floatingActionButton: _pathStage == 3
                ? null
                : Padding(
                    padding: EdgeInsets.only(bottom: size.height * .025),
                    child: FloatingActionButton(
                      onPressed: () {
                        if (_pathStage == 0) {
                          if (_distaceToPickUpInMeters > 100) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('You are not there yet'),
                                duration: Duration(seconds: 2),
                                backgroundColor: constants.MyColors.dustRed,
                              ),
                            );
                            return;
                          }

                          setState(() {
                            if (_appointmentType == constants.vet ||
                                _appointmentType == constants.salon) {
                              _pathStage = 1;
                            } else {
                              _pathStage = 2;
                            }
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Pet picked up'),
                              duration: Duration(seconds: 2),
                              backgroundColor: constants.MyColors.dustGreen,
                            ),
                          );
                        } else if (_pathStage == 1) {
                          if (_distaceToDestinationInMeters > 100) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('You are not there yet'),
                                duration: Duration(seconds: 2),
                                backgroundColor: constants.MyColors.dustRed,
                              ),
                            );
                            return;
                          }

                          setState(() => _pathStage = 2);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Destination reached'),
                              duration: Duration(seconds: 2),
                              backgroundColor: constants.MyColors.dustGreen,
                            ),
                          );
                        } else {
                          if (_distaceToPickUpInMeters > 100) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('You are not there yet'),
                                duration: Duration(seconds: 2),
                                backgroundColor: constants.MyColors.dustRed,
                              ),
                            );
                            return;
                          }

                          setState(() => _pathStage = 3);
                          completeAppointment(context);
                        }
                      },
                      backgroundColor: constants.MyColors.darkBlue,
                      child: Icon(
                          _pathStage == 0
                              ? Icons.pets
                              : _pathStage == 1
                                  ? (_appointmentType == constants.vet
                                      ? Icons.local_hospital
                                      : Icons.cut)
                                  : Icons.home,
                          color: Colors.white),
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
      ],
    );
  }

  Widget showMap() {
    return GoogleMap(
      initialCameraPosition: _cameraPosition!,
      mapType: MapType.normal,
      zoomControlsEnabled: false,
      tiltGesturesEnabled: false,
      onCameraMove: (position) => _currentLatLng = position.target,
      onMapCreated: (GoogleMapController controller) {
        if (!_googleMapController.isCompleted) {
          _googleMapController.complete(controller);
        }
      },
      markers: Set<Marker>.of(markers.values),
      polylines: {
        Polyline(
            polylineId: const PolylineId('route'),
            points: _routePoints,
            color: constants.pathColor,
            width: 5),
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
        target: _currentLatLng,
        zoom: _zoomLevel,
      )));
    });
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

  startUserTracking() {
    _streamSubscription =
        Geolocator.getPositionStream(locationSettings: _locationSettings)
            .listen((Position? position) {
      log('Lat: ${position?.latitude} Long: ${position?.longitude}');

      if (position != null) {
        _currentLatLng = LatLng(position.latitude, position.longitude);
        setState(() {
          markers[_cupmId] =
              markers[_cupmId]!.copyWith(positionParam: _currentLatLng);

          if (_pathStage == 1) {
            calculateDistanceToDestination();
          } else {
            calculateDistanceToPickUp();
          }
        });
        putPosition(
          _appointment.walkerId,
          _currentLatLng.latitude,
          _currentLatLng.longitude,
        );
      }
    });
  }
}
