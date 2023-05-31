import 'dart:convert';
import 'package:he_fish/pages/login.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:he_fish/components/fish_typeslist.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FrontPage extends StatefulWidget {
  static String tag = 'front-page';
  const FrontPage({super.key});

  @override
  State<FrontPage> createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  int uid = 0;

  @override
  void initState() {
    super.initState();
    getPref();
  }

  void getPref() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final int? id = prefs.getInt('id');
    setState(() {
      uid == id;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    showAlertDialog(BuildContext context) {
      // set up the buttons
      Widget cancelButton = TextButton(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
      Widget continueButton = TextButton(
        child: Text("Continue"),
        onPressed: () async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          await preferences.clear();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ));
        },
      );

      AlertDialog alert = AlertDialog(
        title: Text("Confirmation"),
        content: Text("Are your sure want to logout ?"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    final List<String> imgList = [
      'https://www.ikanhias.id/wp-content/uploads/2019/11/shovelnose-tiger-catfish-630x380.jpg',
      'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full//107/MTA-44926577/br-m036969-02424_red-tail-catfish-rtc-predator-fish-_full01.jpg',
      'http://1.bp.blogspot.com/-69k6YLqhSts/UhmPLiXL2UI/AAAAAAAACsk/JCCpL1LCOrA/s1600/shiro+utsuri2.jpg',
      'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj4Z0EWTO9Ne3ulmtQfDPkmdqMnye0OUjSIaBRGq1FhD5gO7O9kF2Ti9Y2f4oH_3cCiRHLhguyC4EnWX2iuCBw8rasilRDiIqe-fwax8Zr7yLnLc8dD8pGEnoFWCGekkvvLHj5AS7K2uUCzu3AsrlcD1jWxHxJQ02Ib8iY9BOPCnOOYOuQMeI0Tg5I0/s720/Screenshot_2022-05-13-12-54-38-70.png',
      'https://i.pinimg.com/originals/99/e2/f9/99e2f975d53348df1469f255473b748e.jpg'
    ];
    return Builder(builder: (context) {
      return Scaffold(
          appBar: AppBar(
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.logout_outlined,
                    // color: Colors.white,
                  ),
                  onPressed: () {
                    showAlertDialog(context);
                  },
                )
              ],
              title: Row(children: [
                Container(
                    // padding: EdgeInsets.only(top: 0),
                    width: 70.0,
                    height: 70.0,
                    decoration: new BoxDecoration(
                        image: new DecorationImage(
                            image:
                                AssetImage("assets/images/logo_hefish.png")))),
                Container(
                    child: Text(
                  "HE FISH",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ])),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    // Container(height: size.height * .4, width: size.width),
                    // GradientContainer(size),

                    Container(
                        // color: Colors.amber,
                        width: size.width,
                        height: 250,
                        // margin: EdgeInsets.only(top: size.height * .17),
                        child: CarouselSlider(
                          options: CarouselOptions(
                              height: 200.0,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 3)),
                          items: imgList.map((item) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                    width: size.width,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 5.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(0, 10),
                                            blurRadius: 20,
                                            color:
                                                Color.fromARGB(255, 73, 73, 73)
                                                    .withOpacity(0.7))
                                      ],
                                      color: Color.fromARGB(255, 243, 243, 241),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5.0),
                                      child: Image.network(
                                        item,
                                        fit: BoxFit.cover,
                                        height: 150.0,
                                        width: 100.0,
                                      ),
                                    ));
                              },
                            );
                          }).toList(),
                        )),
                  ],
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                            Container(
                                alignment: Alignment.topLeft,
                                width: 120.0,
                                height: 120.0,
                                decoration: new BoxDecoration(
                                    image: new DecorationImage(
                                        image: AssetImage(
                                            "assets/images/logo_hefish.png")))),
                            Container(
                                width: size.width / 2,
                                child: Column(children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text("About Us",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
                                  ),
                                  Text(
                                      "HE Fish adalah aplikasi menjual ikan kualitas tinggi dengan harga yang terjangkau. HE Fish menjual berbagai jenis dari perairan tawar dan perairan asin disertai deskripsi setiap ikan. Selamat berbelanja!",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Color.fromARGB(255, 70, 73, 75),
                                      )),
                                ]))
                          ])),
                    ],
                  ),
                ),
                FishTypeList(),
                SizedBox(height: 40)
              ],
            ),
          ));
    });
  }
}
