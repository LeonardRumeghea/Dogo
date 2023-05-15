import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart' as picker;
// ignore: implementation_imports
import 'package:flutter_datetime_picker/src/datetime_picker_theme.dart';
import '../../../../Helpers/constants.dart' as constants;
import '../../../../Helpers/pets.dart';
import '../../../../entities/appointment.dart';
import '../../../../entities/person.dart';
import '../../../../entities/pet.dart';

class ScheduleSittingPage extends StatefulWidget {
  const ScheduleSittingPage({super.key, required this.user});

  final Person user;

  @override
  State<ScheduleSittingPage> createState() => _Page();
}

class _Page extends State<ScheduleSittingPage> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  DateTime _fromDateFull = DateTime.now();
  DateTime _toDateFull = DateTime.now();

  Person get _user => widget.user;
  late Pet _selectedPet;
  late List<Pet> _pets;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    _pets = _user.pets;
    _selectedPet = _pets.first;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => createAppointment(context),
        backgroundColor: constants.MyColors.darkBlue,
        child: const Icon(
          Icons.done,
          color: constants.MyColors.lightBlue,
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
    log('--> ScheduleSittingPage: createAppointment');
    log('petName: $_selectedPet.name');
    log('dateFrom: ${_fromController.text}');
    log('dateTo: ${_toController.text}');
    log('note: ${_noteController.text}');

    if (_selectedPet.name == '' ||
        _fromController.text == '' ||
        _toController.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all require fields'),
          backgroundColor: constants.MyColors.dustRed,
        ),
      );
      return;
    }

    var dateWhen =
        DateFormat('yyyy-MM-dd HH:mm').parse(_fromDateFull.toString());
    var dateUntil =
        DateFormat('yyyy-MM-dd HH:mm').parse(_toDateFull.toString());

    var appointment = Appointment(
      petId: _selectedPet.id,
      dateWhen: dateWhen.toString(),
      dateUntil: dateUntil.toString(),
      notes: _noteController.text,
      type: 'Sitting',
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
                selectPet(size),
                selectFromDateTime(size),
                selectToDateTime(size),
                writeNote(size),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget selectPet(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * .1, vertical: size.height * .005),
      child: SizedBox(
        width: size.width * .8,
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
                  ' Pet',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            DropdownButton<Pet>(
              value: _selectedPet,
              style: const TextStyle(fontSize: 18),
              underline: Container(
                height: 2,
                color: constants.MyColors.grey,
              ),
              onChanged: (Pet? newPet) {
                setState(() => _selectedPet = newPet!);
              },
              items: _pets.map<DropdownMenuItem<Pet>>((Pet pet) {
                return DropdownMenuItem<Pet>(
                  value: pet,
                  child: Text(pet.name),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget selectFromDateTime(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * .1, vertical: size.height * .005),
      child: SizedBox(
        width: size.width * .8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Icon(Icons.calendar_today, size: 20, color: Colors.blue),
                Text(' From', style: TextStyle(fontSize: 20)),
              ],
            ),
            SizedBox(
              width: _fromController.text == ''
                  ? size.width * .35
                  : size.width * .32,
              child: TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'tap to select...',
                ),
                style: const TextStyle(fontSize: 20),
                readOnly: true,
                controller: _fromController,
                onTap: () => showDateTimePicker(_fromController, 'from'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget selectToDateTime(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * .1, vertical: size.height * .005),
      child: SizedBox(
        width: size.width * .8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Icon(Icons.calendar_today,
                    size: 20, color: Colors.indigoAccent),
                Text(' To', style: TextStyle(fontSize: 20)),
              ],
            ),
            SizedBox(
              width: _toController.text == ''
                  ? size.width * .35
                  : size.width * .32,
              child: TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'tap to select...',
                ),
                style: const TextStyle(fontSize: 20),
                readOnly: true,
                controller: _toController,
                onTap: () => showDateTimePicker(_toController, 'to'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> showDateTimePicker(
      TextEditingController controller, String dateType) async {
    await picker.DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      currentTime: dateType == 'from' ? _fromDateFull : _toDateFull,
      minTime: dateType == 'from'
          ? DateTime.now()
          : _fromDateFull.add(const Duration(minutes: 10)),
      maxTime: DateTime.now().add(const Duration(days: 90)),
      theme: const DatePickerTheme(
        cancelStyle:
            TextStyle(color: constants.MyColors.darkBlue, fontSize: 16),
        doneStyle: TextStyle(color: constants.MyColors.dustBlue, fontSize: 16),
        itemStyle:
            TextStyle(color: Color.fromARGB(255, 228, 228, 228), fontSize: 18),
        backgroundColor: Color.fromARGB(255, 46, 46, 46),
      ),
      onConfirm: (date) {
        setState(() {
          controller.text = DateFormat('d MMM').add_Hm().format(date);
          if (dateType == 'from') {
            _fromDateFull = date;
            if (_toDateFull.compareTo(_fromDateFull) < 0) {
              _toDateFull = _fromDateFull.add(const Duration(minutes: 10));
              _toController.text =
                  DateFormat('d MMM').add_Hm().format(_toDateFull);
            }
          } else {
            _toDateFull = date;
            if (_toDateFull.compareTo(_fromDateFull) < 0) {
              _fromDateFull = _toDateFull.subtract(const Duration(minutes: 10));
              _fromController.text =
                  DateFormat('d MMM').add_Hm().format(_fromDateFull);
            }
          }
        });
      },
    );
  }

  Widget getLocation(Size size) {
    String hitMessage = 'Not selected';
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * .1),
      child: SizedBox(
        width: size.width * .8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: ,
              children: const [
                Icon(
                  Icons.location_on,
                  size: 20,
                  color: Colors.red,
                ),
                Text(
                  ' Location',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: _locationController.text == ''
                  ? size.width * .32
                  : size.width * .23,
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hitMessage,
                ),
                style: const TextStyle(fontSize: 20, color: Colors.green),
                readOnly: true,
                controller: _locationController,
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget writeNote(Size size) {
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
              children: [
                const Icon(
                  Icons.note,
                  color: Colors.amber,
                  size: 20,
                ),
                Row(
                  children: const [
                    Text(' Notes', style: TextStyle(fontSize: 20)),
                    Text(
                      ' (optional)',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 163, 163, 163),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: size.height * .45,
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
