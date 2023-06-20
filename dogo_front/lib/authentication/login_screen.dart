import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import '../Helpers/constants.dart' as constants;
import 'register_screen.dart' as sign_up;
import '../entities/person.dart';
import '../entities/pet.dart';
import '../home/services.dart';
import 'package:http/http.dart' as http;

class MyAppLogin extends StatelessWidget {
  const MyAppLogin({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dogo',
      theme: ThemeData(
        primarySwatch: constants.MyColors.darkBlue,
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      home: const PageLogin(),
    );
  }
}

class PageLogin extends StatefulWidget {
  const PageLogin({super.key});

  @override
  State<PageLogin> createState() => _Page();
}

class _Page extends State<PageLogin> {
  final _mailController = TextEditingController();
  final _passController = TextEditingController();

  bool showPassword = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _mailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Stack(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: size.height,
                  width: size.width,
                ),
                getlogo(size),
                emailInput(size),
                passwordInput(size),
                signInButton(context, size),
                registerLabel(context, size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getlogo(Size size) {
    return Positioned(
      top: size.height * 0.05,
      left: size.width * 0.1,
      child: Column(
        children: [
          Image.asset(
            'assets/images/dogo_icon.png',
            width: size.width * 0.8,
            height: size.width * 0.7,
          ),
          const Text(
            'Welcome Back',
            style: TextStyle(
              fontSize: 32,
              fontFamily: 'Roboto',
              // fontWeight: FontWeight.w500,
              color: constants.MyColors.dustBlue,
            ),
          ),
          const Text(
            'Login to your account',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }

  emailInput(Size size) {
    return Positioned(
      top: size.height * 0.5,
      left: size.width * 0.1,
      child: SizedBox(
        width: size.width * 0.8,
        child: TextFormField(
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'Email',
            hintText: 'Enter your email',
            errorStyle: TextStyle(color: constants.MyColors.dustRed),
          ),
          keyboardType: TextInputType.emailAddress,
          enableSuggestions: true,
          autofillHints: const [AutofillHints.email],
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (EmailValidator.validate(value) == false) {
              return 'Please enter a valid email';
            }
            return null;
          },
          controller: _mailController,
        ),
      ),
    );
  }

  passwordInput(Size size) {
    return Positioned(
      top: size.height * 0.6,
      left: size.width * 0.1,
      child: SizedBox(
        width: size.width * 0.8,
        child: TextFormField(
          keyboardType: TextInputType.text,
          controller: _passController,
          obscureText: !showPassword,
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Enter your password',
            errorStyle: const TextStyle(color: constants.MyColors.dustRed),
            suffixIcon: IconButton(
              icon: Icon(
                showPassword ? Icons.visibility : Icons.visibility_off,
                color: constants.MyColors.darkBlue,
              ),
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
            ),
          ),
          enableSuggestions: false,
          autocorrect: false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            return null;
          },
        ),
      ),
    );
  }

  signInButton(BuildContext context, Size size) {
    return Positioned(
      top: size.height * 0.75,
      left: size.width * 0.2,
      child: ElevatedButton(
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all<Size>(Size(
            size.width * 0.6,
            size.height * 0.06,
          )),
          textStyle: MaterialStateProperty.all<TextStyle>(
            const TextStyle(
              fontSize: 24,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
            constants.MyColors.darkBlue,
          ),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            checkAccount(context);
          }
        },
        child: const Text('Sign In'),
      ),
    );
  }

  registerLabel(BuildContext context, Size size) {
    return Positioned(
      top: size.height * 0.8,
      left: size.width * 0.22,
      child: SizedBox(
        width: size.width * 0.6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Don\'t have an account?',
              textAlign: TextAlign.center,
            ),
            TextButton(
              style: ButtonStyle(
                textStyle: MaterialStateProperty.all<TextStyle>(
                  const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const sign_up.Page()));
              },
              child: const Text(
                'Sign Up',
                style: TextStyle(
                  color: constants.MyColors.dustBlue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> checkAccount(BuildContext context) async {
    if (_mailController.text == 'admin@gmail.com' &&
        _passController.text == 'admin') {
      displaySuccess(context, 'Login successful');

      var adminPerson = Person(
        id: '123',
        firstName: 'Admin',
        lastName: 'Admin',
        email: 'admin@gmail.com',
        phoneNumber: '+40123456789',
        password: 'admin',
      );
      adminPerson.pets.add(Pet(
        id: '012',
        ownerId: '123',
        name: 'Rex',
        specie: 'Dog',
        breed: 'Pitbull',
        dateOfBirth: '2022-02-21',
        gender: 'Male',
      ));
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ServicesPage(user: adminPerson)),
      );
      return;
    }

    var url = '${constants.serverUrl}/users/checkLogin';
    var fullUrl =
        '$url?Email=${_mailController.text}&Password=${_passController.text}&api-version=1';

    var request = http.Request('GET', Uri.parse(fullUrl));

    var response = await request.send();

    if (!mounted) return;

    if (response.statusCode == HttpStatus.unauthorized) {
      displayError(context, 'Password is incorrect');
    }

    if (response.statusCode == HttpStatus.notFound) {
      displayError(context, 'This email is not associated with an account');
    }

    if (response.statusCode == HttpStatus.ok) {
      try {
        displaySuccess(context, 'Login successful');

        var responseStr = await response.stream.bytesToString();

        log('Response: $responseStr');

        Person person = Person.fromJSON(jsonDecode(responseStr));

        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ServicesPage(user: person)),
        );
      } catch (e) {
        log('Error: $e');
      }
    }
  }

  void displayError(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: constants.MyColors.dustRed,
      ),
    );
  }

  void displaySuccess(BuildContext context, String success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success),
        backgroundColor: constants.MyColors.dustGreen,
      ),
    );
  }
}
