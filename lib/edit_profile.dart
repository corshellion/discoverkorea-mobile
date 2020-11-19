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
class EditProfileScreen2 extends StatefulWidget {
  final String uid;
  EditProfileScreen2({this.uid});
  @override
  _HomeScreenState2 createState() => _HomeScreenState2();
}

class _HomeScreenState2 extends State<EditProfileScreen2> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _nohp = TextEditingController();
  final TextEditingController _nama = TextEditingController();
  final TextEditingController _kota = TextEditingController();
  bool _isLoading = false;
  bool _dark;
  SharedPreferences sharedPreferences;
  String username = "";
  String uid = "";
  String pesan="";
  List data;
  final snackbarKey = GlobalKey<ScaffoldState>();
  void initState() {
    getFromSharedPreferences();
    _dark = false;
    super.initState();
    print(uid);
  }
  void getFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
      // check whether the state object is in tree
      setState(() {
        username = prefs.getString("username");
        print(username);
        print(uid);
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
            _username.text = data[0]['username'];
      _email.text = data[0]['email'];
      _nohp.text = data[0]['nohp'];
            _nama.text = data[0]['nama'];
            _kota.text = data[0]['alamat'];
  }
  void submit(BuildContext context) async {
    Map data = { 'id': uid,
      'username': _username.text,
      'email': _email.text,
      'nohp': _nohp.text,
      'nama':  _nama.text,
      'alamat': _kota.text,};
    var jsonResponse = null;
    var response =
        await http.post('https://discoverkorea.site/apiuser/updatedetailakun/' + uid, body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse['message']);
      if (jsonResponse['message'] == 'Success!') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('username', _username.text);
        var snackbar = SnackBar(
          content: Text('Data Profilmu berhasil diubah..', style: TextStyle(color: Colors.white.withOpacity(0.8))),
          backgroundColor: Colors.black,
        );
        snackbarKey.currentState.showSnackBar(snackbar);
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (BuildContext context) => EditProfileScreen2()),
        //         (Route<dynamic> route) => false);
      }else {
        var snackbar = SnackBar(
          content: Text(jsonResponse['message'], style: TextStyle(color: Colors.white.withOpacity(0.8))),
          backgroundColor: Colors.black,
        );
        snackbarKey.currentState.showSnackBar(snackbar);
      }
    } else {
      var snackbar = SnackBar(
        content: Text(jsonResponse['message'], style: TextStyle(color: Colors.white.withOpacity(0.8))),
        backgroundColor: Colors.black,
      );
      snackbarKey.currentState.showSnackBar(snackbar);
    }

      // Provider.of<ApiUser>(context, listen: false)
      //     .editprofile(
      //   uid,
      //   _username.text,
      //   _email.text,
      //   _nohp.text,
      //   _nama.text,
      //   _kota.text,
      // )
      //     .then((res) {
      //   if (res) {
      //     Navigator.of(context).pushAndRemoveUntil(
      //         MaterialPageRoute(builder: (context) => EditProfileScreen2()),
      //         (route) => false);
      //
      //   } else {
      //     var snackbar = SnackBar(
      //       content: Text('Ops, Error. Hubungi Admin'),
      //     );
      //     snackbarKey.currentState.showSnackBar(snackbar);
      //     setState(() {
      //       _isLoading = false;
      //     });
      //   }
      //
      // });

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
            'Ubah Profilmu',
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
                                  controller: _username,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Username",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400])),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
                                  controller: _email,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "E-mail",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400])),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
                                  controller: _nohp,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "No Handphone",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400]),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Nama Lengkap",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400])),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
                                  controller: _kota,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Kota",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400])),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
                              child: Text('Ubah Detail Akun',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(pesan,
                            style: TextStyle(color: Colors.redAccent)),
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
