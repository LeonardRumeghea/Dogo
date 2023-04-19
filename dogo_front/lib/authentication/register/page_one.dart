import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Helpers/constants.dart' as app_colors;
import 'page_two.dart' as sign_up_second;

class Page extends StatefulWidget {
  const Page({super.key});

  @override
  State<Page> createState() => _Page();
}

class _Page extends State<Page> {
  bool _passwordVisible = false;
  final TextEditingController _userPasswordController = TextEditingController();

  bool _passwordConfirmationVisible = false;
  final TextEditingController _userPasswordConfirmationController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 64, 16, 0),
                child: Image.asset(
                  'assets/images/dogo_icon.png',
                  width: 150,
                  height: 150,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: TextField(
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'First Name',
                    hintText: 'Enter your first name',
                  ),
                  autofillHints: [AutofillHints.givenName],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: TextField(
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Last Name',
                    hintText: 'Enter your last name',
                  ),
                  autofillHints: [AutofillHints.familyName],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: TextField(
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Email',
                  ),
                  autofillHints: [AutofillHints.email],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Phone Number',
                    hintText: 'Enter your phone number',
                  ),
                  autofillHints: const [AutofillHints.telephoneNumber],
                  keyboardType: TextInputType.phone,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _userPasswordController,
                  obscureText:
                      !_passwordVisible, //This will obscure text dynamically
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    // Here is key idea
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: app_colors.MyColors.darkBlue,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  enableSuggestions: false,
                  autocorrect: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _userPasswordConfirmationController,
                  obscureText:
                      !_passwordConfirmationVisible, //This will obscure text dynamically
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Enter your password again',
                    // Here is key idea
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordConfirmationVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: app_colors.MyColors.darkBlue,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          _passwordConfirmationVisible =
                              !_passwordConfirmationVisible;
                        });
                      },
                    ),
                  ),
                  enableSuggestions: false,
                  autocorrect: false,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                child: ElevatedButton(
                    style: ButtonStyle(
                      fixedSize:
                          MaterialStateProperty.all<Size>(const Size(300, 50)),
                      textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(
                          fontSize: 24,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        app_colors.MyColors.darkBlue,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const sign_up_second.Page()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Text('Next'),
                        Icon(Icons.arrow_forward),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
