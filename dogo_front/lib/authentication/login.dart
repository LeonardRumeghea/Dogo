import 'package:flutter/material.dart';
import '../Helpers/constants.dart' as app_colors;
import '../home/services.dart' as main_menu;

class Page extends StatefulWidget {
  const Page({super.key});

  @override
  State<Page> createState() => _Page();
}

class _Page extends State<Page> {
  bool showPassword = false;
  final TextEditingController passController = TextEditingController();

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
              padding: EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
                keyboardType: TextInputType.emailAddress,
                enableSuggestions: true,
                autofillHints: [AutofillHints.email],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: passController,
                obscureText: !showPassword, //This will obscure text dynamically
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  // Here is key idea
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      showPassword ? Icons.visibility : Icons.visibility_off,
                      color: app_colors.MyColors.darkBlue,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                  ),
                ),
                enableSuggestions: false,
                autocorrect: false,
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
                  app_colors.MyColors.darkBlue,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const main_menu.Page()),
                );
              },
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
