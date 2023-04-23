import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import '../../../../Helpers/constants.dart' as constants;
import '../../../../Helpers/pots.dart';
import '../../../../entities/appointment.dart';
import '../../../../entities/person.dart';

class ScheduleShoppingPage extends StatefulWidget {
  const ScheduleShoppingPage({super.key, required this.user});

  final Person user;

  @override
  State<ScheduleShoppingPage> createState() => _Page();
}

class _Page extends State<ScheduleShoppingPage> {
  final TextEditingController _listController = TextEditingController();

  bool _displayInfo = true;

  Person get _user => widget.user;

  @override
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (_displayInfo) {
      Future.delayed(Duration.zero, () => showInfoDialog(context));
      _displayInfo = false;
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => createAppointment(context),
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

  createAppointment(BuildContext context) {
    log('--> ScheduleShoppingPage: createAppointment');
    log('list: $_listController.text');

    if (_listController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write your products list'),
          backgroundColor: constants.MyColors.dustRed,
        ),
      );
      return;
    }

    var appointment = Appointment(
      petId: _user.pets.first.id,
      dateWhen: DateTime.now().add(const Duration(minutes: 1)).toString(),
      dateUntil: DateTime.now().add(const Duration(minutes: 1)).toString(),
      notes: _listController.text,
      type: 'Shopping',
    );

    log('Appointment: $appointment');

    postAppoitment(appointment).then(
      (value) {
        if (value == HttpStatus.created) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your appointment has been published!'),
              backgroundColor: constants.MyColors.dustGreen,
            ),
          );
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pop(context);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('An error has occurred, please try again later'),
              backgroundColor: constants.MyColors.dustRed,
            ),
          );
        }
      },
    );
  }

  void showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tips'),
          content: const Text(
              'Try to be as descriptive as you can to increase effectiveness.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
            child: const Text(
              'Appointment Planner',
              style: TextStyle(
                color: Color.fromARGB(255, 228, 228, 228),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                writeList(size),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget writeList(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * .1,
        vertical: size.height * .02,
      ),
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
                Text(' Products', style: TextStyle(fontSize: 20)),
              ],
            ),
            SizedBox(
              height: size.height * .675,
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
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black38,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    hintText: 'Write your products here...',
                  ),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                  maxLines: 25,
                  controller: _listController,
                ),
              ),
            ),
          ],
        ),
      ),
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
