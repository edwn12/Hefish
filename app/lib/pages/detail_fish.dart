import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:he_fish/constants.dart';
import 'package:he_fish/pages/edit_fish.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'front.dart';

class DetailFish extends StatefulWidget {
  int fishCatID;
  int fishID;
  String fishName;
  String fishDesc;
  int fishPrice;
  String fishImg;
  String fishCreator;
  String fishCategory;
  int fishCreatorID;
  DetailFish(
      {required this.fishCatID,
      required this.fishID,
      required this.fishName,
      required this.fishDesc,
      required this.fishPrice,
      required this.fishImg,
      required this.fishCreator,
      required this.fishCategory,
      required this.fishCreatorID});

  // const DetailFish({super.key});

  @override
  State<DetailFish> createState() => _DetailFishState();
}

class _DetailFishState extends State<DetailFish> {
  bool _isMatch = false;
  @override
  void initState() {
    super.initState();
    getPref();
  }

  void getPref() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final int? id = prefs.getInt('id');
    if (widget.fishCreatorID == id) {
      setState(() {
        _isMatch = true;
      });
    }
  }

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
        print(widget.fishID);

        Response response = await post(Uri.parse('${httpUrl}fishes/delete'),
            headers: {"Content-Type": "application/json"},
            body: json.encode({"id": widget.fishID}));

        print(response.body.toString());
        print(response.statusCode);
        if (response.statusCode == 200) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => FrontPage(),
              ));
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete Confirmation"),
      content: Text("Are you sure you want to delete this article ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.fishName.toUpperCase()}',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                '${widget.fishCategory.toUpperCase()}',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ],
          )),
      body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 10),
                alignment: Alignment.center,
                child: Text(
                  '${widget.fishName}',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                  padding: EdgeInsets.only(top: 20),
                  width: 250.0,
                  height: 250.0,
                  decoration: new BoxDecoration(
                      image: new DecorationImage(
                          image:
                              AssetImage("assets/items/${widget.fishImg}")))),
              Container(
                margin: EdgeInsets.only(top: 10),
                alignment: Alignment.topLeft,
                child: Text(
                  '${widget.fishDesc}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                alignment: Alignment.topLeft,
                child: Text('Price'),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Text('Rp. ${widget.fishPrice}',
                    style:
                        TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                // width: 100,
                margin: EdgeInsets.only(top: 10),
                alignment: Alignment.topLeft,
                child: Text(
                  'Author ${widget.fishCreator}',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              SizedBox(height: 40),
              Visibility(
                  visible: _isMatch,
                  child: Row(
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              // fixedSize: const Size(50, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              primary: Colors.red[200], // background
                              onPrimary: Colors.black, // foreground
                            ),
                            onPressed: () {
                              showAlertDialog(context);
                            },
                            child: Text(
                              "Delete",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.only(left: 10),
                          alignment: Alignment.centerLeft,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              // fixedSize: const Size(50, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              primary: Colors.green[200], // background
                              onPrimary: Colors.black, // foreground
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EditFish(
                                      fishCatID: widget.fishCatID,
                                      fishID: widget.fishID,
                                      fishName: widget.fishName,
                                      fishDesc: widget.fishDesc,
                                      fishPrice: widget.fishPrice,
                                      fishImg: widget.fishImg,
                                      fishCreator: widget.fishCreator,
                                      fishCategory: widget.fishCategory,
                                      fishCreatorID: widget.fishCreatorID)));
                            },
                            child: Text(
                              "Edit",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ))
                    ],
                  )),
            ],
          )),
    );
  }
}
