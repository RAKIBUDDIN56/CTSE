import 'package:flutter/material.dart';
import 'package:group_chat_app/components/rounded_button.dart';
import 'package:group_chat_app/driver_signinWithPhon/signin_screen.dart';
import 'package:group_chat_app/pages/Signup/register_page.dart';
import 'package:group_chat_app/pages/Welcome/components/background.dart';
//import 'package:flutter_svg/svg.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Background(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "SELECT YOUR PREFERENCE",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.05),
            Image.asset(
              "assets/images/pref.jpg",
              height: size.height * 0.45,
            ),
            SizedBox(height: size.height * 0.05),
            RoundedButton(
              text: "SIGNUP USING EMAIL",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return RegisterPage();
                    },
                  ),
                );
              },
            ),
            RoundedButton(
              text: "SIGNUP USING MOBILE",
              textColor: Colors.white,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreenWithPhone();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
