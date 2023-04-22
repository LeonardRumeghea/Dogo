import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import '../entities/appointment.dart';
import './constants.dart' as constants;
import '../entities/pet.dart';

Future<int> postPet(Pet pet, String userId) async {
  var url = '${constants.serverUrl}/petOwners/$userId/pet?api-version=1';
  var request = http.Request('POST', Uri.parse(url));

  log('Url: $url');

  request.body = json.encode(pet.toJSON());
  request.headers.addAll(
      <String, String>{'Content-Type': 'application/json; charset=UTF-8'});

  var response = await request.send();

  log('Ok');
  log(await response.stream.bytesToString());
  log(response.statusCode.toString());

  return response.statusCode;
}

Future<int> postAppoitment(Appointment appointment) async {
  var url = '${constants.serverUrl}/appointments?api-version=1';
  var request = http.Request('POST', Uri.parse(url));

  log('Url: $url');

  request.body = json.encode(appointment.toJSON());
  request.headers.addAll(
      <String, String>{'Content-Type': 'application/json; charset=UTF-8'});

  var response = await request.send();

  log('Ok');
  log(await response.stream.bytesToString());
  log(response.statusCode.toString());

  return response.statusCode;
}
