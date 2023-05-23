import 'dart:convert';

import 'package:flutter/material.dart';
import '../Helpers/constants.dart' as constants;
import '../Helpers/fetches.dart';
import '../entities/person.dart';
import '../entities/pet.dart';
import '../settings/profile_view.dart' as profile_view;

// services page for the owner implementation
import 'services/owner_screens/pets/pets.dart';
import 'services/owner_screens/appointments.dart';
import 'services/owner_screens/history.dart';

// services page for the walker implementation
import 'services/walker/agenda.dart';
import 'services/walker/available_appointments.dart';
import 'services/walker/preferences.dart';

const String ownerType = "Owner";
const String walkerType = "Walker";

class ServicesPage extends StatefulWidget {
  const ServicesPage({Key? key, required this.user}) : super(key: key);

  final Person user;

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  @override
  initState() {
    super.initState();
    init();
  }

  Person get _user => widget.user;
  String _accountType = "";

  init() {
    _accountType = ownerType;

    fetchPets(_user.id).then((value) => _user.pets =
        json.decode(value).map<Pet>((e) => Pet.fromJSON(e)).toList());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Builder(
      builder: (context) {
        return Scaffold(
          body: Stack(
            children: [
              SizedBox(
                height: size.height,
                width: size.width,
              ),
              _banner(size),
              Positioned(
                top: size.height * .15,
                left: size.width * .05,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Home",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        )),
                    Text(
                      "Welcome back, ${_user.firstName}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: size.height * .025,
                width: size.width * 1.85,
                child: IconButton(
                  icon: const Icon(Icons.person),
                  color: constants.MyColors.darkBlue,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const profile_view.ProfilePage()));
                  },
                  iconSize: 32,
                ),
              ),
              Positioned(
                top: size.height * .25,
                child: _sericesGridDashboard(size),
              ),
              Positioned(bottom: 0, width: size.width, child: _profiles())
            ],
          ),
        );
      },
    );
  }

  _banner(Size size) {
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

  _sericesGridDashboard(Size size) {
    var ownerServices = <Widget>[
      _serviceCard(
        context,
        size,
        "Manage Your Pets",
        "Set up the pet profiles. Add your pets and their details.",
        Icon(Icons.pets, color: Colors.brown, size: size.height * .08),
        true,
      ),
      _serviceCard(
        context,
        size,
        'Appointments',
        'Manage your appointments and schedule new ones.',
        Icon(Icons.schedule, color: Colors.green[800], size: size.height * .08),
        false,
      ),
      _serviceCard(
        context,
        size,
        'History & Reports',
        'View your pet\'s history and reports.',
        Icon(Icons.history, color: Colors.amber, size: size.height * .08),
        true,
      ),
    ];

    var walkerServices = <Widget>[
      _serviceCard(
        context,
        size,
        'Your Agenda',
        'View the appointments you\'ve chosen from the upcoming timeframe.',
        Icon(Icons.calendar_today, color: Colors.blue, size: size.height * .08),
        true,
      ),
      _serviceCard(
        context,
        size,
        'Search Appointment',
        'Look for appointments in the near future.',
        Icon(Icons.calendar_month,
            color: Colors.purple, size: size.height * .08),
        false,
      ),
      _serviceCard(
        context,
        size,
        'Your Preferences',
        'Set your preferences for a more customized experience.',
        Icon(Icons.room_preferences,
            color: Colors.green, size: size.height * .08),
        true,
      ),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(
        // horizontal: size.width * .05,
        vertical: size.height * .025,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              bottom: size.height * .025,
              left: size.width * .05,
            ),
            child: const Text(
              "Available Services",
              style: TextStyle(
                color: constants.MyColors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: size.height * .5,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:
                    _accountType == ownerType ? ownerServices : walkerServices,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _serviceCard(BuildContext context, Size size, String title, String details,
      Icon icon, bool onRight) {
    var cardInfo = onRight
        ? <Widget>[
            _getServiceIcon(icon, size),
            _getServiceInfo(title, details, size)
          ]
        : <Widget>[
            _getServiceInfo(title, details, size),
            _getServiceIcon(icon, size)
          ];

    var cardPadding = EdgeInsets.only(
      top: size.height * .0125,
      bottom: size.height * .0125,
      left: onRight ? size.width * .15 : 0,
      right: !onRight ? size.width * .15 : 0,
    );

    var cardBorderRadius = BorderRadius.only(
      topLeft: Radius.circular(onRight ? constants.borderRadius : 0),
      bottomLeft: Radius.circular(onRight ? constants.borderRadius : 0),
      topRight: Radius.circular(!onRight ? constants.borderRadius : 0),
      bottomRight: Radius.circular(!onRight ? constants.borderRadius : 0),
    );

    var cardDecoration = BoxDecoration(
      color: const Color.fromARGB(255, 66, 66, 66),
      borderRadius: cardBorderRadius,
      boxShadow: const [
        BoxShadow(color: Colors.black38, blurRadius: 10, spreadRadius: 2),
      ],
    );

    return Padding(
      padding: cardPadding,
      child: GestureDetector(
        onTap: () => _choseServicePage(context, title),
        child: Container(
          height: size.height * .14,
          width: size.width * .85,
          decoration: cardDecoration,
          child: Center(child: Row(children: cardInfo)),
        ),
      ),
    );
  }

  _getServiceIcon(Icon icon, Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * .02),
      child: icon,
    );
  }

  _getServiceInfo(String title, String details, Size size) {
    return SizedBox(
      width: size.width * .6,
      height: size.height * .14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          Text(
            details,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  _choseServicePage(BuildContext context, String serviceName) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        switch (serviceName) {
          case 'Manage Your Pets':
            return ManageYourPetsPage(user: _user);
          case 'Your Agenda':
            return AgendaPage(user: _user);
          case 'Search Appointment':
            return AvailableAppointmentsPage(user: _user);
          case 'Your Preferences':
            return const PreferencesPage();
          case 'Appointments':
            return AppointmentsPage(user: _user);
          case 'History & Reports':
            return HistoryPage(user: _user);
          default:
            return ServicesPage(user: _user);
        }
      }),
    );
  }

  _profiles() {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * .05,
        vertical: size.height * .0125,
      ),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(constants.borderRadius),
          topRight: Radius.circular(constants.borderRadius),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black38, blurRadius: 10, spreadRadius: 1)
        ],
        color: Color.fromARGB(255, 53, 53, 53),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Profile Types",
              style: TextStyle(
                  color: constants.MyColors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 17)),
          const Divider(color: constants.MyColors.grey, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _profileCard(size, Icons.pets, ownerType),
              _profileCard(size, Icons.directions_walk, walkerType),
            ],
          ),
        ],
      ),
    );
  }

  _profileCard(Size size, IconData icon, String title) {
    var color = _accountType == title
        ? constants.MyColors.dustBlue
        : constants.MyColors.darkBlue;

    return Card(
      child: SizedBox(
        height: 50,
        width: size.width * .40,
        child: Center(
          child: ListTile(
            horizontalTitleGap: 0,
            leading: Icon(icon, color: color),
            title: Text(title,
                style: const TextStyle(
                    color: constants.MyColors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
            onTap: () => setState(() => _accountType = title),
          ),
        ),
      ),
    );
  }
}
