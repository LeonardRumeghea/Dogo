import 'package:flutter/material.dart';
import '../../../Helpers/constants.dart' as constants;

class PetShoppingPage extends StatefulWidget {
  const PetShoppingPage({super.key});

  @override
  State<PetShoppingPage> createState() => _Page();
}

class _Page extends State<PetShoppingPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'PetShoppingPage',
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
