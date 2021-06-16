import 'package:flutter/material.dart';
import 'package:group_chat_app/components/already_have_an_account_acheck.dart';
import 'package:group_chat_app/components/rounded_button.dart';
import 'package:group_chat_app/components/rounded_field_lastname.dart';
import 'package:group_chat_app/components/rounded_input_field.dart';
import 'package:group_chat_app/components/rounded_password_field.dart';
import 'package:group_chat_app/helper/helper_functions.dart';
import 'package:group_chat_app/pages/Signup/components/background.dart';
import 'package:group_chat_app/pages/home_page.dart';
import 'package:group_chat_app/services/auth_service.dart';
import 'package:group_chat_app/shared/loading.dart';
import '../signin/signin_page.dart';
import 'components/or_divider.dart';
import 'components/social_icon.dart';

class RegisterPage extends StatefulWidget {
  final Function toggleView;
  RegisterPage({this.toggleView});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // text field state
  String fullName = '';
  String email = '';
  String password = '';
  String error = '';

  _onRegister() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      await _auth
          .registerWithEmailAndPassword(fullName, email, password)
          .then((result) async {
        if (result != null) {
          await HelperFunctions.saveUserLoggedInSharedPreference(true);
          await HelperFunctions.saveUserEmailSharedPreference(email);
          await HelperFunctions.saveUserNameSharedPreference(fullName);

          print("Registered");
          await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
            print("Logged in: $value");
          });
          await HelperFunctions.getUserEmailSharedPreference().then((value) {
            print("Email: $value");
          });
          await HelperFunctions.getUserNameSharedPreference().then((value) {
            print("Full Name: $value");
          });

          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage()));
        } else {
          setState(() {
            error = 'Error while registering the user!';
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Loading()
        : Scaffold(
            body: Background(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "SIGNUP",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                  Image.asset(
                    "assets/images/register.jpg",
                    height: 150,
                  ),
                  RoundedInputFieldLastname(
                    hintText: "Your Name",
                    onChanged: (val) {
                      setState(() {
                        fullName = val;
                      });
                    },
                  ),
                  RoundedInputField(
                    hintText: "Your Email",
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                  ),
                  RoundedPasswordField(
                    onChanged: (val) {
                      setState(() {
                        password = val;
                      });
                    },
                  ),
                  RoundedButton(
                    text: "SIGNUP",
                    press: () {
                      _onRegister();
                    },
                  ),
                  SizedBox(height: 30),
                  AlreadyHaveAnAccountCheck(
                    login: false,
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SignInPage();
                          },
                        ),
                      );
                    },
                  ),
                  OrDivider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SocalIcon(
                        iconSrc: "assets/icons/facebook.svg",
                        press: () {},
                      ),
                      SocalIcon(
                        iconSrc: "assets/icons/twitter.svg",
                        press: () {},
                      ),
                      SocalIcon(
                        iconSrc: "assets/icons/google-plus.svg",
                        press: () {},
                      ),
                      SizedBox(height: 10.0),
                      Text(error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0)),
                    ],
                  )
                ],
              ),
            ),
          ));
  }
}
