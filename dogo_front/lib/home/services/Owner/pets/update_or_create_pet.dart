import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../../../../Helpers/constants.dart' as constants;

String petName = "Rex";
String petType = "Dog";
String petBreed = "German Shepherd";

DateTime petBirthDate = DateTime(2018, 10, 10);
double age = DateTime.now().difference(petBirthDate).inDays / 365;

String result = '';

class ManagePetPage extends StatefulWidget {
  const ManagePetPage({Key? key}) : super(key: key);

  @override
  State<ManagePetPage> createState() => _Page();
}

class _Page extends State<ManagePetPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String speciesSelected = '';
  String breedSelected = '';
  String genderSelected = 'Male';

  List<String> species = [];
  List<String> breeds = [];

  @override
  void initState() {
    super.initState();

    species = [];
    breeds = [];

    fetchSpecies().then((fetchedData) {
      setState(() {
        species =
            json.decode(fetchedData).map<String>((e) => e.toString()).toList();
        speciesSelected = species.first;

        print('Species: $species');
        print('Species selected: $speciesSelected');

        fetchBreeds(speciesSelected).then((fetchedData) {
          setState(() {
            breeds = json
                .decode(fetchedData)
                .map<String>((e) => e.toString())
                .toList();
            breedSelected = breeds.first;

            print('Breeds: $breeds');
            print('Breed selected: $breedSelected');
          });
        }).catchError((error) {
          print('Error fetching data: $error');
        });
      });
    }).catchError((error) {
      print('Error fetching data: $error');
    });
  }

  String addSpaces(String text) {
    return text
        .split('')
        .map((e) => e.toLowerCase() != e ? ' $e' : e)
        .join()
        .trim();
  }

  Future<String> fetchSpecies() async {
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://10.0.2.2:7077/api/v1/appointments/species?api-version=1'));
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
            'https://10.0.2.2:7077/api/v1/appointments/breeds?specie=$specie&api-version=1'));

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: const [
            Icon(
              Icons.emoji_emotions,
              size: 20,
              color: Colors.indigoAccent,
            ),
            Text(
              'Name',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
        SizedBox(
          width: size.width * .5,
          child: TextField(
            controller: nameController,
            style: const TextStyle(
              fontSize: 20,
            ),
            decoration: const InputDecoration(
              hintText: 'Enter your pet\'s name',
              hintStyle: TextStyle(
                fontSize: 18,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: constants.Colors.grey,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 2.0,
                  color: constants.Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget specieInput(Size size) {
    return Row(
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
              'Specie',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
        DropdownButton<String>(
          value: speciesSelected,
          style: const TextStyle(fontSize: 20),
          underline: Container(
            height: 2,
            color: constants.Colors.grey,
          ),
          menuMaxHeight: 300,
          onChanged: (String? newValue) {
            fetchBreeds(newValue!).then((fetchedData) {
              setState(() {
                breeds = json
                    .decode(fetchedData)
                    .map<String>((e) => e.toString())
                    .toList();
                breedSelected = breeds.first;
                speciesSelected = newValue;
              });
            }).catchError((error) {
              print('Error fetching data: $error');
            });
          },
          items: species.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(addSpaces(value)),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget breedInput(Size size) {
    return Center(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // crossAxisAlignment: CrossAxisAlignment.start,
      child: DropdownButton<String>(
        value: breedSelected,
        style: const TextStyle(fontSize: 20),
        underline: Container(
          height: 2,
          color: constants.Colors.grey,
        ),
        menuMaxHeight: 300,
        onChanged: (String? newValue) {
          setState(() {
            breedSelected = newValue!;
          });
        },
        items: breeds.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(addSpaces(value)),
          );
        }).toList(),
      ),
      // ],
    );
  }

  Widget genderInput(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              genderSelected == 'Male' ? Icons.male : Icons.female,
              size: 20,
              color: Colors.pinkAccent,
            ),
            const Text(
              'Gender',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
        DropdownButton<String>(
          value: genderSelected,
          style: const TextStyle(fontSize: 18),
          underline: Container(
            height: 2,
            color: constants.Colors.grey,
          ),
          onChanged: (String? newValue) {
            setState(() {
              genderSelected = newValue!;
            });
          },
          items:
              ['Male', 'Female'].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget birthdayInput(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: const [
            Icon(
              Icons.calendar_today,
              color: Colors.amberAccent,
              size: 20,
            ),
            Text(
              'Birthday',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        SizedBox(
          width: size.width * .3,
          child: TextField(
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'dd-mm-yyyy',
            ),
            style: const TextStyle(fontSize: 20),
            readOnly: true,
            controller: dateController,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );

              if (pickedDate != null) {
                setState(() {
                  dateController.text =
                      DateFormat('dd-MM-yyyy').format(pickedDate);
                });
              }
            },
          ),
        )
      ],
    );
  }

  Widget descriptionInput(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(
              Icons.description,
              color: Colors.green,
              size: 20,
            ),
            Text(
              'Description',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        SizedBox(
          height: size.height * .35,
          width: size.width * .8,
          child: Padding(
            padding: EdgeInsets.only(top: size.height * .025),
            child: TextField(
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
                hintText: 'A short description of your pet',
              ),
              style: const TextStyle(
                fontSize: 18,
              ),
              maxLines: 13,
              controller: descriptionController,
            ),
          ),
        ),
      ],
    );
  }

  Widget panel(Size size) => Positioned(
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

  Container banner(Size size) => Container(
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
