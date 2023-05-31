import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:he_fish/pages/fishes.dart';
import 'package:he_fish/pages/front.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

import '../constants.dart';

class EditFish extends StatefulWidget {
  int fishCatID;
  int fishID;
  String fishName;
  String fishDesc;
  int fishPrice;
  String fishImg;
  String fishCreator;
  String fishCategory;
  int fishCreatorID;

  EditFish(
      {required this.fishCatID,
      required this.fishID,
      required this.fishName,
      required this.fishDesc,
      required this.fishPrice,
      required this.fishImg,
      required this.fishCreator,
      required this.fishCategory,
      required this.fishCreatorID});

  @override
  State<EditFish> createState() => _EditFishState();
}

class _EditFishState extends State<EditFish> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController _fishName = TextEditingController();
  TextEditingController _fishDesc = TextEditingController();
  TextEditingController _fishPrice = TextEditingController();
  TextEditingController _fishImg = TextEditingController();
  int typeID = 0;
  String selectedValue = "1";
  @override
  void initState() {
    super.initState();
    getFishTypes();
    _fishName = new TextEditingController(text: widget.fishName);
    _fishDesc = new TextEditingController(text: widget.fishDesc);
    _fishPrice = new TextEditingController(text: widget.fishPrice.toString());
    _fishImg = new TextEditingController(text: widget.fishImg);

    setState(() {
      selectedValue = widget.fishCatID.toString();
    });
  }

  bool isLoading = false;
  List<dynamic> listTypes = [];
  late String _valName;
  late int _valID;

  void getFishTypes() async {
    final String apiUrl = "${httpUrl}fishtypes/types/";
    var result = await http.get(Uri.parse(apiUrl));
    var data = jsonDecode(result.body.toString());
    // listTypes = data["types"];
    setState(() {
      listTypes = data["types"];
    });
    // print(listTypes);
  }

  void saveFish(int fish_id, int fish_type_id, String name, description,
      int price, String image_path) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final int? id = prefs.getInt('id');

    setState(() {
      isLoading = true;
    });
    Response response = await post(Uri.parse('${httpUrl}fishes/edit'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "id": fish_id,
          "fish_type_id": fish_type_id,
          "name": name,
          "description": description,
          "price": price,
          "image_path": image_path
        }));

    if (response.statusCode == 200) {
      setState(() {
        isLoading = true;
      });
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FrontPage(),
          ));
    } else {
      setState(() {
        isLoading = true;
      });
    }
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    print(listTypes);
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Koi"), value: "1"),
      DropdownMenuItem(child: Text("Channa"), value: "2"),
      DropdownMenuItem(child: Text("Catfish"), value: "3"),
    ];
    return menuItems;
  }

  File? imageFile;

  selectFile() async {
    XFile? file = await ImagePicker().pickImage(
        source: ImageSource.gallery, maxHeight: 1800, maxWidth: 1800);

    if (file != null) {
      setState(() {
        imageFile = File(file.path);
      });
      String fileName = file.path.split('/').last;
      _fishImg.text = fileName;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            'UPDATE FISH',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
        ),
        body: Container(
            child: SingleChildScrollView(
          child: Form(
              autovalidateMode: AutovalidateMode.disabled,
              key: formkey,
              child: LoadingOverlay(
                isLoading: isLoading,
                child: Column(children: <Widget>[
                  Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: TextFormField(
                        maxLength: 50,
                        controller: _fishName,
                        decoration: const InputDecoration(
                          hintText: 'Input your fish name',
                          labelText: 'Fish Name',
                        ),
                      )),
                  Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: TextFormField(
                        // initialValue: widget.fishDesc,
                        maxLength: 50,
                        controller: _fishDesc,
                        decoration: const InputDecoration(
                          hintText: 'Input your fish description',
                          labelText: 'Description',
                        ),
                      )),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    alignment: Alignment.centerLeft,
                    child: Text("Fish Type"),
                  ),
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: new DropdownButtonHideUnderline(
                          child: DropdownButton(
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedValue = newValue!;
                                });
                              },
                              value: selectedValue,
                              items: dropdownItems))),
                  Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: TextFormField(
                        controller: _fishPrice,
                        decoration: const InputDecoration(
                          hintText: 'Input your fish price',
                          labelText: 'Price',
                        ),
                      )),
                  Visibility(
                      visible: false,
                      child: Container(
                          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextFormField(
                            maxLength: 100,
                            controller: _fishImg,
                            decoration: const InputDecoration(
                              hintText: 'Input your fish image path',
                              labelText: 'Image Path (ie. : baronang.png)',
                            ),
                          ))),
                  SizedBox(height: 40),
                  Container(
                      child: imageFile != null
                          ? Container(
                              width: size.width / 2,
                              height: 150,
                              child: Image.file(
                                imageFile!,
                                fit: BoxFit.cover,
                              ))
                          : Column(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () async {
                                    await selectFile();
                                  },
                                  child: Container(
                                      width: size.width / 2,
                                      height: 150,
                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 231, 231, 231),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      // color: Colors.amber,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(Icons.image,
                                              size: 70, color: Colors.black12),
                                          Text("Choose Image")
                                        ],
                                      )),
                                )
                              ],
                            )),
                  Container(
                      width: size.width,
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: ElevatedButton(
                          onPressed: () {
                            saveFish(
                                widget.fishID,
                                widget.fishCatID,
                                _fishName.text.toString(),
                                _fishDesc.text.toString(),
                                int.parse(_fishPrice.text.toString()),
                                _fishImg.text.toString());
                          },
                          // style: w,
                          child: const Text('Save',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17))))
                ]),
              )),
        )));
  }
}
