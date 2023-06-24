import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dogo_front/Helpers/fetches.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../Helpers/constants.dart';
import '../../../../Helpers/puts.dart';
import '../../../../entities/appointment.dart';
import '../../../../entities/person.dart';
import '../appointments_info/assign_salon.dart';
import '../appointments_info/assign_shopping.dart';
import '../appointments_info/assign_sitting.dart';
import '../appointments_info/assign_vet.dart';
import '../appointments_info/assign_walk.dart';
import '../available_appointments.dart';

class GeneratedAgenda extends StatefulWidget {
  const GeneratedAgenda({
    super.key,
    required this.user,
    required this.startDate,
    required this.endDate,
    required this.travelMode,
    required this.numberOfAppointments,
  });

  final Person user;

  final DateTime startDate;
  final DateTime endDate;
  final String travelMode;
  final int numberOfAppointments;

  @override
  State<GeneratedAgenda> createState() => _Page();
}

class _Page extends State<GeneratedAgenda> with SingleTickerProviderStateMixin {
  Person get _user => widget.user;
  DateTime get _startDate => widget.startDate;
  DateTime get _endDate => widget.endDate;
  String get _travelMode => widget.travelMode;
  int get _numberOfAppointments => widget.numberOfAppointments;

  bool _appointmentGenerated = false;

