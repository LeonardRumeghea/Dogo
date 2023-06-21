import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../Helpers/config.dart';
import '../../../Helpers/constants.dart' as constants;
import '../../../entities/person.dart';
import '../../../entities/preferences.dart';

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({required this.user, super.key});

  final Person user;

  @override
  State<PreferencesPage> createState() => _Page();
}

class _Page extends State<PreferencesPage> {
  List<String> _species = [];
  Person get _user => widget.user;
  Preferences _preferences = Preferences();

  final _displayValue = List<String>.filled(13, 'Medium');

  var _pageLoaded = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    fetchSpecies().then((fetchedData) {
      setState(() => _species =
          json.decode(fetchedData).map<String>((e) => e.toString()).toList());
    });

    fetchPreferences().then((value) {
      setState(() {
        _preferences = Preferences.fromJSON(json.decode(value));

        _displayValue[0] = _preferences.catPreference;
        _displayValue[1] = _preferences.dogPreference;
        _displayValue[2] = _preferences.birdPreference;
        _displayValue[3] = _preferences.rabbitPreference;
        _displayValue[4] = _preferences.ferretPreference;
        _displayValue[5] = _preferences.fishPreference;
        _displayValue[6] = _preferences.guineaPigPreference;
        _displayValue[7] = _preferences.otherPreference;
        _displayValue[8] = _preferences.walkPreference;
        _displayValue[9] = _preferences.vetPreference;
        _displayValue[10] = _preferences.salonPreference;
        _displayValue[11] = _preferences.sitPreference;
        _displayValue[12] = _preferences.shoppingPreference;

        _pageLoaded = true;
      });
    });
  }

  Future<String> fetchSpecies() async {
    var request = http.Request(
        'GET', Uri.parse('$serverUrl/appointments/species?api-version=1'));
    http.StreamedResponse response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Failed to get species');
    }

    return await response.stream.bytesToString();
  }

  Future<String> fetchPreferences() async {
    var request = http.Request(
        'GET', Uri.parse('$serverUrl/preferences/${_user.id}?api-version=1'));
    http.StreamedResponse response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Failed to get preferences');
    }

    return await response.stream.bytesToString();
  }

  updatePreferences() async {
    _preferences = Preferences.fromList(_user.id, _displayValue);

    var request = http.Request(
        'PUT', Uri.parse('$serverUrl/preferences/update?api-version=1'));

    request.body = json.encode(_preferences.toJSON());
    request.headers.addAll(<String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    var response = await request.send();

    log(await response.stream.bytesToString());

    return response.statusCode;
  }

  floatingButtonHandler() {
    updatePreferences().then((value) {
      if (value == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Preferences updated successfully'),
            backgroundColor: constants.MyColors.dustGreen,
          ),
        );
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(context);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error has occurred. Please try again later'),
            backgroundColor: constants.MyColors.dustRed,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => floatingButtonHandler(),
        backgroundColor: constants.MyColors.darkBlue,
        child: const Icon(Icons.done, color: constants.MyColors.lightBlue),
      ),
      body: buildBody(size),
    );
  }

  Widget buildBody(Size size) {
    return Stack(
      children: [
        SizedBox(height: size.height, width: size.width),
        banner(size),
        panel(size),
        title(size),
        _pageLoaded
            ? preferencesList(size)
            : const Center(
                heightFactor: 12.5,
                child: CircularProgressIndicator(),
              ),
      ],
    );
  }

  title(Size size) {
    return Positioned(
      top: size.height * .125,
      left: size.width * .1,
      child: SizedBox(
        width: size.width * .8,
        height: size.height * .1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Preferences',
              style: TextStyle(
                  color: constants.darkGrey,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat'),
            ),
            Divider(color: constants.darkGrey, thickness: 2),
          ],
        ),
      ),
    );
  }

  preferencesList(Size size) {
    return Positioned(
      top: size.height * .2,
      left: size.width * .1,
      child: SizedBox(
        width: size.width * .8,
        height: size.height * .675,
        child: SingleChildScrollView(
          child: Column(
            children: [
              label('Pets Preferences', Icons.pets, size),
              petsCards(size),
              label('Activities Preferences', Icons.directions_walk, size),
              activitiesCards(size),
            ],
          ),
        ),
      ),
    );
  }

  petsCards(Size size) {
    var cards = <Widget>[];
    int idx = 0;
    for (var species in _species) {
      cards.add(card(species, idx++, size));
    }
    return Column(children: cards);
  }

  activitiesCards(Size size) {
    var cards = <Widget>[];
    cards.add(card('Walk', 8, size));
    cards.add(card('Vet', 9, size));
    cards.add(card('Salon', 10, size));
    cards.add(card('Sit', 11, size));
    cards.add(card('Shopping', 12, size));
    return Column(children: cards);
  }

  card(String preference, int idx, Size size) {
    return SizedBox(
      width: size.width * .8,
      child: Row(
        children: [
          Text(
            preference,
            style: const TextStyle(
                color: constants.darkGrey,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat'),
          ),
          const Spacer(),
          DropdownButton<String>(
            value: _displayValue[idx],
            style: const TextStyle(fontSize: 20),
            underline: Container(height: 2, color: constants.MyColors.grey),
            menuMaxHeight: 300,
            onChanged: (String? newValue) {
              setState(() {
                _displayValue[idx] = newValue!;
              });
            },
            items: preferenceDegree.reversed
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
          )
        ],
      ),
    );
  }

  label(String text, IconData icon, Size size) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: SizedBox(
        width: size.width * .8,
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                    radius: 15,
                    backgroundColor: constants.darkBlue,
                    child: Icon(icon, color: constants.MyColors.lightBlue)),
                Text(
                  ' $text',
                  style: const TextStyle(
                      color: constants.MyColors.dustBlue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat'),
                ),
              ],
            ),
            const Divider(color: constants.darkGrey, thickness: 1)
          ],
        ),
      ),
    );
  }

  Widget panel(Size size) {
    return Positioned(
      top: size.height * .1,
      left: size.width * .05,
      child: Container(
        height: size.height * .85,
        width: size.width * .9,
        decoration: const BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(constants.borderRadius)),
          color: Color.fromARGB(255, 66, 66, 66),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              spreadRadius: 10,
            ),
          ],
        ),
      ),
    );
  }

  banner(Size size) {
    return Container(
      height: size.height * .25,
      width: size.width,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(constants.borderRadius),
              bottomRight: Radius.circular(constants.borderRadius)),
          image: DecorationImage(
              image: AssetImage('assets/images/main_menu_bg.png'),
              fit: BoxFit.cover)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(constants.borderRadius),
              bottomRight: Radius.circular(constants.borderRadius)),
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 5, 78, 213).withOpacity(0.7),
              const Color.fromARGB(255, 18, 227, 221).withOpacity(0.7)
            ],
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 10,
              spreadRadius: 10,
            ),
          ],
        ),
      ),
    );
  }
}
