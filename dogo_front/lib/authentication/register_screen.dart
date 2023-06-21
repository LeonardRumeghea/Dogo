import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dogo_front/entities/person.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../Helpers/config.dart';
import '../Helpers/constants.dart' as constants;
import '../Helpers/screens/location_picker.dart';
import '../entities/address.dart';
import './login_screen.dart';

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

  bool _isAddressSelected = false;
  Address _selectedAddress = Address();

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
                    if (_currentStep == 4 && validateStep(_currentStep)) {
                      createUser(context);
                    }

                    if (validateStep(_currentStep) && _currentStep < 4) {
                      _currentStep = _currentStep + 1;
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
                    title: const Text('Pick Address',
                        style: TextStyle(fontSize: 20)),
                    isActive: _currentStep >= 3,
                    content: GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * .6,
                          height: MediaQuery.of(context).size.height * .05,
                          decoration: BoxDecoration(
                            color: constants.MyColors.darkBlue,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: constants.MyColors.blackBlue
                                    .withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                !_isAddressSelected
                                    ? Icons.add_location_alt_rounded
                                    : Icons.edit_location_rounded,
                                color: constants.lightGrey,
                              ),
                              Text(
                                  !_isAddressSelected
                                      ? ' Add Address'
                                      : ' Edit Address',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: constants.lightGrey,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PageLocationPicker(),
                          ),
                        ).then(
                          (value) => setState(
                            () {
                              if (value != null) {
                                _selectedAddress = value;
                                _isAddressSelected = true;

                                _stateController.text = _selectedAddress.state;
                                _cityController.text = _selectedAddress.city;
                                _streetController.text =
                                    _selectedAddress.street;
                                _zipCodeController.text =
                                    _selectedAddress.zipCode;
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Step(
                    title: const Text('Validate Address',
                        style: TextStyle(fontSize: 20)),
                    isActive: _currentStep >= 4,
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

  createUser(BuildContext context) async {
    _selectedAddress.zipCode = _zipCodeController.text;
    _selectedAddress.additionalDetails = _otherDetailsController.text;

    var person = Person(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      phoneNumber: _phoneController.text,
      address: Address.copyOf(_selectedAddress),
    );

    postUser(person).then((value) {
      log(value);
      log(person.toString());
      try {
        if (int.tryParse(value) == HttpStatus.conflict) {
          displayError(context, 'This email is already in use');
        } else {
          displaySuccess(context, 'Your account has been created successfully');
          Map<String, dynamic> jsonFormat = json.decode(value);
          person.id = jsonFormat['id'];
          person.address!.id = jsonFormat['address']['id'];
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PageLogin()),
          );
        }
      } catch (e) {
        log('Error: $e');
      }
    });
  }

  Future<String> postUser(Person person) async {
    var url = '$serverUrl/users?api-version=1';
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse(url));

    request.body = json.encode(person.toJSON(withId: false));
    request.headers.addAll(headers);

    var response = await request.send();

    return response.statusCode == HttpStatus.created
        ? await response.stream.bytesToString()
        : response.statusCode.toString();
  }

  void displaySuccess(BuildContext context, String success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success),
        backgroundColor: constants.MyColors.dustGreen,
      ),
    );
  }

  void displayError(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: constants.MyColors.dustRed,
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
        return _isAddressSelected;
      case 4:
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
