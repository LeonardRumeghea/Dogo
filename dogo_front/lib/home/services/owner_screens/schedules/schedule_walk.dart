import 'dart:developer';
import 'dart:io';
import 'package:dogo_front/entities/appointment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../Helpers/constants.dart' as constants;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart' as picker;
// ignore: implementation_imports
import 'package:flutter_datetime_picker/src/datetime_picker_theme.dart';
import '../../../../Helpers/pets.dart';
import '../../../../entities/person.dart';
import '../../../../entities/pet.dart';

class ScheduleWalkPage extends StatefulWidget {
  const ScheduleWalkPage({super.key, required this.user});

  final Person user;

  @override
  State<ScheduleWalkPage> createState() => _Page();
}

class _Page extends State<ScheduleWalkPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  Pet _selectedPet = Pet();

  DateTime _fullDate = DateTime.now();
  String _selectedDuration = '';

  Person get _user => widget.user;
  final _durations = ['10', '20', '30', '40', '50', '60', '90', '120'];
  List<Pet> _pets = <Pet>[];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    setState(() {
      _pets = _user.pets;
      _selectedPet = _pets[0];
    });

    _selectedDuration = _durations.first;

    log('User: $_user');
    log('Pets: $_pets');
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
    log('petName: $_selectedPet');
    log('date: ${_dateController.text}');
    log('time: ${_timeController.text}');
    log('note: ${_noteController.text}');

    if (_selectedPet.name == '') {
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
      dateUntil: dateTime
          .add(Duration(minutes: int.parse(_selectedDuration)))
          .toString(),
      notes: _noteController.text,
      type: 'Walk',
    );
    // appointment.address = _user.address!;

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
              'Schedule a walk',
              style: TextStyle(
                color: Color.fromARGB(255, 228, 228, 228),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          selectPet(size),
          selectDateTime(size),
          setDuration(size),
          writeNote(size),
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
              onChanged: (Pet? newValue) {
                setState(() => _selectedPet = newValue!);
              },
              items: _pets.map((Pet pet) {
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
              width: size.width * .3,
              child: TextField(
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
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
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
      ),
    );
  }

  Widget selectHour(Size size) {
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
                  ' Hour',
                  style: TextStyle(
                    fontSize: 20,
                  ),
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
                controller: _timeController,
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (pickedTime != null) {
                    setState(() {
                      _timeController.text = pickedTime.format(context);
                    });
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget selectDateTime(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * .1),
      child: SizedBox(
        width: size.width * .8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Icon(Icons.calendar_today, size: 20, color: Colors.blue),
                Text(' Date', style: TextStyle(fontSize: 20)),
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
              items: _durations.map<DropdownMenuItem<String>>((String value) {
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

  Widget writeNote(Size size) {
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
