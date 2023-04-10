import 'package:flutter/material.dart';
import '../Helpers/constants.dart' as app_colors;
import '../settings/profile_view.dart' as profile_view;

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
          body: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: size.height,
                    width: size.width,
                  ),
                  gradientContainer(size),
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
                      icon: const Icon(Icons.person_2_outlined),
                      color: app_colors.Colors.darkBlue,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const profile_view.ProfilePage()),
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
            ],
          ),
        );
      },
    );
  }

  Container gradientContainer(Size size) {
    return Container(
      height: size.height * .25,
      width: size.width,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(app_colors.borderRadius),
              bottomRight: Radius.circular(app_colors.borderRadius)),
          image: DecorationImage(
              image: AssetImage('assets/images/main_menu_bg.png'),
              fit: BoxFit.cover)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(app_colors.borderRadius),
              bottomRight: Radius.circular(app_colors.borderRadius)),
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 5, 78, 213).withOpacity(0.7),
              const Color.fromARGB(255, 18, 227, 221).withOpacity(0.7)
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileTypes extends StatelessWidget {
  const ProfileTypes({
    Key? key,
  }) : super(key: key);

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
          topLeft: Radius.circular(app_colors.borderRadius),
          topRight: Radius.circular(app_colors.borderRadius),
        ),
        color: Colors.white.withOpacity(0.025),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Profile Types",
            style: TextStyle(
              color: app_colors.Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          const Divider(
            color: app_colors.Colors.grey,
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CardWidget(
                  icon: Icon(
                    Icons.pets,
                    color: accountType == ownerType
                        ? app_colors.Colors.dustBlue
                        : app_colors.Colors.darkBlue,
                  ),
                  title: ownerType),
              CardWidget(
                  icon: Icon(
                    Icons.directions_walk,
                    color: accountType == walkerType
                        ? app_colors.Colors.dustBlue
                        : app_colors.Colors.darkBlue,
                  ),
                  title: walkerType),
            ],
          ),
        ],
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final Icon icon;
  final String title;
  const CardWidget({Key? key, required this.icon, required this.title})
      : super(key: key);

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
                  color: app_colors.Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              onTap: () {
                if (title == accountType) {
                  return;
                }

                accountType = title;
                // refresh page to show new services
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const Page(),
                  ),
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
  const SericesGridDashboard({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return accountType == ownerType
        ? ownerServices(context)
        : walkerServices(context);
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
                color: app_colors.Colors.grey,
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
                  cardText(
                    size,
                    Colors.blue,
                    const Icon(
                      Icons.directions_walk_rounded,
                      color: Colors.white,
                    ),
                    'Walk',
                    'Find someone to walk your pet or make a later appointment.',
                  ),
                  cardText(
                    size,
                    Colors.purple,
                    const Icon(
                      // icon for pet salon,
                      Icons.cut,
                      color: Colors.white,
                    ),
                    'Salon Visit',
                    'Reserve a walker for a future visit to the salon of your pet',
                  ),
                  cardText(
                    size,
                    Colors.green,
                    const Icon(
                      // icon for pet salon,
                      Icons.house,
                      color: Colors.white,
                    ),
                    'Pet Sitting',
                    'While you are away, a walker will care for your pet at home.',
                  ),
                  cardText(
                    size,
                    Colors.red,
                    const Icon(
                      // icon for pet salon,
                      Icons.shopping_bag,
                      color: Colors.white,
                    ),
                    'Pet Shopping',
                    'One walker will manage all of the pet\'s shopping needs.',
                  ),
                  cardText(
                    size,
                    Colors.amber,
                    const Icon(
                      // icon for pet salon,
                      Icons.local_hospital,
                      color: Colors.white,
                    ),
                    'Vet Care',
                    'Plan a visit or find someone for a brief emergency',
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
                color: app_colors.Colors.grey,
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
                  cardText(
                    size,
                    Colors.blue,
                    const Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                    ),
                    'Your Agenda',
                    'Your schedule for the day with all the tasks you need to do.',
                  ),
                  cardText(
                    size,
                    Colors.purple,
                    const Icon(
                      Icons.calendar_month,
                      color: Colors.white,
                    ),
                    'Search for Appointments',
                    'View the services offered for the upcoming term and select your favorites.',
                  ),
                  cardText(
                    size,
                    Colors.green,
                    const Icon(
                      Icons.room_preferences,
                      color: Colors.white,
                    ),
                    'Yout Preferences',
                    'For better compatibility, configure your settings for the following schedules.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

cardText(
  Size size,
  Color color,
  Icon icon,
  String title,
  String subtitle,
) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: size.height * .0025),
    child: Card(
      child: SizedBox(
        height: size.height * .1,
        width: size.width * .9,
        child: Center(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: color,
              child: icon,
            ),
            title: Text(
              title,
              style: const TextStyle(
                  color: app_colors.Colors.grey,
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
