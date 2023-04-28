import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dogo_front/Helpers/puts.dart';
import 'package:dogo_front/entities/appointment.dart';
import 'package:flutter/material.dart';
import '../../../../Helpers/constants.dart' as constants;
import '../../../../Helpers/fetches.dart';
import '../../../../entities/person.dart';
import '../../../../entities/pet.dart';

class AssignShoppingAppointmentPage extends StatefulWidget {
  const AssignShoppingAppointmentPage(
      {super.key, required this.user, required this.appointment});

  final Person user;
  final Appointment appointment;

  @override
  State<AssignShoppingAppointmentPage> createState() => _Page();
}

class _Page extends State<AssignShoppingAppointmentPage> {
  Pet _pet = Pet();
  Person _petOwner = Person();

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

    assignAppointment(_appointment.id, _user.id).then((value) {
      if (value == HttpStatus.noContent) {
        log('Appointment accepted');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Appointment assigned successfully'),
            backgroundColor: constants.MyColors.dustGreen,
          ),
        );
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(context);
        });
      } else {
        log('Error accepting appointment');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong, try again later'),
            backgroundColor: constants.MyColors.dustRed,
          ),
        );
      }
    });
  }

  _getPet() {
    fetchPet(_appointment.petId).then((value) {
      setState(() {
        _pet = Pet.fromJSON(json.decode(value));
      });

      _getPetOwner();
    });
  }

  _getPetOwner() {
    fetchUser(_pet.ownerId).then((value) {
      setState(() {
        _petOwner = Person.fromJSON(json.decode(value));
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
                left: size.width * .09, bottom: size.height * .01),
            child: Container(
              width: size.width * .8,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 1),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  children: const [
                    Icon(
                      Icons.shopping_cart,
                      color: constants.shoppingColor,
                      size: 32,
                    ),
                    Text(
                      ' Shopping info:',
                      style: TextStyle(
                        color: Color.fromARGB(255, 228, 228, 228),
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          getLocation(size),
          getNote(size),
        ],
      ),
    );
  }

  Widget getLocation(Size size) {
    return GestureDetector(
      onTap: () {
        log('Location tapped');
        log(_petOwner.address.toString());
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * .1, vertical: size.width * .025),
        child: SizedBox(
          width: size.width * .8,
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 66, 66, 66),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black38, blurRadius: 10, spreadRadius: 2)
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(size.width * .025),
              child: Row(
                children: const [
                  Icon(Icons.location_pin, size: 26, color: Colors.red),
                  Text(
                    ' Delivery location:',
                    style: TextStyle(
                      fontSize: 24,
                      color: constants.darkGrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getNote(Size size) {
    String note =
        _appointment.notes == '' ? 'No notes added yet.' : _appointment.notes;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * .1, vertical: size.width * .025),
      child: SizedBox(
        width: size.width * .8,
        height: size.height * .6,
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
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 1),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Row(
                      children: const [
                        Icon(Icons.list, size: 26, color: Colors.amber),
                        Text(
                          ' List:',
                          style: TextStyle(
                            fontSize: 24,
                            color: constants.darkGrey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: size.height * .5,
                    child: Text(
                      note,
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