  var _appointments = <Appointment>[];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    fetchGeneratedAgenda(
            _user.id, _startDate, _endDate, _travelMode, _numberOfAppointments)
        .then((value) {
      if (value == null) {
        setState(() => _appointmentGenerated = true);
        return;
      }

      var appointments = json
          .decode(value)
          .map<Appointment>((e) => Appointment.fromJSON(e))
          .toList();

      setState(() {
        _appointments = appointments;
        _appointmentGenerated = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: getFloatingActionButtons(context),
      body: buildBody(context, size),
    );
  }

  getFloatingActionButtons(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 30),
            child: FloatingActionButton(
              onPressed: () => Navigator.pop(context),
              heroTag: 'back',
              backgroundColor: blackBlue,
              child: const Icon(Icons.arrow_back, color: darkGrey),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            onPressed: () {
              var count = 0;
              Navigator.popUntil(context, (route) => count++ == 3);
            },
            heroTag: 'check',
            backgroundColor: darkBlue,
            child: const Icon(Icons.check, color: darkGrey),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(left: 30),
            child: FloatingActionButton(
              onPressed: () {
                if (_appointments.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('There are no appointments to assign.'),
                      backgroundColor: MyColors.dustBlue,
                    ),
                  );
                  return;
                }

                acceptAppointment(context, 0);
              },
              heroTag: 'acceptAll',
              backgroundColor: dustBlue,
              child: const Icon(Icons.select_all, color: darkBlue),
            ),
          ),
        ),
      ],
    );
  }

  acceptAppointment(BuildContext context, int idx) {
    log('Accepting appointment');

    if (idx == _appointments.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Appointments assigned successfully'),
          backgroundColor: MyColors.dustGreen,
        ),
      );
      Future.delayed(const Duration(seconds: 1), () {
        var count = 0;
        Navigator.popUntil(context, (route) => count++ == 3);
      });
    }

    assignAppointment(_appointments[idx].id, _user.id).then((value) {
      if (value != HttpStatus.noContent) {
        log('Error accepting appointment');
      }
      acceptAppointment(context, idx + 1);
    });

    return true;
  }

  buildBody(BuildContext context, Size size) {
    return Stack(
      children: [
        SizedBox(height: size.height, width: size.width),
        banner(size),
        panel(size),
        getTitle(size),
        _appointmentGenerated
            ? displayCards(size)
            : const Center(child: CircularProgressIndicator()),
      ],
    );
  }

  Widget displayCards(Size size) {
    return Positioned(
      top: size.height * .2,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * .09,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: size.height * .7,
          ),
          child: SingleChildScrollView(child: cardsColumn(size)),
        ),
      ),
    );
  }

  Widget cardsColumn(Size size) {
    if (_appointments.isEmpty) {
      return noAppointmentaCard(
        size,
        MyColors.dustRed,
        const Icon(Icons.error_outline_rounded, color: darkGrey),
        'No appointments available',
        'Please try again later.',
        '',
        context,
      );
    }

    var cards = <Widget>[];
    for (var appointment in _appointments) {
      // cards.add(AppointmetCard(appointment: appointment, user: _user));
      cards.add(appointmentCard(context, appointment));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: cards,
    );
  }

  noAppointmentaCard(Size size, Color color, Icon icon, String title,
      String date, String status, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * .0025),
      child: Card(
        color: const Color.fromARGB(255, 47, 47, 47),
        child: SizedBox(
          height: size.height * .1,
          width: size.width * .8,
          child: Center(
            child: ListTile(
              onTap: () {
                // choseServicePage(context, title);
              },
              leading: CircleAvatar(
                backgroundColor: color,
                child: icon,
              ),
              title: Text(
                title,
                style: const TextStyle(
                    color: MyColors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    date,
                    style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                  Text(
                    status,
                    style: TextStyle(
                        color: _getColorOfStatus(status),
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget appointmentCard(BuildContext context, Appointment appointment) {
    Size size = MediaQuery.of(context).size;

    var dateStr =
        DateFormat('d MMM HH:mm').format(DateTime.parse(appointment.dateWhen));

    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * .0025),
      child: Card(
        color: const Color.fromARGB(255, 47, 47, 47),
        child: SizedBox(
          height: size.height * .1,
          width: size.width * .8,
          child: Center(
            child: ListTile(
              onTap: () {
                // choseAppointmentPage(context, appointment);
                log('Appointment tapped: ${appointment.toJSON().toString()}');
                choseAppointmentPage(context, appointment);
              },
              leading: CircleAvatar(
                  backgroundColor: _getColorOfType(appointment.type),
                  child: _getIconByType(appointment.type)),
              title: Text(
                '${appointment.type} Appointment',
                style: const TextStyle(
                    color: MyColors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dateStr,
                    style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                  Text(
                    appointment.status,
                    style: TextStyle(
                        color: _getColorOfStatus(appointment.status),
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  choseAppointmentPage(BuildContext context, Appointment appointment) {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        switch (appointment.type) {
          case walk:
            return AssignWalkAppointmentPage(
                user: _user, appointment: appointment);
          case salon:
            return AssignSalonAppointmentPage(
                user: _user, appointment: appointment);
          case sitting:
            return AssignSittingAppointmentPage(
                user: _user, appointment: appointment);
          case shopping:
            return AssignShoppingAppointmentPage(
                user: _user, appointment: appointment);
          case vet:
            return AssignVetAppointmentPage(
                user: _user, appointment: appointment);
          default:
            return AvailableAppointmentsPage(user: _user);
        }
      }),
    ).then((value) {
      if (value != null) {
        if (value) {
          _appointments.remove(appointment);
          setState(() {});
        }
      }
    });
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
            Text('Generates Agenda',
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

_getIconByType(String type) {
  switch (type) {
    case 'Walk':
      return const Icon(Icons.directions_walk, color: lightGrey);
    case 'Salon':
      return const Icon(Icons.cut, color: lightGrey);
    case 'Sitting':
      return const Icon(Icons.home, color: Colors.white);
    case 'Vet':
      return const Icon(Icons.local_hospital, color: lightGrey);
    case 'Shopping':
      return const Icon(Icons.shopping_cart, color: lightGrey);
    default:
      return const Icon(Icons.error, color: lightGrey);
  }
}

_getColorOfType(String type) {
  switch (type) {
    case 'Walk':
      return walkColor;
    case 'Salon':
      return salonColor;
    case 'Sitting':
      return sittingColor;
    case 'Vet':
      return vetColor;
    case 'Shopping':
      return shoppingColor;
    default:
      return MyColors.dustRed;
  }
}

_getColorOfStatus(String status) {
  switch (status) {
    case 'Pending':
      return MyColors.dustBlue;
    case 'Assigned':
      return Colors.green;
    case 'Completed':
      return MyColors.dustGreen;
    case 'Rejected':
      return MyColors.dustRed;
    case 'Canceled':
      return MyColors.dustRed;
    default:
      return MyColors.dustBlue;
  }
}
