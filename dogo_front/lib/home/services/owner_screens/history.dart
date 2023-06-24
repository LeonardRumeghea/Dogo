import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../Helpers/constants.dart' as constants;
import '../../../Helpers/constants.dart';
import '../../../Helpers/fetches.dart';
import '../../../entities/appointment.dart';
import '../../../entities/person.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key, required this.user});

  final Person user;

  @override
  State<HistoryPage> createState() => _Page();
}

class _Page extends State<HistoryPage> {
  Person get _user => widget.user;

  var _appointments = <Appointment>[];
  var _appoitmentsFetched = false;

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  _fetchAppointments() {
    fetchCompletedAppointments(_user.id).then((value) {
      if (value == null) {
        setState(() => _appoitmentsFetched = true);
        return;
      }

      var appointments = json
          .decode(value)
          .map<Appointment>((e) => Appointment.fromJSON(e))
          .toList();

      appointments.sort(
          (Appointment a, Appointment b) => a.dateWhen.compareTo(b.dateWhen));

      setState(() {
        _appointments = appointments;
        _appoitmentsFetched = true;
      });
    }).catchError((error) {
      log('Error in fetchAppointments function: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: buildBody(context, size),
    );
  }

  buildBody(BuildContext context, Size size) {
    return Stack(
      children: [
        SizedBox(
          height: size.height,
        ),
        banner(size),
        panel(size),
        getTitle(size),
        _appoitmentsFetched
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
        constants.MyColors.dustRed,
        const Icon(Icons.error_outline_rounded, color: constants.darkGrey),
        'No appointments completed yet',
        'Add a new one from search page',
        '',
        context,
      );
    }

    var cards = <Widget>[];
    for (var appointment in _appointments) {
      cards.add(appointmentCard(context, appointment));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: cards,
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
            Text(' History',
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
      case 'InProgress':
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

  panel(Size size) {
    return Positioned(
      top: size.height * .1,
      left: size.width * .05,
      child: Container(
        height: size.height * .85,
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
