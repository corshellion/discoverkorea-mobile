import 'package:flutter/material.dart';
import 'package:discoverkorea/animation/FadeAnimation.dart';
import 'package:discoverkorea/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:discoverkorea/providers/api_user.dart';
import 'package:discoverkorea/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class EditProfileScreen extends StatefulWidget {
  final String id;
  EditProfileScreen({this.id});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<EditProfileScreen> {
  final TextEditingController _oldpassword = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmation = TextEditingController();
  bool _isLoading = false;
  bool _dark;
  SharedPreferences sharedPreferences;
  String username = "";
  List data;
  String uid = "";
  String oldpassword = "";
  final snackbarKey = GlobalKey<ScaffoldState>();
  void initState() {
    getFromSharedPreferences();
    _dark = false;
    super.initState();
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
    uid = data[0]['uid'];
  }
  FocusNode emailNode = FocusNode();
  FocusNode usernameNode = FocusNode();
  void submit(BuildContext context) {


      Provider.of<ApiUser>(context, listen: false)
          .editPassword(
              uid, _oldpassword.text, _password.text, _confirmation.text)
          .then((res) {
        if (res) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Settings()),

              (route) => false);
        } else {
          var snackbar = SnackBar(
            content: Text('Pastikan Kata sandi lama benar atau kata sandi baru sama dengan konfirmasi!', style: TextStyle(color: Colors.black.withOpacity(0.8))),
            backgroundColor: Colors.white,
          );
          snackbarKey.currentState.showSnackBar(snackbar);
          setState(() {
            _isLoading = false;
          });
        }
      });

  }

  bool _obscureText1 = false;
  bool _obscureText2 = false;
  bool _obscureText3 = false;
  // Toggles the password show status
  void _togglevisibility() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  void _togglevisibility2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  void _togglevisibility3() {
    setState(() {
      _obscureText3 = !_obscureText3;
    });
  }

  Brightness _getBrightness() {
    return _dark ? Brightness.dark : Brightness.light;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: snackbarKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          brightness: _getBrightness(),
          iconTheme: IconThemeData(color: _dark ? Colors.white : Colors.black),
          backgroundColor: Colors.transparent,
          title: Text(
            'Ubah Kata Sandi',
            style: TextStyle(color: _dark ? Colors.white : Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      FadeAnimation(
                          1.8,
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(143, 148, 251, .2),
                                      blurRadius: 20.0,
                                      offset: Offset(0, 10))
                                ]),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[100]))),
                                  child: TextField(
                                    controller: _oldpassword,
                                    obscureText: !_obscureText1,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Kata Sandi Lama",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400]),
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          _togglevisibility();
                                        },
                                        child: Icon(
                                          _obscureText1
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[100]))),
                                  child: TextField(
                                    controller: _password,
                                    focusNode: usernameNode,
                                    obscureText: !_obscureText2,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Kata Sandi Baru",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400]),
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          _togglevisibility2();
                                        },
                                        child: Icon(
                                          _obscureText2
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[100]))),
                                  child: TextField(
                                    controller: _confirmation,
                                    focusNode: emailNode,
                                    obscureText: !_obscureText3,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Ulangi Kata Sandi",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400]),
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          _togglevisibility3();
                                        },
                                        child: Icon(
                                          _obscureText3
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      FadeAnimation(
                        2,
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 0.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(30.0),
                            shadowColor: Colors.orangeAccent.shade100,
                            elevation: 8.0,
                            child: MaterialButton(
                              minWidth: 400.0,
                              height: 50.0,
                              onPressed: () => submit(context),
                              color: Color(0xffa8325c),
                              child: Text('Ubah kata sandi',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
