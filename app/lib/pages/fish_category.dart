import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:he_fish/pages/insert_fish.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import './detail_fish.dart';

class FishCategoryPage extends StatefulWidget {
  List categories;
  int categoryID;
  String categoryName;

  FishCategoryPage(
      {required this.categories,
      required this.categoryID,
      required this.categoryName});

  @override
  State<FishCategoryPage> createState() => _FishCategoryPageState();
}

class _FishCategoryPageState extends State<FishCategoryPage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    getFish(widget.categoryID);
    // setState(() {
    //   current = widget.categoryID;
    // });
    print(widget.categories);
  }

  int current = 0;
  int selected = 1;
  List _data = [];

  getFish(fishType) async {
    print(fishType);
    final String apiUrl = "${httpUrl}fishes/category/${fishType}";
    var result = await http.get(Uri.parse(apiUrl));
    var data = jsonDecode(result.body.toString());
    // print(data['fishes']);
    setState(() {
      _data = data['fishes'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FISH LIST',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 103, 197, 255),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: Container(
        color: Color.fromARGB(255, 103, 197, 255),
//        margin: const EdgeInsets.all(5),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            SizedBox(
              height: 60,
              width: double.infinity,
              child: ListView.builder(
                  itemCount: widget.categories.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, index) {
                    return GestureDetector(
                        onTap: () {
                          int _i = widget.categories[index]["id"];
                          setState(() {
                            current = index;
                          });
                          getFish(_i);
                        },
                        child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.all(2),
                            width: 120,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: current == index
                                  ? Color.fromARGB(255, 32, 68, 92)
                                  : Colors.blue[100],
                            ),
                            child: Center(
                                child: Text(widget.categories[index]["name"],
                                    style: TextStyle(
                                        color: current == index
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)))));
                  }),
            ),
            SizedBox(height: 50),
            ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DetailFish(
                            fishCatID: widget.categoryID,
                            fishCategory: _data[index]["fish_type"]["name"],
                            fishID: _data[index]["id"],
                            fishName: _data[index]["name"],
                            fishDesc: _data[index]["description"],
                            fishPrice: _data[index]["price"],
                            fishImg: _data[index]["image_path"],
                            fishCreator: _data[index]["user"]["username"],
                            fishCreatorID: _data[index]["user"]["id"])))
                  },
                  leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                      backgroundImage: AssetImage(
                          "assets/items/${_data[index]["image_path"]}")),
                  title: Text(_data[index]['name'],
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  subtitle: Text('Rp ${_data[index]['price']}'),
                );
              },
              itemCount: _data.length,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => InsertFish(
                  catID: widget.categoryID, catName: widget.categoryName)));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
