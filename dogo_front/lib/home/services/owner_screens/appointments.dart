import 'dart:convert';
import 'dart:developer';

import 'package:dogo_front/entities/appointment.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../Helpers/fetches.dart';
import '../../../Helpers/screens/view_walker_location.dart';
import '../../../entities/person.dart';
import './schedules/schedule.dart';
import '../../../../Helpers/constants.dart' as constants;

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key, required this.user});

  final Person user;

  @override
  State<AppointmentsPage> createState() => _Page();
}

class _Page extends State<AppointmentsPage>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  Person get _user => widget.user;
  var _appointments = <Appointment>[];

  bool _isCollapsed = true;

  var _appointmentsLoaded = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    final curvedAnimation = CurvedAnimation(
      curve: Curves.easeInToLinear,
      parent: _animationController,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    _getAppointments();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: getFlotingButton(context),
      body: getBody(context, size),
    );
  }

  Widget getFlotingButton(BuildContext context) {
    return FloatingActionBubble(
      animation: _animation,
      backGroundColor: _isCollapsed
          ? constants.MyColors.darkBlue
          : constants.MyColors.blackBlue,
      iconColor: constants.MyColors.lightBlue,
      iconData: _isCollapsed ? Icons.add : Icons.close,
      onPress: () {
        if (_user.pets.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('To make an appointment, you must register a pet.'),
              backgroundColor: constants.MyColors.dustRed,
            ),
          );
          return;
        }

        _animationController.isCompleted
            ? _animationController.reverse()
            : _animationController.forward();

        setState(() => _isCollapsed = !_isCollapsed);
      },
      items: <Bubble>[
        Bubble(
          title: "Walk",
          iconColor: constants.lightGrey,
          bubbleColor: constants.walkColor,
          icon: Icons.directions_walk,
          titleStyle: const TextStyle(fontSize: 18, color: constants.lightGrey),
          onPress: () => bubblePress(context, constants.walk),
        ),
        Bubble(
          title: "Salon",
          iconColor: constants.lightGrey,
          bubbleColor: constants.salonColor,
          icon: Icons.cut,
          titleStyle: const TextStyle(fontSize: 18, color: constants.lightGrey),
          onPress: () => bubblePress(context, constants.salon),
        ),
        Bubble(
          title: "Sitting",
          iconColor: constants.lightGrey,
          bubbleColor: constants.sittingColor,
          icon: Icons.home,
          titleStyle: const TextStyle(fontSize: 18, color: constants.lightGrey),
          onPress: () => bubblePress(context, constants.sitting),
        ),
        Bubble(
          title: "Vet",
          iconColor: constants.lightGrey,
          bubbleColor: constants.vetColor,
          icon: Icons.local_hospital,
          titleStyle: const TextStyle(fontSize: 18, color: constants.lightGrey),
          onPress: () => bubblePress(context, constants.vet),
        ),
        Bubble(
          title: "Shopping",
          iconColor: constants.lightGrey,
          bubbleColor: constants.shoppingColor,
          icon: Icons.shopping_cart,
          titleStyle: const TextStyle(fontSize: 18, color: constants.lightGrey),
          onPress: () => bubblePress(context, constants.shopping),
        ),
        // Floating action menu item
      ],
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
              'Appointments',
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
      fetchAppoitments(_user.id).then((value) {
        var appointments = json
            .decode(value)
            .map<Appointment>((e) => Appointment.fromJSON(e))
            .toList();

        setState(() {
          _appointments = appointments;
          _appointmentsLoaded = true;
        });
      });
    } catch (e) {
      log('Appointments Error: $e');
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

  Widget cardsColumn(Size size) {
    if (_appointments.isEmpty) {
      return petCard(
        size,
        constants.MyColors.dustRed,
        const Icon(Icons.error_outline_rounded, color: constants.darkGrey),
        'No appointments found',
        'Use the + button to add one',
        '',
        context,
        Appointment(),
      );
    }

    var cards = <Widget>[];
    for (var appointment in _appointments) {
      var dateStr = DateFormat('d MMM HH:mm')
          .format(DateTime.parse(appointment.dateWhen));

      cards.add(
        petCard(
            size,
            _getColorOfType(appointment.type),
            _getIconByType(appointment.type),
            _user.pets
                .singleWhere((element) => element.id == appointment.petId)
                .name,
            dateStr,
            appointment.status,
            context,
            appointment),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: cards,
    );
  }

  petCard(Size size, Color color, Icon icon, String title, String date,
      String status, BuildContext context, Appointment appointment) {
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
                log('Appointment: ${appointment.toString()}');
                if (appointment.status == 'InProgress') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ViewWalkerLocation(appointment: appointment)));
                }
              },
              leading: CircleAvatar(backgroundColor: color, child: icon),
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

  choseSchedulePage(BuildContext context, String serviceName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          switch (serviceName) {
            case constants.walk:
              return ScheduleWalkPage(
                user: _user,
              );
            case constants.salon:
              return ScheduleSalonPage(user: _user);
            case constants.sitting:
              return ScheduleSittingPage(user: _user);
            case constants.shopping:
              return ScheduleShoppingPage(user: _user);
            case constants.vet:
              return ScheduleVetPage(user: _user);
            default:
              return AppointmentsPage(user: _user);
          }
        },
      ),
    ).then((_) => _getAppointments());
  }

  bubblePress(BuildContext context, String serviceName) {
    _animationController.reverse();
    setState(() => _isCollapsed = !_isCollapsed);
    choseSchedulePage(context, serviceName);
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
