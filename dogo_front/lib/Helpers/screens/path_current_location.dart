import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart' as lt;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../Helpers/constants.dart' as constants;
import '../../entities/address.dart';
import '../../entities/person.dart';
import '../../entities/pet.dart';
import '../fetches.dart';

class PagePathViewer extends StatefulWidget {
  const PagePathViewer({Key? key, required this.petId, this.destinationAddress})
      : super(key: key);

  // final Address pickUpAddress;
  final Address? destinationAddress;

  final String petId;

  @override
  State<PagePathViewer> createState() => _PagePathViewerState();
}

class _PagePathViewerState extends State<PagePathViewer> {
  // map variables and controllers
  final Completer<GoogleMapController> _googleMapController = Completer();
  CameraPosition? _cameraPosition;

  late LatLng _pickupLatLng;
  late LatLng _userLatLng;
  late LatLng _destinationLatLng;
  late LatLng _currentLatLng;

  late Marker _pickupMarker;
  late Marker _userMarker;
  late Marker _destinationMarker;
  late Marker _currentMarker;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  late final MarkerId _currentMarkerId = const MarkerId('current');

  late Address _pickUpAddress;
  String get _petId => widget.petId;
  Address? get _destinationAddress => widget.destinationAddress;

  double _zoomLevel = 14.5;
  final double _maxZoomLevel = 20;
  final double _minZoomLevel = 3;

  String _darkMapStyle = '';
  bool _isMapReady = false;

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

    _getPet();
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }

  init() {
    // load dark map style from assets
    // _loadMapStyles().then((value) => _googleMapController.future
    //     .then((controller) => controller.setMapStyle(_darkMapStyle)));

    _pickupLatLng = LatLng(_pickUpAddress.latitude, _pickUpAddress.longitude);

    // sometimes destination address is not provided (for service type pet walking for example)
    if (_destinationAddress != null) {
      _destinationLatLng =
          LatLng(_destinationAddress!.latitude, _destinationAddress!.longitude);
    }

    // set camera position to Palas Iasi with zoom 17.5
    _cameraPosition = CameraPosition(
      target: _pickupLatLng,
      zoom: _zoomLevel,
    );

    _pickupMarker = Marker(
      markerId: const MarkerId('pickup'),
      position: _pickupLatLng,
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(
        title: 'Pet location',
        snippet: _pickUpAddress.street,
      ),
    );
    markers[_pickupMarker.markerId] = _pickupMarker;

    if (_destinationAddress != null) {
      _destinationMarker = Marker(
        markerId: const MarkerId('destination'),
        position: _destinationLatLng,
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(
          title: 'Destination',
          snippet: _destinationAddress?.street,
        ),
      );
      markers[_destinationMarker.markerId] = _destinationMarker;
    }

    getStartPostionMarker();
  }

  _getPet() {
    var pet = Pet();
    fetchPet(_petId).then((value) {
      pet = Pet.fromJSON(json.decode(value));

      _getPetOwner(pet.ownerId);
    });
  }

  _getPetOwner(String petOwnerId) {
    fetchUser(petOwnerId).then((value) {
      var petOwner = Person.fromJSON(json.decode(value));

      setState(() {
        _pickUpAddress = petOwner.address!;
      });

      init();
    });
  }

  getStartPostionMarker() async {
    Position position = await getCurrentLocation();

    _userLatLng = LatLng(position.latitude, position.longitude);
    _currentLatLng = LatLng(position.latitude, position.longitude);

    _userMarker = Marker(
      markerId: const MarkerId('user'),
      position: _userLatLng,
    );

    setState(() {
      markers[_userMarker.markerId] = _userMarker;
    });

    getCurrentPostionMarker();
  }

  createCurrentMarker(LatLng position) {
    return Marker(
      markerId: const MarkerId('current'),
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      infoWindow: const InfoWindow(
        title: 'Your current location',
        snippet: 'You are here',
      ),
    );
  }

  getCurrentPostionMarker() {
    _currentMarker = createCurrentMarker(_currentLatLng);
    setState(() {
      markers[_currentMarker.markerId] = _currentMarker;
    });

    refreshMap();
    generateRoute();
  }

  List<LatLng> routePoints = [];

  generateRoute() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      constants.googleDirectionApiKey,
      PointLatLng(_userLatLng.latitude, _userLatLng.longitude),
      PointLatLng(_pickupLatLng.latitude, _pickupLatLng.longitude),
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        routePoints.add(LatLng(point.latitude, point.longitude));
      }
    }

    if (_destinationAddress != null) {
      result = await polylinePoints.getRouteBetweenCoordinates(
        constants.googleDirectionApiKey,
        PointLatLng(_pickupLatLng.latitude, _pickupLatLng.longitude),
        PointLatLng(_destinationLatLng.latitude, _destinationLatLng.longitude),
      );

      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          routePoints.add(LatLng(point.latitude, point.longitude));
        }
      }
    }

    setState(() => _isMapReady = true);
    startUserTracking();
  }

  Future _loadMapStyles() async {
    _darkMapStyle =
        await rootBundle.loadString('assets/json/dark_mode_map.json');
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
      top: size.height * .05,
      left: size.width * .875,
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

  startUserTracking() {
    _streamSubscription =
        Geolocator.getPositionStream(locationSettings: _locationSettings)
            .listen((Position? position) {
      log('Lat: ${position?.latitude} Long: ${position?.longitude}');

      if (position != null) {
        _currentLatLng = LatLng(position.latitude, position.longitude);
        setState(() => markers[_currentMarkerId] =
            markers[_currentMarkerId]!.copyWith(positionParam: _currentLatLng));
      }
    });
  }
}
