import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import '../entities/pet.dart';
import './constants.dart' as constants;

Future<int> putPet(Pet pet, String userId) async {
  log('--- Put Pet Begin ---');
  var url = '${constants.serverUrl}/users/$userId/pet/${pet.id}?api-version=1';
  var request = http.Request('PUT', Uri.parse(url));

  log('Url: $url');

  request.body = json.encode(pet.toJSON());
  request.headers.addAll(
      <String, String>{'Content-Type': 'application/json; charset=UTF-8'});

  var response = await request.send();

  log('Ok');
  log(await response.stream.bytesToString());
  log(response.statusCode.toString());
  log('--- Post Appointment End ---');

  return response.statusCode;
}

Future<int> assignAppointment(String appointmentId, String walkerId) async {
  log('--- Assign Appointment Begin ---');
  var url = '${constants.serverUrl}/appointments/assign?'
      'AppointmentId=$appointmentId&'
      'UserId=$walkerId&'
      'api-version=1';
  var request = http.Request('PUT', Uri.parse(url));

  log('Url: $url');

  var response = await request.send();

  log(await response.stream.bytesToString());
  log(response.statusCode.toString());
  log('--- Assign Appointment End ---');

  return response.statusCode;
}
