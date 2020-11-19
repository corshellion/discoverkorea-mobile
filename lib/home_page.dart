import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:discoverkorea/beer_list.dart';
import 'package:discoverkorea/profiles.dart';
import 'package:discoverkorea/login_screen.dart';
import 'package:discoverkorea/notification.dart';
import 'package:discoverkorea/search.dart';
import 'package:discoverkorea/uploadfile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  SharedPreferences sharedPreferences;
  String username = "";
  String token = "";
  List data;
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    getFromSharedPreferences();
  }

  void getFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
      // check whether the state object is in tree
      setState(() {
        username = prefs.getString("username");
        print(username);
      });
    }

    var jsonResponse = null;
    var response =
        await http.get("https://discoverkorea.site/apiuser/" + username);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          //RESPONSE YANG DIDAPATKAN DARI API TERSEBUT DI DECODE
          var content = json.decode(response.body);
          //KEMUDIAN DATANYA DISIMPAN KE DALAM VARIABLE data,
          //DIMANA SECARA SPESIFIK YANG INGIN KITA AMBIL ADALAH ISI DARI KEY hasil
          data = content['values'];
        });
      }
    } else {
      print(response.body);
    }
    token = data[0]['remember_token'];
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") != token) {
      sharedPreferences.clear();
      sharedPreferences.commit();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
          (Route<dynamic> route) => false);
    }
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
          (Route<dynamic> route) => false);
    }
  }

  int selectedIndex = 0;
  final widgetOptions = [
    new BeerListPage(),
    new Discover(),
    new Uploadfile(),
    new Notifikasi(),
    new ProfileApp(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white30,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), title: Text('Beranda')),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), title: Text('Telusuri')),
          BottomNavigationBarItem(
              icon: Icon(Icons.camera_enhance_rounded), title: Text('Unggah')),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), title: Text('Notifikasi')),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/emperor.png"),
              // color: Color(0xFF3A5A98),
            ),
            title: Text('Akun'),
          ),
        ],
        currentIndex: selectedIndex,
        fixedColor: Colors.black,
        onTap: onItemTapped,
      ),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}

///
///
///
