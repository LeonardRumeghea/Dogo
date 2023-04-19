import 'package:dogo_front/entities/person.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../Helpers/constants.dart' as constants;
import '../entities/address.dart';
import '../home/services.dart';

class Page extends StatefulWidget {
  const Page({super.key});

  @override
  State<Page> createState() => _Page();
}

class _Page extends State<Page> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();

  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _streetController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _otherDetailsController = TextEditingController();

  bool _passwordVisible = false;
  bool _passwordConfirmationVisible = false;

  final _formKey = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  var _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              getLogoImage(),
              Stepper(
                currentStep: _currentStep,
                physics: const ClampingScrollPhysics(),
                onStepContinue: () {
                  setState(() {
                    if (validateStep(_currentStep) && _currentStep < 3) {
                      _currentStep = _currentStep + 1;
                    }
                    if (_currentStep == 3 && validateStep(_currentStep)) {
                      var person = Person(
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        email: _emailController.text,
                        phone: _phoneController.text,
                        address: Address(
                            state: _stateController.text,
                            city: _cityController.text,
                            street: _streetController.text,
                            zip: _zipCodeController.text,
                            additionalDetails: _otherDetailsController.text),
                      );

                      print(person.toString());

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ServicesPage(),
                        ),
                      );
                    }
                  });
                },
                onStepCancel: () {
                  setState(() => _currentStep -= _currentStep > 0 ? 1 : 0);
                },
                onStepTapped: (step) {
                  setState(() {
                    if (step < _currentStep || validateStep(_currentStep)) {
                      _currentStep = step;
                    }
                  });
                },
                steps: [
                  Step(
                    title: const Text('Name', style: TextStyle(fontSize: 20)),
                    isActive: _currentStep >= 0,
                    content: Form(
                      key: _formKey[0],
                      child: Column(
                        children: [
                          getFirstNameField(),
                          getLastNameField(),
                        ],
                      ),
                    ),
                  ),
                  Step(
                    title: const Text('Contact Info',
                        style: TextStyle(fontSize: 20)),
                    isActive: _currentStep >= 1,
                    content: Form(
                      key: _formKey[1],
                      child: Column(
                        children: [
                          getEmailField(),
                          getPhoneField(),
                        ],
                      ),
                    ),
                  ),
                  Step(
                    title:
                        const Text('Password', style: TextStyle(fontSize: 20)),
                    isActive: _currentStep >= 2,
                    content: Form(
                      key: _formKey[2],
                      child: Column(
                        children: [
                          getPasswordField(),
                          getPasswordConfirmationField(),
                        ],
                      ),
                    ),
                  ),
                  Step(
                    title:
                        const Text('Address', style: TextStyle(fontSize: 20)),
                    isActive: _currentStep >= 3,
                    content: Form(
                      key: _formKey[3],
                      child: Column(
                        children: [
                          getStateField(),
                          getCityField(),
                          getStreetField(),
                          getZipCodeField(),
                          getOtherDetailsField(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  validateStep(int step) {
    switch (step) {
      case 0:
        return _formKey[0].currentState!.validate();
      case 1:
        return _formKey[1].currentState!.validate();
      case 2:
        return _formKey[2].currentState!.validate();
      case 3:
        return _formKey[3].currentState!.validate();
      default:
        return false;
    }
  }

  getLogoImage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 64, 16, 0),
      child: Image.asset(
        'assets/images/dogo_icon.png',
        width: 150,
        height: 150,
      ),
    );
  }

  getFirstNameField() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'First Name',
          hintText: 'Enter your first name',
          errorStyle: TextStyle(color: constants.MyColors.dustRed),
        ),
        autofillHints: const [AutofillHints.givenName],
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp(r'[a-zA-Z]'),
          ),
        ],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your first name';
          }
          if (value.length < 2) {
            return 'Please enter a valid first name';
          }
          return null;
        },
        controller: _firstNameController,
      ),
    );
  }

  getLastNameField() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Last Name',
          hintText: 'Enter your last name',
          errorStyle: TextStyle(color: constants.MyColors.dustRed),
        ),
        autofillHints: const [AutofillHints.familyName],
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp(r'[a-zA-Z]'),
          ),
        ],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your last name';
          }
          if (value.length < 2) {
            return 'Please enter a valid last name';
          }
          return null;
        },
        controller: _lastNameController,
      ),
    );
  }

  getEmailField() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Email',
          hintText: 'Enter your email',
          errorStyle: TextStyle(color: constants.MyColors.dustRed),
        ),
        autofillHints: const [AutofillHints.email],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email';
          }
          if (EmailValidator.validate(value) == false) {
            return 'Please enter a valid email address';
          }
          return null;
        },
        controller: _emailController,
      ),
    );
  }

  getPhoneField() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: IntlPhoneField(
        decoration: const InputDecoration(
          labelText: 'Phone Number',
          hintText: 'Enter your phone number',
          errorStyle: TextStyle(color: constants.MyColors.dustRed),
          border: OutlineInputBorder(borderSide: BorderSide()),
        ),
        initialCountryCode: 'RO',
        autovalidateMode: AutovalidateMode.onUserInteraction,
        // controller: _phoneController,
        onChanged: (value) => _phoneController.text = value.completeNumber,
      ),
    );
  }

  getPasswordField() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: _passwordController,
        obscureText: !_passwordVisible,
        decoration: InputDecoration(
          labelText: 'Password',
          hintText: 'Enter your password',
          errorStyle: const TextStyle(color: constants.MyColors.dustRed),
          suffixIcon: IconButton(
            icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: constants.MyColors.darkBlue,
            ),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
        ),
        enableSuggestions: false,
        autocorrect: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          if (value.length < 8) {
            return 'Your password must be at least 8 characters long';
          }
          return null;
        },
      ),
    );
  }

  getPasswordConfirmationField() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: _passwordConfirmationController,
        obscureText: !_passwordConfirmationVisible,
        decoration: InputDecoration(
          labelText: 'Confirm Password',
          hintText: 'Enter your password again',
          errorStyle: const TextStyle(color: constants.MyColors.dustRed),
          suffixIcon: IconButton(
            icon: Icon(
              _passwordConfirmationVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: constants.MyColors.darkBlue,
            ),
            onPressed: () {
              setState(() {
                _passwordConfirmationVisible = !_passwordConfirmationVisible;
              });
            },
          ),
        ),
        enableSuggestions: false,
        autocorrect: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          if (value != _passwordController.text) {
            return 'Passwords do not match';
          }
          return null;
        },
      ),
    );
  }

  getStateField() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'State',
          hintText: 'Enter your state name',
          errorStyle: TextStyle(color: constants.MyColors.dustRed),
        ),
        autofillHints: const [AutofillHints.addressState],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => value!.isEmpty ? 'State can\'t be empty' : null,
        controller: _stateController,
      ),
    );
  }

  getCityField() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'City',
          hintText: 'Enter your city name',
          errorStyle: TextStyle(color: constants.MyColors.dustRed),
        ),
        autofillHints: const [AutofillHints.addressCity],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => value!.isEmpty ? 'City can\'t be empty' : null,
        controller: _cityController,
      ),
    );
  }

  getStreetField() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Street',
          hintText: 'Enter your street',
          errorStyle: TextStyle(color: constants.MyColors.dustRed),
        ),
        autofillHints: const [AutofillHints.streetAddressLine1],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => value!.isEmpty ? 'Street can\'t be empty' : null,
        controller: _streetController,
      ),
    );
  }

  getZipCodeField() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Zip Code',
          hintText: 'Enter your zip code',
          errorStyle: TextStyle(color: constants.MyColors.dustRed),
        ),
        autofillHints: const [AutofillHints.postalCode],
        keyboardType: TextInputType.phone,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) =>
            value!.isEmpty ? 'Zip code can\'t be empty' : null,
        controller: _zipCodeController,
      ),
    );
  }

  getOtherDetailsField() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Other Details (Apt, Suite, etc)',
          hintText: 'Enter your complement',
          errorStyle: TextStyle(color: constants.MyColors.dustRed),
        ),
        controller: _otherDetailsController,
      ),
    );
  }

  getFinishButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: ElevatedButton(
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
              constants.MyColors.darkBlue,
            ),
          ),
          onPressed: () {
            // if (_formKey.currentState!.validate()) {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => const sign_up_second.Page(),
            //     ),
            //   );
            // }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Text('Next'),
              Icon(Icons.arrow_forward),
            ],
          )),
    );
  }
}