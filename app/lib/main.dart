import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:he_fish/pages/registration.dart';
import '/pages/login.dart';
import "/pages/front.dart";
import 'constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    FrontPage.tag: (context) => FrontPage(),
    RegistrationPage.tag: (context) => RegistrationPage(),
  };

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        child: MaterialApp(
          title: 'HE FISH',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'Nunito',
          ),
          home: LoginPage(),
          routes: routes,
        ),
        value: SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }
}
