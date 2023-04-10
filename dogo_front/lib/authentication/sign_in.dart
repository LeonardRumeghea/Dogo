import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './../Helpers/app_colors.dart' as app_colors;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dogo',
      theme: ThemeData(
        primarySwatch: app_colors.Colors.darkBlue,
        brightness: Brightness.dark,
      ),
      home: const Page(title: 'Login'),
    );
  }
}

class Page extends StatefulWidget {
  const Page({super.key, required this.title});

  final String title;

  @override
  State<Page> createState() => _Page();
}

class _Page extends State<Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 50),
              child: Image.asset(
                'assets/images/dogo_icon.png',
                width: 150,
                height: 150,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: TextField(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: TextField(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all<Size>(const Size(300, 50)),
                textStyle: MaterialStateProperty.all<TextStyle>(
                  const TextStyle(
                    fontSize: 24,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                  app_colors.Colors.darkBlue,
                ),
              ),
              onPressed: () {
                // Navigator.pushNamed(context, '/sign_in');
              },
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
