import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../../../../Helpers/constants.dart' as constants;
import '../../../../Helpers/puts.dart';
import '../../../../entities/person.dart';
import '../../../../entities/pet.dart';

String petName = "Rex";
String petType = "Dog";
String petBreed = "German Shepherd";

DateTime petBirthDate = DateTime(2018, 10, 10);
double age = DateTime.now().difference(petBirthDate).inDays / 365;

String result = '';

class ViewPetPage extends StatefulWidget {
  const ViewPetPage({Key? key, required this.pet}) : super(key: key);

  final Pet pet;

  @override
  State<ViewPetPage> createState() => _Page();
}

class _Page extends State<ViewPetPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _speciesSelected = '';
  String _breedSelected = '';
  String _genderSelected = 'Male';

  List<String> _species = [];
  List<String> _breeds = [];

  Pet get _pet => widget.pet;

  bool _inEditMode = false;

  @override
  void initState() {
    super.initState();

    _species = [];
    _breeds = [];

    fetchSpecies().then((fetchedData) {
      setState(() {
        _species =
            json.decode(fetchedData).map<String>((e) => e.toString()).toList();

        fetchBreeds(_speciesSelected).then((fetchedData) {
          setState(() {
            _breeds = json
                .decode(fetchedData)
                .map<String>((e) => e.toString())
                .toList();
          });
        });
      });
    });

    init();
  }

  init() {
    _nameController.text = _pet.name;
    _dateController.text =
        DateFormat('yyyy-MM-dd').format(DateTime.parse(_pet.dateOfBirth));
    _speciesSelected = _pet.specie;
    _breedSelected = _pet.breed;
    _descriptionController.text = _pet.description;
  }

  String addSpaces(String text) {
    return text
        .split('')
        .map((e) => e.toLowerCase() != e ? ' $e' : e)
        .join()
        .trim();
  }

  Future<String> fetchSpecies() async {
    var request = http.Request('GET',
        Uri.parse('${constants.serverUrl}/appointments/species?api-version=1'));
    http.StreamedResponse response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Failed to get species');
    }

    return await response.stream.bytesToString();
  }

  Future<String> fetchBreeds(String specie) async {
    var request = http.Request(
        'GET',
        Uri.parse(
            '${constants.serverUrl}/appointments/breeds?specie=$specie&api-version=1'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Failed to get breeds');
    }

    return await response.stream.bytesToString();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        backgroundColor: constants.MyColors.darkBlue,
        child: const Icon(Icons.arrow_back, color: constants.MyColors.grey),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Stack(
            children: <Widget>[
              SizedBox(
                height: size.height,
                width: size.width,
              ),
              banner(size),
              panel(size),
              Positioned(
                top: size.height * .125,
                child: panelContent(size),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget panelContent(Size size) {
    return SizedBox(
      height: size.height * .8,
      width: size.width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * .1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            getNameField(size),
            const Divider(thickness: 1),
            getSpecieField(size),
            const Divider(thickness: 1),
            getBreedField(size),
            const Divider(thickness: 1),
            getGenderField(size),
            const Divider(thickness: 1),
            getBirthdayField(size),
            const Divider(thickness: 1),
            getDescriptionField(size),
          ],
        ),
      ),
    );
  }

  Widget getNameField(Size size) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * .01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(Icons.theater_comedy, size: 20, color: Colors.green),
              Text(' Name', style: TextStyle(fontSize: 20)),
            ],
          ),
          Text(
            _pet.name,
            style: const TextStyle(fontSize: 22),
          )
        ],
      ),
    );
  }

  Widget getSpecieField(Size size) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * .01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(Icons.pets, size: 20, color: Colors.brown),
              Text(' Specie', style: TextStyle(fontSize: 20)),
            ],
          ),
          Text(_pet.specie, style: const TextStyle(fontSize: 22))
        ],
      ),
    );
  }

  Widget getBreedField(Size size) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * .01),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Icon(Icons.account_tree, size: 20, color: Colors.orange),
                Text(' Breed', style: TextStyle(fontSize: 20)),
              ],
            ),
            Text(_pet.breed, style: const TextStyle(fontSize: 22))
          ],
        ),
      ),
    );
  }

  Widget getGenderField(Size size) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * .01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(_pet.gender == 'Male' ? Icons.male : Icons.female,
                  size: 20, color: Colors.pinkAccent),
              const Text(' Gender', style: TextStyle(fontSize: 20)),
            ],
          ),
          Text(_pet.gender, style: const TextStyle(fontSize: 22))
        ],
      ),
    );
  }

  Widget getBirthdayField(Size size) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * .01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(Icons.calendar_today, color: Colors.blue, size: 20),
              Text(' Birthday', style: TextStyle(fontSize: 20)),
            ],
          ),
          Text(DateFormat.yMMMd().format(DateTime.parse(_pet.dateOfBirth)),
              style: const TextStyle(fontSize: 22))
        ],
      ),
    );
  }

  Widget getDescriptionField(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * .01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.description, color: Colors.amber, size: 20),
              Text(' Description', style: TextStyle(fontSize: 20)),
            ],
          ),
          SizedBox(
            height: size.height * .4,
            width: size.width * .8,
            child: Padding(
              padding: EdgeInsets.only(top: size.height * .025),
              child: TextField(
                enabled: false,
                decoration: const InputDecoration(
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black38,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                style: const TextStyle(fontSize: 18),
                maxLines: 13,
                controller: _descriptionController,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget panel(Size size) {
    return Positioned(
      top: size.height * .1,
      left: size.width * .05,
      child: Container(
        height: size.height * .825,
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

  Container banner(Size size) {
    return Container(
      height: size.height * .225,
      width: size.width,
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
      ),
    );
  }
}
