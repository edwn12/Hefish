import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:he_fish/constants.dart';
import 'package:http/http.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'dart:convert';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});
  static String tag = 'registration-page';

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  RegExp pass_valid = RegExp(r"(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])");
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  var _isLoading = false;

  void _signup(String email, username, password) async {
    setState(() => _isLoading = true);
    Response response = await post(Uri.parse('${httpUrl}users/register/'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(
            {"email": email, "username": username, "password": password}));

    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      var snackBar = SnackBar(
          backgroundColor: Colors.green[300],
          content: Text('Success Create Account'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.of(context).pop();
    }
  }

  bool validatePassword(String pass) {
    String _password = pass.trim();
    if (pass_valid.hasMatch(_password)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final logo = Container(
        padding: EdgeInsets.only(top: 40),
        width: 100.0,
        height: 100.0,
        decoration: new BoxDecoration(
            image: new DecorationImage(
                image: AssetImage("assets/images/logo_hefish.png"))));

    final pageTitle = Center(
      child: Text('REGISTRATION',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w900)),
    );

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 103, 197, 255),
        body: Form(
            autovalidateMode: AutovalidateMode.always,
            key: formkey,
            child: LoadingOverlay(
                isLoading: _isLoading,
                child: Center(
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(left: 40.0, right: 40.0),
                    children: <Widget>[
                      logo,
                      SizedBox(height: 52.0),
                      pageTitle,
                      SizedBox(height: 32.0),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                          hintText: 'Input your email',
                          labelText: 'Email',
                        ),
                        onSaved: (String? value) {},
                        validator: MultiValidator([
                          RequiredValidator(errorText: "* Required"),
                          EmailValidator(
                              errorText:
                                  "You must input a correct email address."),
                        ]),
                      ),
                      SizedBox(height: 12.0),
                      TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                          hintText: 'Input your username',
                          labelText: 'Username',
                        ),
                        onSaved: (String? value) {},
                        validator: MultiValidator([
                          RequiredValidator(errorText: "* Required"),
                          MinLengthValidator(4,
                              errorText:
                                  ("Username should be at least 4 characters")),
                        ]),
                      ),
                      SizedBox(height: 12.0),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                          hintText: 'Input your password',
                          labelText: 'Password',
                        ),
                        onSaved: (String? value) {},
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "* Required";
                          } else {
                            bool result = validatePassword(value);
                            if (result) {
                              return null;
                            } else {
                              return " Password should contain Capital, small letter & Number & Special";
                            }
                          }
                        },
                      ),
                      SizedBox(height: 12.0),
                      TextFormField(
                        controller: confirmPasswordController,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                          hintText: 'Confirm your password',
                          labelText: 'Confirm Password',
                        ),
                        onSaved: (String? value) {},
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "* Required";
                          } else {
                            if (value != passwordController.text) {
                              return "Password does not match";
                            } else {
                              return null;
                            }
                          }
                        },
                      ),
                      SizedBox(height: 30.0),
                      ElevatedButton(
                          onPressed: () {
                            _signup(
                                emailController.text.toString(),
                                usernameController.text.toString(),
                                passwordController.text.toString());
                          },
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(45, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          ),
                          child: const Text('Save',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17))),
                    ],
                  ),
                ))));
  }
}
