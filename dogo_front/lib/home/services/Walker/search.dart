import 'package:flutter/material.dart';
import '../../../Helpers/constants.dart' as constants;

class SearchForAppointmentsPage extends StatefulWidget {
  const SearchForAppointmentsPage({super.key});

  @override
  State<SearchForAppointmentsPage> createState() => _Page();
}

class _Page extends State<SearchForAppointmentsPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Seark Page',
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
