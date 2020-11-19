import 'package:flutter/material.dart';
import 'package:discoverkorea/animation/FadeAnimation.dart';
import 'package:discoverkorea/home_page.dart';
import 'package:discoverkorea/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") != null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => HomePage()),
          (Route<dynamic> route) => false);
    }
  }

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final snackbarKey = GlobalKey<ScaffoldState>();
  bool _obscureText1 = false;
  bool _obscureText2 = false;
  // Toggles the password show status
  void _togglevisibility() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
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
                  height: 350,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 80,
                        height: 200,
                        child: FadeAnimation(
                            1,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/light-1.png'))),
                            )),
                      ),
                      Positioned(
                        left: 140,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(
                            1.3,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/light-2.png'))),
                            )),
                      ),
                      Positioned(
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(
                            1.5,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/clock.png'))),
                            )),
                      ),
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
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      icon: Icon(Icons.verified_user_rounded,
                                          color: Colors.black),
                                      border: InputBorder.none,
                                      hintText: "Username",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400]),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: passwordController,
                                    obscureText: !_obscureText1,
                                    decoration: InputDecoration(
                                      icon:
                                          Icon(Icons.lock, color: Colors.black),
                                      border: InputBorder.none,
                                      hintText: "Password",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400]),
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          _togglevisibility();
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
                              onPressed: () {
                                signIn(emailController.text,
                                    passwordController.text);
                              },
                              color: Color(0xffa8325c),
                              child: Text('Masuk',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FadeAnimation(
                          1.5,
                          FlatButton(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterScreen(),
                                  ));
                            },
                            child: new Text("Daftar Sekarang"),
                          )),
                      FadeAnimation(
                          1.5,
                          FlatButton(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            onPressed: () {
                              Navigator.pushNamed(context, "YourRoute");
                            },
                            child: new Text("Lupa kata sandi?"),
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  signIn(String username, password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'username': username, 'password': password};
    var jsonResponse = null;
    var response =
        await http.post("https://discoverkorea.site/apiloginpost", body: data);
    jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {

      if (jsonResponse != null) {
        sharedPreferences.setString("token", jsonResponse['success']['token']);
        sharedPreferences.setString(
            "username", jsonResponse['success']['username']);
        sharedPreferences.setString("uid", jsonResponse['success']['uid']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => HomePage()),
            (Route<dynamic> route) => false);
      }
    } else {
      var snackbar = SnackBar(
        content: Text(jsonResponse['message'], style: TextStyle(color: Colors.white.withOpacity(0.8))),
        backgroundColor: Colors.black,
      );
      snackbarKey.currentState.showSnackBar(snackbar);
    }
  }
}
