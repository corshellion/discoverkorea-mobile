import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:discoverkorea/image_detail.dart';
import 'package:discoverkorea/settings.dart';
import 'package:provider/provider.dart';
import 'package:discoverkorea/providers/api_unggahan.dart';
import 'package:discoverkorea/home_page.dart';
import 'package:discoverkorea/providers/api_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:discoverkorea/login_screen.dart';
import 'package:discoverkorea/tab_view_otherprofile.dart';
import 'package:discoverkorea/pages/chat_details2.dart';
import 'dart:async';
import 'package:discoverkorea/models/model_user.dart';
import 'package:discoverkorea/providers/api_mengikuti.dart';

class OtherProfileApp extends StatefulWidget {
  final String username;

  OtherProfileApp({this.username});

  @override
  _ProfilesScreenState2 createState() => _ProfilesScreenState2();
}

class _ProfilesScreenState2 extends State<OtherProfileApp> {
  SharedPreferences sharedPreferences;
  List<UserModel> _datauser = [];

  List<UserModel> get dataUser => _datauser;
  List<UserModel> _datauser1 = [];

  List<UserModel> get dataUser1 => _datauser1;
  String othername = "";
  String username = "";
  String uidloginothers = "";
  String uid = "";
  String profileorang = "";
  String namaorang = "";
  String bioorang = "-";
  String panjangpostorang = "";
  String followyet = "0";
  String follower = "0";
  String following = "0";
  String ikutisaya = "Ikuti Saya";
  String warnaikuti = '0xfffab3040';
  List datalain;
  List datafollow;
  List data3;
  String verified = "0";
  bool lencana = false;

  @override
  void initState() {
    Provider.of<ApiUnggahan>(context, listen: false)
        .getOtherPostSpecified(widget.username);
    othername = widget.username;

    super.initState();
    setState(() {
      getUser2();
      getFromSharedPreferences();
      getUnggahan();
    });
  }

  //GET USER LOGIN
  void getFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
      // check whether the state object is in tree
      setState(() {
        username = prefs.getString("username");
        uidloginothers = prefs.getString("uid");
        print(username);
      });
    }
  }

  Future<List<UserModel>> getUser2() async {
    final url = "https://discoverkorea.site/apiuser/$othername";
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final result =
          json.decode(response.body)['values'].cast<Map<String, dynamic>>();
      _datauser =
          result.map<UserModel>((json) => UserModel.fromJson(json)).toList();
      print(_datauser[0].biodata);

      if (this.mounted) {
        // check whether the state object is in tree
        setState(() {
          uid = _datauser[0].uid;
          namaorang = _datauser[0].nama;
          verified = _datauser[0].verified;
          if (verified == "0") {
            lencana = false;
          } else {
            lencana = true;
          }
          bioorang = _datauser[0].biodata;
          if (_datauser[0].biodata == null) {
            bioorang = "Hai korean fans, namaku $namaorang :)";
          }

          profileorang = 'https://discoverkorea.site/uploads/profile/' +
              _datauser[0].profile_picture;
          getfollower();
          getfollowing();
          followed();
        });
      }
      // return _datauser;

    } else {
      throw Exception();
    }
  }

  final snackbarKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;

//sudah follow atau belum
  followed() async {
    var jsonResponse = null;
    var response = await http.get(
        "https://discoverkorea.site/apiuser/followed/$uidloginothers/$uid");
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        if (this.mounted) {
          setState(() {
            try {
              var content2 = json.decode(response.body);
              datafollow = content2['values'];
              followyet = datafollow.length.toString() ?? "0";
              if (followyet != "0") {
                ikutisaya = "Berhenti Mengikuti";
                warnaikuti = '0xff323aa8';
              }
            } catch (error) {
              followyet="0";
              if (followyet != "0") {
                ikutisaya = "Berhenti Mengikuti";
                warnaikuti = '0xff323aa8';
              } else {
                ikutisaya = "Ikuti Saya";
                warnaikuti = '0xfffab3040';
              }
            }
          });
        }
      }
    } else {
      print(response.body);
    }
  }

