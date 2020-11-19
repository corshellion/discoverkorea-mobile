import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:discoverkorea/image_detail.dart';
import 'package:discoverkorea/settings.dart';
import 'package:provider/provider.dart';
import 'package:discoverkorea/providers/api_unggahan.dart';
import 'package:discoverkorea/providers/api_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:discoverkorea/login_screen.dart';
import 'package:discoverkorea/tab_view_profile.dart';
import 'dart:async';
import 'package:discoverkorea/models/model_user.dart';

class ProfileApp extends StatefulWidget {
  @override
  _ProfilesScreenState createState() => _ProfilesScreenState();
}

class _ProfilesScreenState extends State<ProfileApp> {
  SharedPreferences sharedPreferences;
  List<UserModel> _datauser = [];

  List<UserModel> get dataUser => _datauser;

  @override
  void initState() {
    super.initState();

    getuser();
    getUser2();
    getfollower();
    getfollowing();
    getUnggahan();
  }

  TabController _tabController;
  String username = "";
  String profile = "";
  String nama = "";
  String uid = "";
  String bio = "";
  String follower = "0";
  String following = "0";
  String panjangpost = "0";
  String verified = "0";
  bool lencana = false;
  List data3;

  getuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        username = prefs.getString("username");
      });
    }

    var jsonResponse = null;
    var response =
        await http.get("https://discoverkorea.site/apiuser/$username");
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        if (this.mounted) {
          setState(() {
            //RESPONSE YANG DIDAPATKAN DARI API TERSEBUT DI DECODE
            var content = json.decode(response.body);
            //KEMUDIAN DATANYA DISIMPAN KE DALAM VARIABLE data,
            //DIMANA SECARA SPESIFIK YANG INGIN KITA AMBIL ADALAH ISI DARI KEY hasil
            data3 = content['values'];
          });
        }
      }
    } else {
      print(response.body);
    }
    nama = data3[0]['nama'];
    verified = data3[0]['verified'];
    if (verified == "0") {
      lencana = false;
    } else {
      lencana = true;
    }
    bio = data3[0]['biodata'];
    profile = 'https://discoverkorea.site/uploads/profile/' +
        data3[0]['profile_picture'];
    print('profil url ' + '$profile');
  }

  Future<List<UserModel>> getUser2() async {
    final url = 'https://discoverkorea.site/apiuser/$username';
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final result =
          json.decode(response.body)['values'].cast<Map<String, dynamic>>();
      _datauser =
          result.map<UserModel>((json) => UserModel.fromJson(json)).toList();

      // return _datauser;
    } else {
      throw Exception();
    }
  }

  getfollower() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        uid = prefs.getString("uid");
      });
    }
    var jsonResponse = null;
    var response =
        await http.get("https://discoverkorea.site/apiuser/follower/$uid");
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        if (this.mounted) {
          setState(() {
            //RESPONSE YANG DIDAPATKAN DARI API TERSEBUT DI DECODE
            var content = json.decode(response.body);
            //KEMUDIAN DATANYA DISIMPAN KE DALAM VARIABLE data,
            //DIMANA SECARA SPESIFIK YANG INGIN KITA AMBIL ADALAH ISI DARI KEY hasil
            data3 = content['values'];
            follower = data3.length.toString();

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
    if (this.mounted) {
      setState(() {
        uid = prefs.getString("uid");
      });
    }
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

  getUnggahan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        username = prefs.getString("username");
      });
    }
    var jsonResponse = null;
    var response =
        await http.get("https://discoverkorea.site/apiunggah/$username");
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        if (this.mounted) {
          setState(() {
            //RESPONSE YANG DIDAPATKAN DARI API TERSEBUT DI DECODE
            var content = json.decode(response.body);
            //KEMUDIAN DATANYA DISIMPAN KE DALAM VARIABLE data,
            //DIMANA SECARA SPESIFIK YANG INGIN KITA AMBIL ADALAH ISI DARI KEY hasil
            data3 = content['values'];
            panjangpost = data3.length.toString();
            print(panjangpost + "<<<ini dia");
          });
        }
      }
    } else {
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        alignment: FractionalOffset(1.03, 0.6),
                        child: FlatButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Settings()),
                            );
                          },
                          child: Icon(
                            Icons.settings,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          '$profile' ?? '',
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
                                nama ?? 'terjadi kesalahan',
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
                        '@' + "$username" ?? '',
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
                                      '$panjangpost' ?? '0',
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
                                                    FollowingProfiles(1),
                                              ));
                                        },
                                        child: new Text(
                                          "$follower" ?? '0',
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
                                    new GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    FollowingProfiles(2),
                                              ));
                                        },
                                        child: new Text(
                                          "$following" ?? '0',
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
                                    new GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FollowingProfiles(3)));
                                        },
                                        child: new Text(
                                          "3200" ?? '0',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.pinkAccent,
                                          ),
                                        )),
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
              padding:
                  const EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
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
                    "$bio" ?? '',
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
            height: 10.0,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            margin: EdgeInsets.only(bottom: 0),
            padding: EdgeInsets.only(bottom: 0),
            child: FutureBuilder(
              future: Provider.of<ApiUnggahan>(context, listen: false)
                  .getPostSpecified(),
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
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                                    builder: (context) => ImageDetail(
                                          id: data.dataPost[i].id,
                                        )),
                              ).then((value) => setState(() {}));
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
    ));
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
