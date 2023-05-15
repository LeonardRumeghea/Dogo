import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart' as picker;
// ignore: implementation_imports
import 'package:flutter_datetime_picker/src/datetime_picker_theme.dart';
import '../../../../Helpers/constants.dart' as constants;
import '../../../../Helpers/screens/location_picker.dart';
import '../../../../Helpers/pets.dart';
import '../../../../entities/address.dart';
import '../../../../entities/appointment.dart';
import '../../../../entities/person.dart';
import '../../../../entities/pet.dart';

class ScheduleVetPage extends StatefulWidget {
  const ScheduleVetPage({super.key, required this.user});

  final Person user;

  @override
  State<ScheduleVetPage> createState() => _Page();
}

class _Page extends State<ScheduleVetPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  var _selectedAddress = Address();
  var _fullDate = DateTime.now();

  late Pet _selectedPet;
  late String _selectedDuration;

  var durations = ['10', '20', '30', '40', '50', '60', '90', '120'];
  late var _pets = <Pet>[];

  Person get _user => widget.user;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    _pets = _user.pets;
    _selectedPet = _pets.first;
    _selectedDuration = durations.first;
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
    log('--> ScheduleWalkPage: createAppointment');
    log('petName: $_selectedPet.name');
    log('dateTime: ${_fullDate.toString()}');
    log('duration: $_selectedDuration');
    log('address: $_selectedAddress');
    log('notes: ${_noteController.text}');

    if (_selectedPet.name == '' ||
        _dateController.text == '' ||
        _selectedDuration == '' ||
        _selectedAddress.street == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all require fields'),
          backgroundColor: constants.MyColors.dustRed,
        ),
      );
      return;
    }

    var dateTime = DateTime(_fullDate.year, _fullDate.month, _fullDate.day,
        _fullDate.hour, _fullDate.minute);

    var appointment = Appointment(
      petId: _selectedPet.id,
      dateWhen: dateTime.toString(),
      dateUntil: dateTime.toString(),
      duration: int.parse(_selectedDuration),
      notes: _noteController.text,
      type: 'Vet',
    );
    appointment.address = Address.copyOf(_selectedAddress);

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
              left: size.width * .09,
              bottom: size.height * .01,
            ),
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
                selectDate(size),
                setDuration(size),
                getLocation(size),
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
      padding: EdgeInsets.symmetric(horizontal: size.width * .1),
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

  Widget selectDate(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * .1),
      child: SizedBox(
        width: size.width * .8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: Colors.blue,
                ),
                Text(
                  ' Date',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: _dateController.text == ''
                  ? size.width * .35
                  : size.width * .32,
              child: TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'tap to select...',
                ),
                style: const TextStyle(fontSize: 20),
                readOnly: true,
                controller: _dateController,
                onTap: () => showDateTimePicker(_dateController),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> showDateTimePicker(TextEditingController controller) async {
    await picker.DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      currentTime: _fullDate,
      minTime: DateTime.now(),
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
          _fullDate = date;
        });
      },
    );
  }

  Widget setDuration(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * .1),
      child: SizedBox(
        width: size.width * .8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Icon(
                  Icons.timer,
                  size: 20,
                  color: Colors.green,
                ),
                Text(
                  ' Duration',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(
                  ' (min)',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 163, 163, 163),
                  ),
                )
              ],
            ),
            DropdownButton<String>(
              value: _selectedDuration,
              style: const TextStyle(fontSize: 18),
              underline: Container(
                height: 2,
                color: constants.MyColors.grey,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDuration = newValue!;
                });
              },
              items: durations.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
      ),
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PageLocationPicker(),
                    ),
                  ).then(
                    (value) => {
                      if (value != null)
                        {
                          _selectedAddress = value,
                          _locationController.text = 'Selected!'
                        }
                    },
                  );
                },
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
        vertical: size.height * .01,
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
              height: size.height * .4,
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