//melihat jumlah unggahan user
  getUnggahan() async {
    var jsonResponse = null;
    var response =
        await http.get("https://discoverkorea.site/apiunggah/$othername");
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        if (this.mounted) {
          setState(() {
            //RESPONSE YANG DIDAPATKAN DARI API TERSEBUT DI DECODE
            var content = json.decode(response.body);
            //KEMUDIAN DATANYA DISIMPAN KE DALAM VARIABLE data,
            //DIMANA SECARA SPESIFIK YANG INGIN KITA AMBIL ADALAH ISI DARI KEY hasil
            datalain = content['values'];
            panjangpostorang = datalain.length.toString();
            print(panjangpostorang + "<<<ini dia");
          });
        }
      }
      print("other name adalah $othername");
    } else {
      print(response.body);
    }
  }

  getfollower() async {
    var jsonResponse = null;
    var response =
        await http.get("https://discoverkorea.site/apiuser/follower/$uid");
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        if (this.mounted) {
          setState(() {
            try {
              //RESPONSE YANG DIDAPATKAN DARI API TERSEBUT DI DECODE
              var content = json.decode(response.body);
              //KEMUDIAN DATANYA DISIMPAN KE DALAM VARIABLE data,
              //DIMANA SECARA SPESIFIK YANG INGIN KITA AMBIL ADALAH ISI DARI KEY hasil
              data3 = content['values'];
              follower = data3.length.toString();
            } catch (error) {
              follower="0";
            }


            print(follower + "<<<ini dia followernya");
          });
        }
      }
    } else {
      print(response.body);
    }
  }

  getfollowing() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var jsonResponsefollowing = null;
    var responsefollowing =
        await http.get("https://discoverkorea.site/apiuser/following/$uid");
    if (responsefollowing.statusCode == 200) {
      jsonResponsefollowing = json.decode(responsefollowing.body);
      if (jsonResponsefollowing != null) {
        if (this.mounted) {
          setState(() {
            //RESPONSE YANG DIDAPATKAN DARI API TERSEBUT DI DECODE
            var contentfollowing = json.decode(responsefollowing.body);
            //KEMUDIAN DATANYA DISIMPAN KE DALAM VARIABLE data,
            //DIMANA SECARA SPESIFIK YANG INGIN KITA AMBIL ADALAH ISI DARI KEY hasil
            data3 = contentfollowing['values'];

            following = data3.length.toString();

            print(following + "<<<ini dia followingnya");
            print(uid + "<<<ini dia uidnya");
          });
        }
      }
    } else {
      print(responsefollowing.body);
    }
  }

