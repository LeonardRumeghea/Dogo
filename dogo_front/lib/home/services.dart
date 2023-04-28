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

// services page for the walker implementation
import './services/Walker/agenda.dart';
// import './services/Walker/search.dart';
import './services/Walker/available_appointments.dart';
import './services/Walker/preferences.dart';

String profileName = "Leonard";
String accountType = "Owner";

const String ownerType = "Owner";
const String walkerType = "Walker";

Person _user = Person();

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

  init() {
    _user = widget.user;

    fetchPets(_user.id).then((value) => _user.pets =
        json.decode(value).map<Pet>((e) => Pet.fromJSON(e)).toList());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Builder(
      builder: (context) {
        return Scaffold(
          body: //Column(
              // children: [
              Stack(
            children: [
              SizedBox(
                height: size.height,
                width: size.width,
              ),
              banner(size),
              Positioned(
                top: size.height * .15,
                left: size.width * .05,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Home",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 32),
                    ),
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
                        builder: (context) => const profile_view.ProfilePage(),
                      ),
                    );
                  },
                  iconSize: 32,
                ),
              ),
              Positioned(
                top: size.height * .25,
                child: SericesGridDashboard(size: size),
              ),
              Positioned(
                bottom: 0,
                width: size.width,
                child: const ProfileTypes(),
              )
            ],
          ),
          // ],
          // ),
        );
      },
    );
  }

  Container banner(Size size) {
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

class ProfileTypes extends StatelessWidget {
  const ProfileTypes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          BoxShadow(
            color: Colors.black38,
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
        color: Color.fromARGB(255, 53, 53, 53),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Profile Types",
            style: TextStyle(
              color: constants.MyColors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          const Divider(
            color: constants.MyColors.grey,
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CardButton(
                  icon: Icon(
                    Icons.pets,
                    color: accountType == ownerType
                        ? constants.MyColors.dustBlue
                        : constants.MyColors.darkBlue,
                  ),
                  title: ownerType),
              CardButton(
                  icon: Icon(
                    Icons.directions_walk,
                    color: accountType == walkerType
                        ? constants.MyColors.dustBlue
                        : constants.MyColors.darkBlue,
                  ),
                  title: walkerType),
            ],
          ),
        ],
      ),
    );
  }
}

class CardButton extends StatelessWidget {
  const CardButton({Key? key, required this.icon, required this.title})
      : super(key: key);

