import 'dart:developer';

import 'package:dogo_front/home/services/walker/generate_agenda/generated_agenda.dart';
import 'package:flutter/material.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart' as picker;
// ignore: implementation_imports
import 'package:flutter_datetime_picker/src/datetime_picker_theme.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../../../Helpers/constants.dart';
import '../../../../entities/person.dart';

class GenerateAgendaPreferences extends StatefulWidget {
  const GenerateAgendaPreferences({super.key, required this.user});

  final Person user;

  @override
  State<GenerateAgendaPreferences> createState() => _Page();
}

class _Page extends State<GenerateAgendaPreferences>
    with SingleTickerProviderStateMixin {
  Person get _user => widget.user;

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  String _travelMode = 'walking';

  int _numberOfAppointments = 0;

  DateTime _dateStart = DateTime.now();
  DateTime _dateEnd = DateTime.now();

  late double _verticalSpacing;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    setState(() => _verticalSpacing = size.height * .02);
    return Scaffold(
      floatingActionButton: buildFloatingActionButtons(context),
      body: buildBody(context, size),
    );
  }

  buildFloatingActionButtons(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomRight,
          child: nextScreenButton(context),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 30),
            child: FloatingActionButton(
              onPressed: () => Navigator.pop(context),
              backgroundColor: blackBlue,
              heroTag: 'back',
              child: const Icon(Icons.arrow_back, color: darkGrey),
            ),
          ),
        ),
      ],
    );
  }

  nextScreenButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        log('Start Date : ${_dateStart.toString()}');
        log('End Date : ${_dateEnd.toString()}');
        log('Travel Mode : $_travelMode');
        log('Number of Appointments : $_numberOfAppointments');

        if (_startDateController.text == '' ||
            _endDateController.text == '' ||
            _numberOfAppointments == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please fill in all the fields'),
              backgroundColor: dustRed,
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GeneratedAgenda(
                  user: _user,
                  startDate: _dateStart,
                  endDate: _dateEnd,
                  travelMode: _travelMode,
                  numberOfAppointments: _numberOfAppointments),
            ),
          );
        }
      },
      heroTag: 'next',
      backgroundColor: darkBlue,
      child: const Icon(Icons.arrow_forward, color: Colors.white),
    );
  }

  buildBody(BuildContext context, Size size) {
    return Stack(
      children: [
        SizedBox(width: size.width, height: size.height),
        banner(size),
        panel(size),
        getTitle(size),
        getSettings(size),
      ],
    );
  }

  getTitle(Size size) {
    return Positioned(
      top: size.height * .125,
      left: size.width * .1,
      child: SizedBox(
        width: size.width * .8,
        height: size.height * .1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Generate Agenda',
                style: TextStyle(
                    color: darkGrey,
                    fontSize: 30,
                    fontWeight: FontWeight.bold)),
            Divider(color: darkGrey, thickness: 2),
          ],
        ),
      ),
    );
  }

  getSettings(Size size) {
    return Positioned(
      top: size.height * .2,
      child: SizedBox(
        height: size.height * .675,
        child: SingleChildScrollView(
          child: Column(
            children: [
              getDate(' Start Date', size, _startDateController, _dateStart),
              getDate(' End Date', size, _endDateController, _dateEnd),
              getTravelMode(size),
              const Divider(color: darkGrey, thickness: 2),
              getNumberOfAppointments(size),
            ],
          ),
        ),
      ),
    );
  }

  Widget getDate(String label, Size size, TextEditingController controller,
      DateTime fullDate) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * .1, vertical: _verticalSpacing),
      child: SizedBox(
        width: size.width * .8,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 15,
                      backgroundColor: darkBlue,
                      child: Icon(Icons.calendar_today_outlined,
                          size: 20, color: darkGrey),
                    ),
                    Text(label, style: const TextStyle(fontSize: 22)),
                  ],
                ),
                SizedBox(
                  width: controller.text == ''
                      ? size.width * .35
                      : size.width * .32,
                  child: TextField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'tap to select...',
                    ),
                    style: const TextStyle(fontSize: 20),
                    readOnly: true,
                    controller: controller,
                    onTap: () => showDateTimePicker(
                        controller, label == ' Start Date' ? true : false),
                  ),
                )
              ],
            ),
            const Divider(color: darkGrey, thickness: 2),
          ],
        ),
      ),
    );
  }

  Future<void> showDateTimePicker(
      TextEditingController controller, bool startDate) async {
    await picker.DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      currentTime: startDate ? _dateStart : _dateEnd,
      minTime: DateTime.now().add(const Duration(minutes: 10)),
      maxTime: DateTime.now().add(const Duration(days: 90)),
      theme: const DatePickerTheme(
        cancelStyle: TextStyle(color: MyColors.darkBlue, fontSize: 16),
        doneStyle: TextStyle(color: MyColors.dustBlue, fontSize: 16),
        itemStyle:
            TextStyle(color: Color.fromARGB(255, 228, 228, 228), fontSize: 18),
        backgroundColor: Color.fromARGB(255, 46, 46, 46),
      ),
      onConfirm: (date) {
        setState(() {
          controller.text = DateFormat('d MMM').add_Hm().format(date);
          if (startDate) {
            _dateStart = date;
          } else {
            _dateEnd = date;
          }
        });
      },
    );
  }

  getTravelMode(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: _verticalSpacing, horizontal: size.width * .1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              CircleAvatar(
                radius: 15,
                backgroundColor: darkBlue,
                child: Icon(Icons.directions_walk, size: 20, color: darkGrey),
              ),
              Text(' Travel Mode:', style: TextStyle(fontSize: 22)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: size.width * .4,
                child: ListTile(
                  horizontalTitleGap: 0,
                  title: const Text('Walk', style: TextStyle(fontSize: 20)),
                  leading: Radio(
                    value: 'walking',
                    groupValue: _travelMode,
                    activeColor: dustBlue,
                    onChanged: (value) =>
                        setState(() => _travelMode = value.toString()),
                  ),
                ),
              ),
              SizedBox(
                width: size.width * .4,
                child: ListTile(
                  horizontalTitleGap: 0,
                  title: const Text('Drive', style: TextStyle(fontSize: 20)),
                  leading: Radio(
                    value: 'driving',
                    groupValue: _travelMode,
                    activeColor: dustBlue,
                    onChanged: (value) =>
                        setState(() => _travelMode = value.toString()),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  getNumberOfAppointments(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: _verticalSpacing, horizontal: size.width * .1),
      child: SizedBox(
        width: size.width * .8,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: const [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: darkBlue,
                      child: Icon(Icons.format_list_numbered,
                          size: 20, color: darkGrey),
                    ),
                    Text(' How many:', style: TextStyle(fontSize: 22)),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    // color: Colors.white,
                    border: Border.all(color: darkGrey, width: 1),
                  ),
                  child: NumberPicker(
                    value: _numberOfAppointments,
                    minValue: 0,
                    maxValue: 100,
                    axis: Axis.horizontal,
                    itemWidth: size.width * .1,
                    itemHeight: size.height * .05,
                    selectedTextStyle: const TextStyle(
                        color: dustBlue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    onChanged: (value) =>
                        setState(() => _numberOfAppointments = value),
                  ),
                ),
              ],
            ),
            const Divider(color: darkGrey, thickness: 2),
          ],
        ),
      ),
    );
  }

  panel(Size size) {
    return Positioned(
      top: size.height * .1,
      left: size.width * .05,
      child: Container(
        height: size.height * .785,
        width: size.width * .9,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
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
              bottomLeft: Radius.circular(borderRadius),
              bottomRight: Radius.circular(borderRadius)),
          image: DecorationImage(
              image: AssetImage('assets/images/main_menu_bg.png'),
              fit: BoxFit.cover)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(borderRadius),
              bottomRight: Radius.circular(borderRadius)),
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
