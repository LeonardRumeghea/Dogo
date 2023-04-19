import 'package:flutter/material.dart';
import '../../../Helpers/constants.dart' as constants;

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _Page();
}

class _Page extends State<AgendaPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Agenda Page',
          style: TextStyle(
            color: constants.MyColors.grey,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
