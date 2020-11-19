import 'package:flutter/material.dart';
import 'package:discoverkorea/animation/FadeAnimation.dart';
import 'package:discoverkorea/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:discoverkorea/providers/api_user.dart';
import 'package:discoverkorea/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class EditBioScreen extends StatefulWidget {
  final String id;
  EditBioScreen({this.id});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<EditBioScreen> {
  final TextEditingController _bio = TextEditingController();
  bool _isLoading = false;
  bool _dark;
  SharedPreferences sharedPreferences;
  String username = "";
  List data;
  String uid = "";
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
    _bio.text = data[0]['biodata'];
  }
  void submit(BuildContext context) {

      Provider.of<ApiUser>(context, listen: false)
          .editbio(
        uid,
        _bio.text,
      )
          .then((res) {
            print(res);
        if (res) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Settings()),
              (route) => false);
        } else {
          var snackbar = SnackBar(
            content: Text('Terjadi Kesalahan, biodata tidak bisa diperbaharui'),
          );
          snackbarKey.currentState.showSnackBar(snackbar);
          setState(() {
            _isLoading = false;
          });
        }
      });

  }

  Brightness _getBrightness() {
    return _dark ? Brightness.dark : Brightness.light;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:snackbarKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          brightness: _getBrightness(),
          iconTheme: IconThemeData(color: _dark ? Colors.white : Colors.black),
          backgroundColor: Colors.transparent,
          title: Text(
            'Ubah Biodata',
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
                                    controller: _bio,
                                    maxLines: 8,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText:
                                            "Ketikan tentangmu dan minatmu seputar korea..",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400])),
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
                              child: Text('Ubah Biodata',
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
