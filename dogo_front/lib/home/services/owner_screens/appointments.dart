import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
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

  bool _isCollapsed = true;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    final curvedAnimation = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: _animationController,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
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
      iconColor: constants.MyColors.grey,
      iconData: _isCollapsed ? Icons.add : Icons.close,
      onPress: () {
        _animationController.isCompleted
            ? _animationController.reverse()
            : _animationController.forward();

        setState(() => _isCollapsed = !_isCollapsed);
      },
      items: <Bubble>[
        Bubble(
          title: "Walk",
          iconColor: Colors.white,
          bubbleColor: constants.walkColor,
          icon: Icons.directions_walk,
          titleStyle: const TextStyle(fontSize: 18, color: Colors.white),
          onPress: () => bubblePress(context, constants.walk),
        ),
        Bubble(
          title: "Salon",
          iconColor: Colors.white,
          bubbleColor: constants.salonColor,
          icon: Icons.cut,
          titleStyle: const TextStyle(fontSize: 18, color: Colors.white),
          onPress: () => bubblePress(context, constants.salon),
        ),
        Bubble(
          title: "Sitting",
          iconColor: Colors.white,
          bubbleColor: constants.sittingColor,
          icon: Icons.home,
          titleStyle: const TextStyle(fontSize: 18, color: Colors.white),
          onPress: () => bubblePress(context, constants.sitting),
        ),
        Bubble(
          title: "Vet",
          iconColor: Colors.white,
          bubbleColor: constants.vetColor,
          icon: Icons.local_hospital,
          titleStyle: const TextStyle(fontSize: 18, color: Colors.white),
          onPress: () => bubblePress(context, constants.vet),
        ),
        Bubble(
          title: "Shopping",
          iconColor: Colors.white,
          bubbleColor: constants.shoppingColor,
          icon: Icons.shopping_cart,
          titleStyle: const TextStyle(fontSize: 18, color: Colors.white),
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
          maxHeight: size.height * .725,
        ),
        child: SingleChildScrollView(child: cardsColumn(size)),
      ),
    );
  }

  Widget cardsColumn(Size size) {
    var cards = <Widget>[];

    cards.add(petCard(
      size,
      Colors.blue,
      const Icon(Icons.directions_walk, color: Colors.white),
      'Doggo',
      '20/04/2023 12:30 PM',
      context,
    ));

    cards.add(petCard(
      size,
      Colors.purple,
      const Icon(Icons.cut, color: Colors.white),
      'Doggo',
      '20/04/2023 12:30 PM',
      context,
    ));

    cards.add(petCard(
      size,
      Colors.blue,
      const Icon(Icons.directions_walk, color: Colors.white),
      'Doggo',
      '20/04/2023 12:30 PM',
      context,
    ));

    cards.add(petCard(
      size,
      Colors.green,
      const Icon(Icons.home, color: Colors.white),
      'Doggo',
      '20/04/2023 12:30 PM',
      context,
    ));

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
              return const ScheduleSalonPage();
            case constants.sitting:
              return const ScheduleSittingPage();
            case constants.shopping:
              return const ScheduleShoppingPage();
            case constants.vet:
              return const ScheduleVetPage();
            default:
              return AppointmentsPage(user: _user);
          }
        },
      ),
    );
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
