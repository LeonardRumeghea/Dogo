import 'package:flutter/material.dart';
import '../../../Helpers/constants.dart' as constants;
import '../../../entities/person.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key, required this.user});

  final Person user;

  @override
  State<HistoryPage> createState() => _Page();
}

class _Page extends State<HistoryPage> {
  Person get _user => widget.user;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'History & Reports Page',
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
