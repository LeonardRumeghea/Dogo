import 'dart:convert';

import 'package:http/http.dart' as http;
import '../entities/appointment.dart';
import '../entities/pet.dart';
import 'config.dart';

Future<int> postPet(Pet pet, String userId) async {
  var url = '$serverUrl/users/$userId/pet?api-version=1';
  var request = http.Request('POST', Uri.parse(url));

  request.body = json.encode(pet.toJSON());
  request.headers.addAll(
      <String, String>{'Content-Type': 'application/json; charset=UTF-8'});

  var response = await request.send();

  if (response.statusCode == 201) {
    var jsonDecode = json.decode(await response.stream.bytesToString());
    pet.id = jsonDecode['id'];
    pet.ownerId = jsonDecode['ownerId'];
  }

  return response.statusCode;
}

Future<int> postAppoitment(Appointment appointment) async {
  var url = '$serverUrl/appointments?api-version=1';
  var request = http.Request('POST', Uri.parse(url));

  request.body = json.encode(appointment.toJSON());
  request.headers.addAll(
      <String, String>{'Content-Type': 'application/json; charset=UTF-8'});

  var response = await request.send();

  return response.statusCode;
}
