import 'package:flutter/material.dart';
import '../Helpers/constants.dart' as constants;
import '../settings/profile_view.dart' as profile_view;

// services page for the owner implementation
import 'services/owner_screens/walk/walk.dart';
import 'services/owner_screens/sitting/sitting.dart';
import 'services/owner_screens/shopping/shopping.dart';
import 'services/owner_screens/salon/salon.dart';
import 'services/owner_screens/vet/vet.dart';
import 'services/owner_screens/pets/pets.dart';

// services page for the walker implementation
import './services/Walker/agenda.dart';
import './services/Walker/search.dart';
import './services/Walker/preferences.dart';
// import './services/Walker/requests.dart';

String profileName = "Leonard";
String accountType = "Owner";

const String ownerType = "Owner";
const String walkerType = "Walker";

class Page extends StatelessWidget {
  const Page({Key? key}) : super(key: key);

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
                      "Welcome back, $profileName",
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
                  color: constants.Colors.darkBlue,
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
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(constants.borderRadius),
          topRight: Radius.circular(constants.borderRadius),
        ),
        color: Colors.white.withOpacity(0.025),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Profile Types",
            style: TextStyle(
              color: constants.Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          const Divider(
            color: constants.Colors.grey,
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CardButton(
                  icon: Icon(
                    Icons.pets,
                    color: accountType == ownerType
                        ? constants.Colors.dustBlue
                        : constants.Colors.darkBlue,
                  ),
                  title: ownerType),
              CardButton(
                  icon: Icon(
                    Icons.directions_walk,
                    color: accountType == walkerType
                        ? constants.Colors.dustBlue
                        : constants.Colors.darkBlue,
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
                  color: constants.Colors.grey,
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
                      builder: (BuildContext context) => const Page()),
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
        horizontal: size.width * .05,
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
                color: constants.Colors.grey,
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
                  serviceCard(
                    size,
                    Colors.brown,
                    const Icon(
                      Icons.pets,
                      color: Colors.white,
                    ),
                    'Manage Your Pets',
                    'Set up the pet profiles. Add your pets and their details.',
                    context,
                  ),
                  serviceCard(
                    size,
                    Colors.blue,
                    const Icon(
                      Icons.directions_walk_rounded,
                      color: Colors.white,
                    ),
                    'Walk',
                    'Find someone to walk your pet or make a later appointment.',
                    context,
                  ),
                  serviceCard(
                    size,
                    Colors.purple,
                    const Icon(
                      // icon for pet salon,
                      Icons.cut,
                      color: Colors.white,
                    ),
                    'Salon Visit',
                    'Reserve a walker for a future visit to the salon of your pet',
                    context,
                  ),
                  serviceCard(
                    size,
                    Colors.green,
                    const Icon(
                      // icon for pet salon,
                      Icons.house,
                      color: Colors.white,
                    ),
                    'Pet Sitting',
                    'While you are away, a walker will care for your pet at home.',
                    context,
                  ),
                  serviceCard(
                    size,
                    Colors.red,
                    const Icon(
                      // icon for pet salon,
                      Icons.shopping_bag,
                      color: Colors.white,
                    ),
                    'Pet Shopping',
                    'One walker will manage all of the pet\'s shopping needs.',
                    context,
                  ),
                  serviceCard(
                    size,
                    Colors.amber,
                    const Icon(
                      // icon for pet salon,
                      Icons.local_hospital,
                      color: Colors.white,
                    ),
                    'Vet Care',
                    'Plan a visit or find someone for a brief emergency',
                    context,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget walkerServices(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * .05,
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
                color: constants.Colors.grey,
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
                  serviceCard(
                    size,
                    Colors.blue,
                    const Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                    ),
                    'Your Agenda',
                    'Your schedule for the day with all the tasks you need to do.',
                    context,
                  ),
                  serviceCard(
                    size,
                    Colors.purple,
                    const Icon(
                      Icons.calendar_month,
                      color: Colors.white,
                    ),
                    'Search for Appointments',
                    'View the services offered for the upcoming term and select your favorites.',
                    context,
                  ),
                  serviceCard(
                    size,
                    Colors.green,
                    const Icon(
                      Icons.room_preferences,
                      color: Colors.white,
                    ),
                    'Your Preferences',
                    'For better compatibility, configure your settings for the following schedules.',
                    context,
                  ),
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
                    color: constants.Colors.grey,
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
            return const ManageYourPetsPage();
          case 'Walk':
            return const WalkPage();
          case 'Salon Visit':
            return const SalonVisitPage();
          case 'Pet Sitting':
            return const PetSittingPage();
          case 'Pet Shopping':
            return const PetShoppingPage();
          case 'Vet Care':
            return const VetCarePage();
          case 'Your Agenda':
            return const AgendaPage();
          case 'Search for Appointments':
            return const SearchForAppointmentsPage();
          case 'Your Preferences':
            return const PreferencesPage();
          default:
            return const Page();
        }
      }),
    );
  }
}
