import 'package:flutter/material.dart';
import 'package:discoverkorea/animation/FadeAnimation.dart';
import 'package:discoverkorea/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:discoverkorea/providers/api_user.dart';
import 'package:discoverkorea/login_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class RegisterScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<RegisterScreen> {
  final TextEditingController _nama = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmation = TextEditingController();
  bool _isLoading = false;

  final snackbarKey = GlobalKey<ScaffoldState>();
  bool _obscureText1 = false;
  bool _obscureText2 = false;
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
  FocusNode emailNode = FocusNode();
  FocusNode usernameNode = FocusNode();
  Future<void> submit(BuildContext context) async {
    Map data = { 'email': _email.text,
      'name': _nama.text,
      'username': _username.text,
      'password': _password.text,
      'confirmation': _confirmation.text,};
    var jsonResponse = null;
    var response =
        await http.post("https://discoverkorea.site/apiuser/store", body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
                (Route<dynamic> route) => false);
      }
    } else {
      var snackbar = SnackBar(
        content: Text(response.body, style: TextStyle(color: Colors.white.withOpacity(0.8))),
        backgroundColor: Colors.black,
      );
      snackbarKey.currentState.showSnackBar(snackbar);
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: snackbarKey,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background2.png'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        child: FadeAnimation(
                            1.6,
                            Container(
                              margin: EdgeInsets.only(top: 50),
                              child: Center(
                                child: Text(
                                  "",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
                ),
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
                                    controller: _nama,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Nama Lengkap",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400])),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[100]))),
                                  child: TextField(
                                    controller: _username,
                                    focusNode: usernameNode,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Username",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400])),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[100]))),
                                  child: TextField(
                                    controller: _email,
                                    focusNode: emailNode,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "E-mail",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400])),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: _password,
                                    obscureText: !_obscureText1,
                                    decoration: InputDecoration(
                                      icon:
                                      Icon(Icons.lock, color: Colors.black),
                                      border: InputBorder.none,
                                      hintText: "Kata Sandi",
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
                                  child: TextField(
                                    controller: _confirmation,
                                    obscureText: !_obscureText2,
                                    decoration: InputDecoration(
                                      icon:
                                      Icon(Icons.lock, color: Colors.black),
                                      border: InputBorder.none,
                                      hintText: "Ulangi Kata Sandi",
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
                                )
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
                              child: Text('Daftar Sekarang',
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
