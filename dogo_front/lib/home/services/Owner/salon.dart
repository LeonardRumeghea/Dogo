import 'package:flutter/material.dart';
import '../../../Helpers/constants.dart' as constants;

class SalonVisitPage extends StatefulWidget {
  const SalonVisitPage({super.key});

  @override
  State<SalonVisitPage> createState() => _Page();
}

class _Page extends State<SalonVisitPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'SalonVisitPage',
          style: TextStyle(
            color: constants.Colors.grey,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
