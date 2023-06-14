import 'dart:convert';
import 'dart:developer';

import 'package:dogo_front/entities/appointment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../Helpers/fetches.dart';
import '../../../entities/person.dart';
import '../../../../Helpers/constants.dart' as constants;

import 'appointments_info/assign_walk.dart';
import 'appointments_info/assign_salon.dart';
import 'appointments_info/assign_vet.dart';
import 'appointments_info/assign_sitting.dart';
import 'appointments_info/assign_shopping.dart';

class AvailableAppointmentsPage extends StatefulWidget {
  const AvailableAppointmentsPage({super.key, required this.user});

  final Person user;

  @override
  State<AvailableAppointmentsPage> createState() => _Page();
}

class _Page extends State<AvailableAppointmentsPage>
    with SingleTickerProviderStateMixin {
  Person get _user => widget.user;
  var _availableAppointments = <Appointment>[];

  var _appointmentsLoaded = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() => _getAppointments();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: getFlotingButton(context),
      body: getBody(context, size),
    );
  }

  Widget getFlotingButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Not implemented yet! Coming soon!'),
            backgroundColor: constants.MyColors.dustRed,
          ),
        )
      },
      backgroundColor: constants.MyColors.darkBlue,
      child:
          const Icon(Icons.map_outlined, color: constants.MyColors.lightBlue),
    );
  }

  Widget getBody(BuildContext context, Size size) {
    return SingleChildScrollView(
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
              'Available Appointments',
              style: TextStyle(
                color: Color.fromARGB(255, 228, 228, 228),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _appointmentsLoaded
              ? displayCards(size)
              : const Center(
                  heightFactor: 12.5,
                  child: CircularProgressIndicator(),
                ),
        ],
      ),
    );
  }

  Widget displayCards(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * .09,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: size.height * .7,
        ),
        child: SingleChildScrollView(child: cardsColumn(size)),
      ),
    );
  }

  _getAppointments() {
    try {
      fetchAvailableAppoitments(_user.id).then((value) {
        var appointments = json
            .decode(value)
            .map<Appointment>((e) => Appointment.fromJSON(e))
            .toList();

        appointments.sort(
            (Appointment a, Appointment b) => a.dateWhen.compareTo(b.dateWhen));

        setState(() {
          _availableAppointments = appointments;
          _appointmentsLoaded = true;
        });
      });
    } catch (e) {
      log('Appointments Error: $e');
    }
  }

  Widget cardsColumn(Size size) {
    if (_availableAppointments.isEmpty) {
      return appointmentCard(
        size,
        constants.MyColors.dustRed,
        const Icon(Icons.error_outline_rounded, color: constants.darkGrey),
        'No appointments available',
        'Please try again later.',
        '',
        context,
      );
    }

    var cards = <Widget>[];
    for (var appointment in _availableAppointments) {
      cards.add(AppointmetCard(appointment: appointment, user: _user));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: cards,
    );
  }

  appointmentCard(Size size, Color color, Icon icon, String title, String date,
      String status, BuildContext context) {
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
                    color: constants.MyColors.grey,
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

  Widget panel(Size size) {
    return Positioned(
      top: size.height * .1,
      left: size.width * .05,
      child: Container(
        height: size.height * .785,
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

  banner(Size size) {
    return Container(
      height: size.height * .25,
      width: size.width,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(constants.borderRadius),
              bottomRight: Radius.circular(constants.borderRadius)),
          image: DecorationImage(
              image: AssetImage('assets/images/main_menu_bg.png'),
              fit: BoxFit.cover)),
      child: Container(
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
      return const Icon(Icons.directions_walk, color: constants.lightGrey);
    case 'Salon':
      return const Icon(Icons.cut, color: constants.lightGrey);
    case 'Sitting':
      return const Icon(Icons.home, color: Colors.white);
    case 'Vet':
      return const Icon(Icons.local_hospital, color: constants.lightGrey);
    case 'Shopping':
      return const Icon(Icons.shopping_cart, color: constants.lightGrey);
    default:
      return const Icon(Icons.error, color: constants.lightGrey);
  }
}

_getColorOfType(String type) {
  switch (type) {
    case 'Walk':
      return constants.walkColor;
    case 'Salon':
      return constants.salonColor;
    case 'Sitting':
      return constants.sittingColor;
    case 'Vet':
      return constants.vetColor;
    case 'Shopping':
      return constants.shoppingColor;
    default:
      return constants.MyColors.dustRed;
  }
}

_getColorOfStatus(String status) {
  switch (status) {
    case 'Pending':
      return constants.MyColors.dustBlue;
    case 'Assigned':
      return Colors.green;
    case 'Completed':
      return constants.MyColors.dustGreen;
    case 'Rejected':
      return constants.MyColors.dustRed;
    case 'Canceled':
      return constants.MyColors.dustRed;
    default:
      return constants.MyColors.dustBlue;
  }
}

class AppointmetCard extends StatelessWidget {
  const AppointmetCard(
      {Key? key, required this.appointment, required this.user})
      : super(key: key);

  final Appointment appointment;
  final Person user;

  @override
  Widget build(BuildContext context) {
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
                choseAppointmentPage(context, appointment);
              },
              leading: CircleAvatar(
                  backgroundColor: _getColorOfType(appointment.type),
                  child: _getIconByType(appointment.type)),
              title: Text(
                '${appointment.type} Appointment',
                style: const TextStyle(
                    color: constants.MyColors.grey,
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
          case constants.walk:
            return AssignWalkAppointmentPage(
                user: user, appointment: appointment);
          case constants.salon:
            return AssignSalonAppointmentPage(
                user: user, appointment: appointment);
          case constants.sitting:
            return AssignSittingAppointmentPage(
                user: user, appointment: appointment);
          case constants.shopping:
            return AssignShoppingAppointmentPage(
                user: user, appointment: appointment);
          case constants.vet:
            return AssignVetAppointmentPage(
                user: user, appointment: appointment);
          default:
            return AvailableAppointmentsPage(user: user);
        }
      }),
    ); //.then((value) {
    // if (value != null) {
    // _getAppointments();
    // }
    // });
  }
}
