import 'package:flutter/material.dart';
import '../../../Helpers/constants.dart' as constants;

class VetCarePage extends StatefulWidget {
  const VetCarePage({super.key});

  @override
  State<VetCarePage> createState() => _Page();
}

class _Page extends State<VetCarePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'VetCarePage',
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
