import '../constants.dart';
import 'registration.dart';
import 'package:http/http.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:he_fish/helper/google_signin_api.dart';
import 'dart:convert';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:he_fish/pages/front.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    validateToken();
  }

  void validateToken() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token != null) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => FrontPage()));
    }
  }

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  RegExp pass_valid = RegExp(r"(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])");
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isInAsyncCall = false;
  bool _passwordVisible = false;

  Future<void> _login(String username, password) async {
    try {
      setState(() => _isInAsyncCall = true);
      Response response = await post(Uri.parse('${httpUrl}users/login/'),
          body: ({'username': username, 'password': password}));

      if (response.statusCode == 200) {
        setState(() => _isInAsyncCall = false);
        var data = jsonDecode(response.body.toString());
        var user = data["user"];
        var userID = user["id"];
        var userToken = user["token"];

        final userPref = await SharedPreferences.getInstance();

        userPref.setInt('id', userID);
        userPref.setString('token', userToken);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => FrontPage(),
            ));
      } else {
        var snackBar = SnackBar(
            backgroundColor: Colors.red,
            content: Text('Login failed. Check your username and password.'));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() => _isInAsyncCall = false);
        print('failed');
      }
    } catch (e) {
      setState(() => _isInAsyncCall = false);
      print("ERROR " + e.toString());
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
    final logo = Hero(
      tag: 'hero',
      child: Container(
          padding: EdgeInsets.only(top: 50),
          width: 150.0,
          height: 150.0,
          decoration: new BoxDecoration(
              image: new DecorationImage(
                  image: AssetImage("assets/images/logo_hefish.png")))),
    );

    final loginButton = ElevatedButton(
        onPressed: () {
          _login(usernameController.text.toString(),
              passwordController.text.toString());
        },
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(45, 45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
        child: const Text('Login',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17)));

    final userName = TextFormField(
        validator: MultiValidator([
          RequiredValidator(errorText: "* Required"),
          MinLengthValidator(4,
              errorText: ("Username should be at least 4 characters")),
        ]),
        controller: usernameController,
        decoration: InputDecoration(
            hintText: 'Username',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            prefixIcon: Padding(
                padding: EdgeInsets.only(left: 5), child: Icon(Icons.person)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
            )));

    final userPass = TextFormField(
      keyboardType: TextInputType.text,
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
      controller: passwordController,
      obscureText: !_passwordVisible, //This will obscure text dynamically
      decoration: InputDecoration(
          hintText: 'Password',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          prefixIcon: Padding(
              padding: EdgeInsets.only(left: 5), child: Icon(Icons.lock)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
          )),
    );

    final createAccount = Row(
      children: <Widget>[
        const Text('No Account ?'),
        TextButton(
          child: const Text(
            'Create one',
            style: TextStyle(fontSize: 16),
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => RegistrationPage()));
          },
        )
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );

    final rowDivider = Row(children: <Widget>[
      Expanded(child: Divider()),
      Text("Sign in with"),
      Expanded(child: Divider()),
    ]);

    final googleButton = Container(
        width: 80.0,
        height: 50.0,
        child: SignInButton(
          Buttons.Google,
          onPressed: signIn,
        ));

    final pageTitle = Center(
      child: Text('LOG IN',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w900)),
    );

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 103, 197, 255),
        body: LoadingOverlay(
            isLoading: _isInAsyncCall,
            child: Form(
              autovalidateMode: AutovalidateMode.always,
              key: formkey,
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 40.0, right: 40.0),
                children: <Widget>[
                  SizedBox(height: 68.0),
                  logo,
                  SizedBox(height: 12.0),
                  userName,
                  SizedBox(height: 12.0),
                  userPass,
                  SizedBox(height: 34.0),
                  loginButton,
                  createAccount,
                  SizedBox(height: 12.0),
                  rowDivider,
                  SizedBox(height: 12.0),
                  googleButton
                ],
              ),
            )));
  }
}

Future signIn() async {
  final user = await GoogleSignInApi.login();
  print(user);
}
