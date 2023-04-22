import 'dart:developer';

import 'package:flutter/material.dart';
import '../../../../Helpers/constants.dart' as constants;
import '../../../../entities/person.dart';
import '../../../../entities/pet.dart';
import 'update_or_create_pet.dart';

String petName = "Rex";
String petType = "Dog";
String petBreed = "German Shepherd";

DateTime petBirthDate = DateTime(2018, 10, 10);
double age = DateTime.now().difference(petBirthDate).inDays / 365;

class ManageYourPetsPage extends StatefulWidget {
  const ManageYourPetsPage({super.key, required this.user});

  final Person user;

  @override
  State<ManageYourPetsPage> createState() => _Page();
}

class _Page extends State<ManageYourPetsPage> {
  Person get _user => widget.user;
  var _userPets = <Pet>[];

  @override
  void initState() {
    super.initState();
    log('User: $_user');
    log('Pets: ${_user.pets}');
    _userPets = _user.pets;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ManagePetPage(user: _user),
            ),
          ).then((_) => setState(() => _userPets = _user.pets));
        },
        backgroundColor: constants.MyColors.darkBlue,
        child: const Icon(
          Icons.add,
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
              'Your Pets:',
              style: TextStyle(
                color: Color.fromARGB(255, 228, 228, 228),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          displayCards(size),
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

  Widget cardsColumn(Size size) {
    if (_userPets.isEmpty) {
      return petCard(
        size,
        constants.MyColors.dustRed,
        const Icon(Icons.error_outline_rounded, color: Colors.white),
        'No pets registered yet',
        'Please add a pet to your account',
        context,
      );
    }

    var cards = <Widget>[];
    for (Pet pet in _userPets) {
      cards.add(petCard(
        size,
        Colors.brown,
        const Icon(Icons.pets, color: Colors.white),
        pet.name,
        '${pet.specie}, ${pet.breed}',
        context,
      ));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: cards,
    );
  }

  petCard(Size size, Color color, Icon icon, String title, String subtitle,
      BuildContext context) {
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