//follow
  void submit(BuildContext context) {
    if (followyet != "0") {
      Provider.of<ApiUser>(context, listen: false)
          .unfollowUser(
        uidloginothers,
        uid,
      )
          .then((res) {
        if (res) {
          setState(() {
            getfollower();
            getfollowing();
            followed();
          });
        } else {
          setState(() {
            getfollower();
            getfollowing();
            followed();
          });
        }
      });
    } else {
      Provider.of<ApiUser>(context, listen: false)
          .followUser(
        uidloginothers,
        uid,
      )  .then((res) {
        if (res) {
          setState(() {
            getfollower();
            getfollowing();
            followed();
          });
        } else {
          print(res);
          var snackbar = SnackBar(
            content: Text('Ops, Error. Hubungi Admin'),
          );
          snackbarKey.currentState.showSnackBar(snackbar);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

//message
  void message(BuildContext context) {
    Provider.of<ApiUser>(context, listen: false)
        .messageUser(
      uidloginothers,
      uid,
    )
        .then((res) {
      if (res) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => ChatDetails2(
                username: username,
                receiver: othername,
                uidreceiverpas: uid,
              ),
            ),
            (route) => false);
      } else {
        print(res);
        var snackbar = SnackBar(
          content: Text('Ops, Error. Hubungi Admin'),
        );
        snackbarKey.currentState.showSnackBar(snackbar);
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
          key: snackbarKey,
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.redAccent, Colors.pinkAccent])),
                    child: Container(
                      width: double.infinity,
                      height: 350.0,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Align(
                              alignment: FractionalOffset(0, 1),
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                  );
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                '$profileorang' ?? '',
                              ),
                              radius: 50.0,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Center(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "$namaorang" ?? 'terjadi kesalahan',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 22.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    lencana
                                        ? Icon(
                                            Icons.verified,
                                            color: Colors.lightBlue,
                                            size: 18,
                                          )
                                        : Text(
                                            '',
                                          ),
                                  ]),
                            ),
                            Text(
                              '@' + "$othername" ?? '',
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Card(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 5.0),
                              clipBehavior: Clip.antiAlias,
                              color: Colors.white,
                              elevation: 5.0,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 22.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            "Unggahan",
                                            style: TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            '$panjangpostorang' ?? '',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.pinkAccent,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            "Fans",
                                            style: TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          new GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          Tabview(uid: uid),
                                                    ));
                                              },
                                              child: new Text(
                                                '$follower' ?? '',
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.pinkAccent,
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            "Mengikuti",
                                            style: TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            '$following' ?? '',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.pinkAccent,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            "Fanbase",
                                            style: TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            "1300",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.pinkAccent,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30.0, horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            color: Colors.transparent,
                            child: Text(
                              "Bio:",
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 22.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "$bioorang" ?? "Tidak ada biodata pada profil ini...",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 0.0,
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: SizedBox()),
                    Container(
                      width: 180.00,
                      child: RaisedButton(
                        onPressed: () => submit(context),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0)),
                        elevation: 0.0,
                        padding: EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                                colors: [
                                  Color(int.parse(warnaikuti)),
                                  Colors.pinkAccent
                                ]),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 300.0, minHeight: 50.0),
                            alignment: Alignment.center,
                            child: Text(
                              "$ikutisaya",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Container(
                      width: 180.00,
                      child: RaisedButton(
                          onPressed: () => message(context),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80.0)),
                          elevation: 0.0,
                          padding: EdgeInsets.all(0.0),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerRight,
                                  end: Alignment.centerLeft,
                                  colors: [
                                    Colors.redAccent,
                                    Colors.pinkAccent
                                  ]),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Container(
                              constraints: BoxConstraints(
                                  maxWidth: 300.0, minHeight: 50.0),
                              alignment: Alignment.center,
                              child: Text(
                                "Hubungi saya",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          )),
                    ),
                    Expanded(child: SizedBox()),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  margin: EdgeInsets.only(bottom: 0),
                  padding: EdgeInsets.only(bottom: 0),
                  child: FutureBuilder(
                    future: Provider.of<ApiUnggahan>(context, listen: false)
                        .getOtherPost(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Consumer<ApiUnggahan>(
                        builder: (context, data, _) {
                          return GridView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: data.dataPost.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3),
                              itemBuilder: (context, i) {
                                return new InkWell(
                                  child: new Card(
                                    child: new GridTile(
                                      child: Container(
                                        decoration: new BoxDecoration(
                                          image: new DecorationImage(
                                              image: new NetworkImage(
                                                  'https://discoverkorea.site/uploads/file/' +
                                                      data.dataPost[i].file),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ImageDetail(),
                                        ));
                                  },
                                );
                              });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

// Future<List<String>> fetchGalleryData() async {
//   try {
//     final response = await http
//         .get(
//             'https://kaleidosblog.s3-eu-west-1.amazonaws.com/flutter_gallery/data.json')
//         .timeout(Duration(seconds: 5));

//     if (response.statusCode == 200) {
//       return compute(parseGalleryData, response.body);
//     } else {
//       throw Exception('Failed to load');
//     }
//   } on SocketException catch (e) {
//     throw Exception('Failed to load');
//   }
// }

// List<String> parseGalleryData(String responseBody) {
//   final parsed = List<String>.from(json.decode(responseBody));
//   return parsed;
// }

////
///
///Tampungan Profiles
//  Container(
//             child: FutureBuilder<List<String>>(
//               future: fetchGalleryData(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   return GridView.builder(
//                       shrinkWrap: true,
//                       physics: ScrollPhysics(),
//                       itemCount: snapshot.data.length,
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 3),
//                       itemBuilder: (context, index) {
//                         return new InkWell(
//                           child: new Card(
//                             child: new GridTile(
//                                 child: Container(
//                                     decoration: new BoxDecoration(
//                                         image: new DecorationImage(
//                                             image: new NetworkImage(
//                                                 snapshot.data[index]),
//                                             fit: BoxFit.cover)))),
//                           ),
//                           onTap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => ImageDetail(),
//                                 ));
//                           },
//                         );
//                       });
//                 }
//                 return Center(child: CircularProgressIndicator());
//               },
//             ),
//           ),
