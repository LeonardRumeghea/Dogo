import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dogo_front/entities/appointment.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbols.dart';
import 'package:intl/intl.dart';
import '../../../../Helpers/constants.dart' as constants;
import '../../../../Helpers/fetches.dart';
import '../../../../Helpers/pets.dart';
import '../../../../entities/person.dart';
import '../../../../entities/pet.dart';

class AcceptWalkPage extends StatefulWidget {
  const AcceptWalkPage(
      {super.key, required this.user, required this.appointment});

  final Person user;
  final Appointment appointment;

  @override
  State<AcceptWalkPage> createState() => _Page();
}

class _Page extends State<AcceptWalkPage> {
  final _noteController = TextEditingController();

  Pet _pet = Pet();
  Person get _user => widget.user;
  Appointment get _appointment => widget.appointment;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    _getPet();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => acceptAppointment(context),
        backgroundColor: constants.MyColors.darkBlue,
        child: const Icon(
          Icons.done,
          color: constants.MyColors.grey,
        ),
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

  acceptAppointment(BuildContext context) {
    log('Accepting appointment');
  }

  _getPet() {
    fetchPet(_appointment.petId).then((value) {
      setState(() {
        _pet = Pet.fromJSON(json.decode(value));

        _noteController.text = _appointment.notes;
      });
    });
  }

  Widget panelContent(Size size) {
    return SizedBox(
      height: size.height * .8,
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: size.width * .09,
              bottom: size.height * .01,
            ),
            child: const Text(
              'Appointment info',
              style: TextStyle(
                color: Color.fromARGB(255, 228, 228, 228),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          getPetName(size),
          getDate(size),
          getLocation(size),
          getNote(size),
        ],
      ),
    );
  }

  Widget getPetName(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * .1, vertical: size.width * .025),
      child: SizedBox(
        width: size.width * .8,
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 66, 66, 66),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(color: Colors.black38, blurRadius: 10, spreadRadius: 2)
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(size.width * .025),
            child: Row(
              children: [
                const Icon(Icons.pets, size: 26, color: Colors.brown),
                const Text(
                  ' Pet:',
                  style: TextStyle(fontSize: 24, color: constants.darkGrey),
                ),
                Text(
                  ' ${_pet.name}',
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getLocation(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * .1, vertical: size.width * .025),
      child: SizedBox(
        width: size.width * .8,
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 66, 66, 66),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(color: Colors.black38, blurRadius: 10, spreadRadius: 2)
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(size.width * .025),
            child: Row(
              children: [
                const Icon(Icons.pets, size: 26, color: Colors.brown),
                const Text(
                  ' Location:',
                  style: TextStyle(fontSize: 24, color: constants.darkGrey),
                ),
                Text(
                  ' ${_pet.name}',
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getDate(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * .1, vertical: size.width * .025),
      child: SizedBox(
        width: size.width * .8,
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 66, 66, 66),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(color: Colors.black38, blurRadius: 10, spreadRadius: 2)
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(size.width * .025),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 26, color: Colors.blue),
                const Text(
                  ' Date:',
                  style: TextStyle(fontSize: 24, color: constants.darkGrey),
                ),
                Text(
                  ' ${DateFormat('d MMM HH:mm').format(DateTime.parse(_appointment.dateWhen))}',
                  style: const TextStyle(fontSize: 22, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getNote(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * .1),
      child: SizedBox(
        width: size.width * .8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(
                  Icons.note,
                  color: Colors.amber,
                  size: 20,
                ),
                Text(
                  ' Short note',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              height: size.height * .525,
              width: size.width * .8,
              child: Padding(
                padding: EdgeInsets.only(top: size.height * .025),
                child: TextField(
                  enabled: false,
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
                    hintText: 'Appointment note...',
                  ),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                  maxLines: 13,
                  controller: _noteController,
                ),
              ),
            ),
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
