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
