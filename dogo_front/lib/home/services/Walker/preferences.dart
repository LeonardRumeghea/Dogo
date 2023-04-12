import 'package:flutter/material.dart';
import '../../../Helpers/constants.dart' as constants;

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  State<PreferencesPage> createState() => _Page();
}

class _Page extends State<PreferencesPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Preferences Page',
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
