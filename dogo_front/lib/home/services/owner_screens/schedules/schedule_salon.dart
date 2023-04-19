import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart' as picker;
// ignore: implementation_imports
import 'package:flutter_datetime_picker/src/datetime_picker_theme.dart';
import '../../../../Helpers/constants.dart' as constants;
import '../../../../Helpers/location_picker.dart';
import '../../../../entities/address.dart';

class ScheduleSalonPage extends StatefulWidget {
  const ScheduleSalonPage({super.key});

  @override
  State<ScheduleSalonPage> createState() => _Page();
}

class _Page extends State<ScheduleSalonPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  var _selectedAddress = Address();

  String _petName = 'Rex';
  String _duration = '10';
  var durations = ['10', '20', '30', '40', '50', '60', '90', '120'];

  var pets = ['Rex', 'Kitty', 'Buddy', 'Fido', 'Spot', 'Max', 'Bella'];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print('--> ScheduleWalkPage: floatingActionButton onPressed');
          print('petName: $_petName');
          print('date: ${_dateController.text}');
          print('location: ${_selectedAddress.toJson()}');
          print('note: ${_noteController.text}');

          if (_petName == '' ||
              _dateController.text == '' ||
              _locationController.text == '') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please fill all require fields'),
                backgroundColor: constants.MyColors.dustRed,
              ),
            );
            return;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Your appointment has been published!'),
                backgroundColor: constants.MyColors.dustGreen,
              ),
            );
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.pop(context);
            });
          }
        },
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
            DropdownButton<String>(
              value: _petName,
              style: const TextStyle(fontSize: 18),
              underline: Container(
                height: 2,
                color: constants.MyColors.grey,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  _petName = newValue!;
                });
              },
              items: pets.map<DropdownMenuItem<String>>((String value) {
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
                  : size.width * .31,
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
      currentTime: DateTime.now(),
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
              value: _duration,
              style: const TextStyle(fontSize: 18),
              underline: Container(
                height: 2,
                color: constants.MyColors.grey,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  _duration = newValue!;
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
