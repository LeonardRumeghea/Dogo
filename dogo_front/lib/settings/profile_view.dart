import 'package:flutter/material.dart';
import '../Helpers/constants.dart' as constants;

String firstName = "Leonard";
String lastName = "Rumeghea";

String email = "leonard.rumeghea@gmail.com";
String phoneNumber = "0745-123-456";

String bio =
    "I am a dog lover and I have a dog myself. I have a lot of experience with dogs and I am very patient with them. I am available for walks and I can also take care of your dog at my place. I have a big garden and I can also take your dog to the park. I am available every day from 8 AM to 8 PM.";

String score = "4.7";
String numberOfReviews = "12";
String numberOfWalks = "29";

// Address
String streetName = "Bucium";
String streetNumber = "4";
String city = "Iasi";
String state = "Iasi";
String zipCode = "700000";
String otherDetails = "Near the park. Apartment 13 - 3rd floor";

String accountType = "Owner";

const String ownerType = "Owner";
const String walkerType = "Walker";

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
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
                profileImage(size),
                Positioned.fill(
                  top: size.height * .315,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      '$firstName $lastName',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 228, 228, 228),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                displayInfo(
                  const Icon(Icons.mail),
                  Colors.redAccent,
                  email,
                  size.height * 0.4,
                  size.width * 0.1,
                ),
                displayInfo(
                  const Icon(Icons.phone),
                  Colors.blueAccent,
                  phoneNumber,
                  size.height * 0.45,
                  size.width * 0.1,
                ),
                displayInfo(
                  const Icon(Icons.star),
                  Colors.amberAccent,
                  '$score stars',
                  size.height * 0.5,
                  size.width * 0.1,
                ),
                displayInfo(
                  const Icon(Icons.reviews),
                  Colors.green,
                  '$numberOfReviews reviews',
                  size.height * 0.55,
                  size.width * 0.1,
                ),
                displayInfo(
                  const Icon(Icons.directions_walk),
                  Colors.blueGrey,
                  '$numberOfWalks walks',
                  size.height * 0.6,
                  size.width * 0.1,
                ),
                displayInfo(
                  const Icon(Icons.location_on),
                  Colors.brown,
                  '$streetName $streetNumber, $city, $state, $zipCode',
                  size.height * 0.65,
                  size.width * 0.1,
                ),
                displayInfo(
                  const Icon(Icons.info),
                  Colors.indigo,
                  bio,
                  size.height * 0.7,
                  size.width * 0.1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget displayInfo(
      Icon icon, Color color, String info, double top, double left) {
    return Positioned(
      top: top,
      left: left,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon.icon,
            color: color,
            size: 24,
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 250,
            height: 175,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text(
                info,
                style: const TextStyle(
                  color: constants.Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget panel(Size size) => Positioned(
        top: size.height * .2,
        left: size.width * .05,
        child: Container(
          height: size.height * .75,
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

  Widget profileImage(Size size) => Stack(
        children: [
          SizedBox(
            height: size.height,
            width: size.width,
          ),
          Positioned(
            top: size.height * .1,
            left: size.width * .3,
            child: Container(
              height: size.width * .4,
              width: size.width * .4,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(90)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: size.height * .1 + size.width * .01,
            left: size.width * .31,
            child: Container(
              height: size.width * .38,
              width: size.width * .38,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(90)),
                color: Colors.grey,
              ),
            ),
          ),
        ],
      );

  Container banner(Size size) => Container(
        height: size.height * .375,
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
