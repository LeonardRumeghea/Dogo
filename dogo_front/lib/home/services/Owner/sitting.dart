import 'package:flutter/material.dart';
import '../../../Helpers/constants.dart' as constants;

class PetSittingPage extends StatefulWidget {
  const PetSittingPage({super.key});

  @override
  State<PetSittingPage> createState() => _Page();
}

class _Page extends State<PetSittingPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Pet Sitting Page',
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
