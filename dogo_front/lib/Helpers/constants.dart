import 'package:flutter/material.dart';

// Google API Key for Maps and Directions
const String googleMapApiKey = 'AIzaSyDlvGPPAHeaSX9zsC3FiMHCi3Ix-YFvHVk';
const String googleDirectionApiKey = 'AIzaSyCZlnFIJrROXkODCImblbxZi0SBXtdzzQI';

// Constants for the app
const String walk = 'Walk';
const String salon = 'Salon';
const String sitting = 'Sitting';
const String vet = 'Vet';
const String shopping = 'Shopping';

const double borderRadius = 8;

// Server URL for API calls
const String serverUrl = 'https://10.0.2.2:7077/api/v1';
//'http://192.168.0.1:7077/api/v1';

// Colors for the app for different services
const Color walkColor = Color.fromARGB(255, 84, 147, 139);
const Color salonColor = Color.fromARGB(255, 255, 195, 170);
const Color sittingColor = Color.fromARGB(255, 121, 182, 149);
const Color vetColor = Color.fromARGB(255, 211, 167, 122);
const Color shoppingColor = Color.fromARGB(255, 205, 180, 219);

const Color petColor = Color.fromARGB(255, 204, 172, 144);

const Color darkGrey = Color.fromARGB(255, 214, 212, 213);
const Color lightGrey = Color.fromARGB(255, 245, 245, 245);

const Color userMarkerColor = Color.fromARGB(255, 0, 145, 124);
const Color pickUpMarkerColor = Color.fromARGB(255, 3, 89, 86);
const Color destinationMarkerColor = Color.fromARGB(255, 24, 77, 71);
const Color pathColor = Color.fromARGB(250, 35, 117, 99);

const Color blackBlue = Color.fromRGBO(41, 50, 65, 1);
const Color darkBlue = Color.fromARGB(255, 61, 90, 128);
const Color dustBlue = Color.fromRGBO(152, 193, 217, 1);
const Color dustRed = Color.fromRGBO(238, 108, 77, 1);
const Color dustGreen = Color.fromRGBO(118, 169, 115, 1);

class MyColors {
  static const MaterialColor darkBlue = MaterialColor(
    0xff3d5a80,
    <int, Color>{
      50: Color(0xff3d5a80),
      100: Color(0xff3d5a80),
      200: Color(0xff3d5a80),
      300: Color(0xff3d5a80),
      400: Color(0xff3d5a80),
      500: Color(0xff3d5a80),
      600: Color(0xff3d5a80),
      700: Color(0xff3d5a80),
      800: Color(0xff3d5a80),
      900: Color(0xff3d5a80),
    },
  );

  static const MaterialColor dustBlue = MaterialColor(
    0xff98c1d9,
    <int, Color>{
      50: Color(0xff98c1d9),
      100: Color(0xff98c1d9),
      200: Color(0xff98c1d9),
      300: Color(0xff98c1d9),
      400: Color(0xff98c1d9),
      500: Color(0xff98c1d9),
      600: Color(0xff98c1d9),
      700: Color(0xff98c1d9),
      800: Color(0xff98c1d9),
      900: Color(0xff98c1d9),
    },
  );

  static const MaterialColor lightBlue = MaterialColor(
    0xffe0fbfc,
    <int, Color>{
      50: Color(0xffe0fbfc),
      100: Color(0xffe0fbfc),
      200: Color(0xffe0fbfc),
      300: Color(0xffe0fbfc),
      400: Color(0xffe0fbfc),
      500: Color(0xffe0fbfc),
      600: Color(0xffe0fbfc),
      700: Color(0xffe0fbfc),
      800: Color(0xffe0fbfc),
      900: Color(0xffe0fbfc),
    },
  );

  static const MaterialColor dustRed = MaterialColor(
    0xffee6c4d,
    <int, Color>{
      50: Color(0xffee6c4d),
      100: Color(0xffee6c4d),
      200: Color(0xffee6c4d),
      300: Color(0xffee6c4d),
      400: Color(0xffee6c4d),
      500: Color(0xffee6c4d),
      600: Color(0xffee6c4d),
      700: Color(0xffee6c4d),
      800: Color(0xffee6c4d),
      900: Color(0xffee6c4d),
    },
  );

  static const MaterialColor dustGreen = MaterialColor(
    0xff76A973,
    <int, Color>{
      50: Color(0xff76A973),
      100: Color(0xff76A973),
      200: Color(0xff76A973),
      300: Color(0xff76A973),
      400: Color(0xff76A973),
      500: Color(0xff76A973),
      600: Color(0xff76A973),
      700: Color(0xff76A973),
      800: Color(0xff76A973),
      900: Color(0xff76A973),
    },
  );

  static const MaterialColor blackBlue = MaterialColor(
    0xff293241,
    <int, Color>{
      50: Color(0xff293241),
      100: Color(0xff293241),
      200: Color(0xff293241),
      300: Color(0xff293241),
      400: Color(0xff293241),
      500: Color(0xff293241),
      600: Color(0xff293241),
      700: Color(0xff293241),
      800: Color(0xff293241),
      900: Color(0xff293241),
    },
  );

  static const MaterialColor grey = MaterialColor(
    0xffc5c5c5,
    <int, Color>{
      50: Color(0xffc5c5c5),
      100: Color(0xffc5c5c5),
      200: Color(0xffc5c5c5),
      300: Color(0xffc5c5c5),
      400: Color(0xffc5c5c5),
      500: Color(0xffc5c5c5),
      600: Color(0xffc5c5c5),
      700: Color(0xffc5c5c5),
      800: Color(0xffc5c5c5),
      900: Color(0xffc5c5c5),
    },
  );
}