  final Icon icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
      child: GestureDetector(
        onTap: () {},
        child: SizedBox(
          height: 50,
          width: size.width * .40,
          child: Center(
            child: ListTile(
              horizontalTitleGap: 0,
              leading: icon,
              title: Text(
                title,
                style: const TextStyle(
                  color: constants.MyColors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              onTap: () {
                if (accountType == title) {
                  return;
                }
                accountType = title;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ServicesPage(user: _user)),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class SericesGridDashboard extends StatelessWidget {
  const SericesGridDashboard({Key? key, required this.size}) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return accountType == ownerType
        ? ownerServices(context)
        : walkerServices(context);
  }

  Widget displayOwnerServices(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 10, bottom: 5),
          child: Text(
            "My Pets",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                customCard(size, context),
                customCard(size, context),
                customCard(size, context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Padding customCard(Size size, context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: GestureDetector(
        onTap: () => {},
        child: Container(
          height: size.height * .15,
          width: size.width * .5,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.black.withOpacity(0.3),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 15, top: size.height * .12),
              child: const Text(
                'Room',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget ownerServices(BuildContext context) {
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
                children: <Widget>[
                  petsManagementCard(context, size),
                  appointmentsCard(context, size),
                  historyCard(context, size),
                  // serviceCard(
                  //   size,
                  //   Colors.brown,
                  //   const Icon(
                  //     Icons.pets,
                  //     color: Colors.white,
                  //   ),
                  //   'Manage Your Pets',
                  //   'Set up the pet profiles. Add your pets and their details.',
                  //   context,
                  // ),
                  // serviceCard(
                  //   size,
                  //   Colors.teal,
                  //   const Icon(
                  //     Icons.schedule,
                  //     color: Colors.white,
                  //   ),
                  //   'Appointments',
                  //   'Visually see your appointments and manage them.',
                  //   context,
                  // ),
                  // serviceCard(
                  //   size,
                  //   Colors.blue,
                  //   const Icon(
                  //     Icons.directions_walk_rounded,
                  //     color: Colors.white,
                  //   ),
                  //   'Walk',
                  //   'Find someone to walk your pet or make a later appointment.',
                  //   context,
                  // ),
                  // serviceCard(
                  //   size,
                  //   Colors.purple,
                  //   const Icon(
                  //     // icon for pet salon,
                  //     Icons.cut,
                  //     color: Colors.white,
                  //   ),
                  //   'Salon Visit',
                  //   'Reserve a walker for a future visit to the salon of your pet',
                  //   context,
                  // ),
                  // serviceCard(
                  //   size,
                  //   Colors.green,
                  //   const Icon(
                  //     // icon for pet salon,
                  //     Icons.house,
                  //     color: Colors.white,
                  //   ),
                  //   'Pet Sitting',
                  //   'While you are away, a walker will care for your pet at home.',
                  //   context,
                  // ),
                  // serviceCard(
                  //   size,
                  //   Colors.red,
                  //   const Icon(
                  //     // icon for pet salon,
                  //     Icons.shopping_bag,
                  //     color: Colors.white,
                  //   ),
                  //   'Pet Shopping',
                  //   'One walker will manage all of the pet\'s shopping needs.',
                  //   context,
                  // ),
                  // serviceCard(
                  //   size,
                  //   Colors.amber,
                  //   const Icon(
                  //     // icon for pet salon,
                  //     Icons.local_hospital,
                  //     color: Colors.white,
                  //   ),
                  //   'Vet Care',
                  //   'Plan a visit or find someone for a brief emergency',
                  //   context,
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget petsManagementCard(BuildContext context, Size size) {
    return Padding(
      padding: EdgeInsets.only(
        top: size.height * .0125,
        bottom: size.height * .0125,
        left: size.width * .15,
      ),
      child: InkWell(
        onTap: () => choseServicePage(context, 'Manage Your Pets'),
        child: Container(
          height: size.height * .14,
          width: size.width * .85,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 66, 66, 66),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * .02),
                  child: Icon(
                    Icons.pets,
                    color: Colors.brown,
                    size: size.height * .08,
                  ),
                ),
                SizedBox(
                  width: size.width * .6,
                  height: size.height * .14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Manage Your Pets',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Set up the pet profiles. Add your pets and their details.',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget appointmentsCard(BuildContext context, Size size) {
    return Padding(
      padding: EdgeInsets.only(
        top: size.height * .0125,
        bottom: size.height * .0125,
        right: size.width * .15,
      ),
      child: InkWell(
        onTap: () => choseServicePage(context, 'Appointments'),
        child: Container(
          height: size.height * .14,
          width: size.width * .85,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 66, 66, 66),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Row(
              children: [
                SizedBox(
                  width: size.width * .6,
                  height: size.height * .14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Appointments',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Manage your appointments and schedule new ones.',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * .02),
                  child: Icon(
                    Icons.schedule,
                    color: Colors.green[800],
                    size: size.height * .08,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget historyCard(BuildContext context, Size size) {
    return Padding(
      padding: EdgeInsets.only(
        top: size.height * .0125,
        bottom: size.height * .0125,
        left: size.width * .15,
      ),
      child: InkWell(
        onTap: () => choseServicePage(context, 'History'),
        child: Container(
          height: size.height * .14,
          width: size.width * .85,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 66, 66, 66),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * .02),
                  child: Icon(
                    Icons.history,
                    color: Colors.amber,
                    size: size.height * .08,
                  ),
                ),
                SizedBox(
                  width: size.width * .6,
                  height: size.height * .14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'History and Reports',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'View your pet\'s history and reports.',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget yourAgendaCard(BuildContext context, Size size) {
    return Padding(
      padding: EdgeInsets.only(
        top: size.height * .0125,
        bottom: size.height * .0125,
        left: size.width * .15,
      ),
      child: InkWell(
        onTap: () => choseServicePage(context, 'Your Agenda'),
        child: Container(
          height: size.height * .14,
          width: size.width * .85,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 66, 66, 66),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * .02),
                  child: Icon(
                    Icons.calendar_today,
                    color: Colors.blue,
                    size: size.height * .08,
                  ),
                ),
                SizedBox(
                  width: size.width * .6,
                  height: size.height * .14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Your Agenda',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'View the appointments you\'ve chosen from the upcoming timeframe.',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget searchAppointmentCard(BuildContext context, Size size) {
    return Padding(
      padding: EdgeInsets.only(
        top: size.height * .0125,
        bottom: size.height * .0125,
        right: size.width * .15,
      ),
      child: InkWell(
        onTap: () => choseServicePage(context, 'Search Appointment'),
        child: Container(
          height: size.height * .14,
          width: size.width * .85,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 66, 66, 66),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Row(
              children: [
                SizedBox(
                  width: size.width * .6,
                  height: size.height * .14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Search Appointment',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Choose to generate an automated route or look for an appointment in the near future.',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * .02),
                  child: Icon(
                    Icons.calendar_month,
                    color: Colors.purple,
                    size: size.height * .08,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget yourPreferencesCard(BuildContext context, Size size) {
    return Padding(
      padding: EdgeInsets.only(
        top: size.height * .0125,
        bottom: size.height * .0125,
        left: size.width * .15,
      ),
      child: InkWell(
        onTap: () => choseServicePage(context, 'Your Preferences'),
        child: Container(
          height: size.height * .14,
          width: size.width * .85,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 66, 66, 66),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * .02),
                  child: Icon(
                    Icons.room_preferences,
                    color: Colors.green,
                    size: size.height * .08,
                  ),
                ),
                SizedBox(
                  width: size.width * .6,
                  height: size.height * .14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Your Preferences',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'For a more personalized experience, set your preferences for the upcoming timeframe.',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget walkerServices(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        // horizontal: size.width * .05,
        vertical: size.height * .025,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: Text(
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
                children: <Widget>[
                  yourAgendaCard(context, size),
                  searchAppointmentCard(context, size),
                  yourPreferencesCard(context, size),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  serviceCard(Size size, Color color, Icon icon, String title, String subtitle,
      BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * .0025),
      child: Card(
        child: SizedBox(
          height: size.height * .1,
          width: size.width * .9,
          child: Center(
            child: ListTile(
              onTap: () {
                choseServicePage(context, title);
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
              subtitle: Text(
                subtitle,
                style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 13),
              ),
            ),
          ),
        ),
      ),
    );
  }

  choseServicePage(BuildContext context, String serviceName) {
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
          default:
            return ServicesPage(user: _user);
        }
      }),
    );
  }
}
