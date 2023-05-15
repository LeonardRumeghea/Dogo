import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
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

class UpdatePetPage extends StatefulWidget {
  const UpdatePetPage({Key? key, required this.user, required this.pet})
      : super(key: key);

  final Person user;
  final Pet pet;

  @override
  State<UpdatePetPage> createState() => _Page();
}

class _Page extends State<UpdatePetPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _speciesSelected = '';
  String _breedSelected = '';
  String _genderSelected = 'Male';

  List<String> _species = [];
  List<String> _breeds = [];

  Person get _user => widget.user;
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

    log('User: ${_user.toString()}');
    return Scaffold(
      floatingActionButton: floatingActionButton(context),
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

  updatePet(BuildContext context) {
    if (_nameController.text.isEmpty || _dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all require fields'),
          backgroundColor: constants.MyColors.dustRed,
        ),
      );
      return;
    }

    Pet pet = Pet(
      id: _pet.id,
      name: _nameController.text,
      specie: _speciesSelected,
      breed: _breedSelected,
      dateOfBirth: _dateController.text,
      gender: _genderSelected,
      description: _descriptionController.text,
    );

    log(pet.toString());

    putPet(pet, _user.id).then((statusCode) {
      if (statusCode == HttpStatus.noContent) {
        log('Pet added successfully');

        _pet.name = _nameController.text;
        _pet.specie = _speciesSelected;
        _pet.breed = _breedSelected;
        _pet.dateOfBirth = _dateController.text;
        _pet.gender = _genderSelected;
        _pet.description = _descriptionController.text;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pet updated successfully'),
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
    }).catchError((error) {
      log('Error updating pet: $error');
    });
  }

  floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        !_inEditMode
            ? setState(() => _inEditMode = !_inEditMode)
            : updatePet(context);
      },
      backgroundColor: constants.MyColors.darkBlue,
      child: Icon(
        !_inEditMode ? Icons.edit : Icons.done,
        color: constants.MyColors.lightBlue,
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
            nameInput(size),
            specieInput(size),
            breedInput(size),
            genderInput(size),
            birthdayInput(size),
            descriptionInput(size),
          ],
        ),
      ),
    );
  }

  Widget nameInput(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * .01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(Icons.emoji_emotions, size: 20, color: Colors.green),
              Text(' Name', style: TextStyle(fontSize: 20)),
            ],
          ),
          SizedBox(
            width: size.width * .5,
            child: TextField(
              controller: _nameController,
              enabled: _inEditMode,
              style: const TextStyle(fontSize: 20),
              decoration: const InputDecoration(
                hintText: 'Pet\'s name',
                hintStyle: TextStyle(fontSize: 18),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: constants.MyColors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    width: 2.0,
                    color: constants.MyColors.grey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget specieInput(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * .01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(
                Icons.pets,
                size: 20,
                color: Colors.brown,
              ),
              Text(
                ' Specie',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
          DropdownButton<String>(
            value: _speciesSelected,
            style: const TextStyle(fontSize: 20),
            underline: Container(
              height: 2,
              color: constants.MyColors.grey,
            ),
            menuMaxHeight: 300,
            onChanged: !_inEditMode
                ? null
                : (String? newValue) {
                    fetchBreeds(newValue!).then((fetchedData) {
                      setState(() {
                        _breeds = json
                            .decode(fetchedData)
                            .map<String>((e) => e.toString())
                            .toList();
                        _breedSelected = _breeds.first;
                        _speciesSelected = newValue;
                      });
                    }).catchError((error) {
                      log('Error fetching data: $error');
                    });
                  },
            items: _species.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(addSpaces(value)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget breedInput(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * .01),
      child: Center(
        child: DropdownButton<String>(
          value: _breedSelected,
          style: const TextStyle(fontSize: 19),
          underline: Container(
            height: 2,
            color: constants.MyColors.grey,
          ),
          menuMaxHeight: 300,
          onChanged: !_inEditMode
              ? null
              : (String? newValue) {
                  setState(() => _breedSelected = newValue!);
                },
          items: _breeds.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(addSpaces(value)),
            );
          }).toList(),
        ),
        // ],
      ),
    );
  }

  Widget genderInput(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * .01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                _genderSelected == 'Male' ? Icons.male : Icons.female,
                size: 20,
                color: Colors.pinkAccent,
              ),
              const Text(
                ' Gender',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
          DropdownButton<String>(
            value: _genderSelected,
            style: const TextStyle(fontSize: 18),
            underline: Container(
              height: 2,
              color: constants.MyColors.grey,
            ),
            onChanged: !_inEditMode
                ? null
                : (String? newValue) {
                    setState(() {
                      _genderSelected = newValue!;
                    });
                  },
            items: ['Male', 'Female']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget birthdayInput(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * .01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(
                Icons.calendar_today,
                color: Colors.blue,
                size: 20,
              ),
              Text(
                ' Birthday',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          SizedBox(
            width: size.width * .3,
            child: TextField(
              enabled: _inEditMode,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'dd-mm-yyyy',
              ),
              style: const TextStyle(fontSize: 20),
              readOnly: true,
              controller: _dateController,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );

                if (pickedDate != null) {
                  setState(() {
                    _dateController.text =
                        DateFormat('dd-MM-yyyy').format(pickedDate);
                  });
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget descriptionInput(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * .01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.description,
                color: Colors.amber,
                size: 20,
              ),
              Text(
                ' Description',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          SizedBox(
            height: size.height * .31,
            width: size.width * .8,
            child: Padding(
              padding: EdgeInsets.only(top: size.height * .025),
              child: TextField(
                enabled: _inEditMode,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black38,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black38,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  hintText: 'A short description of your pet',
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
