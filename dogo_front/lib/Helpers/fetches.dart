import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import './constants.dart' as constants;

Future<String> fetchPets(String userId) async {
  var url = '${constants.serverUrl}/petOwners/$userId/pets?api-version=1';
  var request = http.Request('GET', Uri.parse(url));
  var response = await request.send();

  if (response.statusCode == HttpStatus.notFound) {
    log('Invalid user id');
    throw Exception('Invalid user id $userId in fetchPets function!');
  }

  return response.stream.bytesToString();
}

Future<String> fetchPet(String petId) async {
  var url = '${constants.serverUrl}/pets/$petId?api-version=1';
  var request = http.Request('GET', Uri.parse(url));
  var response = await request.send();

  if (response.statusCode == HttpStatus.notFound) {
    log('Invalid pet id');
    throw Exception('Invalid pet id $petId in fetchPet function!');
  }

  return response.stream.bytesToString();
}

Future<String> fetchUser(String userId) async {
  var url = '${constants.serverUrl}/petOwners/$userId?api-version=1';
  var request = http.Request('GET', Uri.parse(url));
  var response = await request.send();

  if (response.statusCode == HttpStatus.notFound) {
    log('Invalid pet id');
    throw Exception('Invalid user id $userId in fetchUser function!');
  }

  return response.stream.bytesToString();
}

Future<String> fetchAppoitments(String userId) async {
  var url = '${constants.serverUrl}/appointments/owner/$userId?api-version=1';
  var request = http.Request('GET', Uri.parse(url));
  var response = await request.send();

  log('Response status code: ${response.statusCode}');

  if (response.statusCode == HttpStatus.notFound) {
    log('Invalid user id');
    throw Exception('Invalid user id $userId in fetchAppoitments function!');
  }

  return response.stream.bytesToString();
}

Future<String> fetchAvailableAppoitments(String userId) async {
  var url =
      '${constants.serverUrl}/appointments/available?UserId=$userId&api-version=1';
  var request = http.Request('GET', Uri.parse(url));
  var response = await request.send();

  log('Response status code: ${response.statusCode}');

  if (response.statusCode == HttpStatus.notFound) {
    var responseString = await response.stream.bytesToString();
    log(responseString);
    throw Exception(
        'fetchAvailableAppoitments function failed! -> $responseString');
  }

  return response.stream.bytesToString();
}

Future<String> fetchAgenda(String userId) {
  var url =
      '${constants.serverUrl}/appointments/agenda?UserId=$userId&api-version=1';
  var request = http.Request('GET', Uri.parse(url));
  return request.send().then((response) async {
    log('Response status code: ${response.statusCode}');

    if (response.statusCode == HttpStatus.notFound) {
      var responseString = await response.stream.bytesToString();
      log(responseString);
      throw Exception('fetchAgenda function failed! -> $responseString');
    }

    return response.stream.bytesToString();
  });
}
