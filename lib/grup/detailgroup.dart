import 'package:discoverkorea/providers/api_fanbase.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:discoverkorea/image_detail.dart';
import 'package:discoverkorea/grup/chat_details.dart';
import 'package:discoverkorea/grup/grupsettings.dart';
import 'package:discoverkorea/grup/uploadfilefanbase.dart';
import 'package:discoverkorea/grup/userfollowing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:discoverkorea/providers/api_unggahan.dart';
import 'dart:io';
import 'dart:async';
void main() => runApp(MaterialApp(
      home: DetailGrup(),
    ));

class DetailGrup extends StatefulWidget {
  final String idfan;
  final String groupname;
  final String description;
  final String chairman;

  DetailGrup({this.idfan, this.groupname, this.description, this.chairman});

  @override
  _DetailGrupsState createState() => _DetailGrupsState();
}

class _DetailGrupsState extends State<DetailGrup> {
  String id_fanbase = "";
  String groupname = "";
  String description = "";
  String chairman = "";
  String uidloginnow = "";
  List datafollow;
  String ikutisaya = "Ikuti Fanbase";
  String warnaikuti = '0xfffab3040';
  String followyet = "0";
  String namafanbase = "";
  String idroom = "";
  String admin = "0";
  String photofanbase="";
  String panjangpost="0";
  String follower="0";
  List data3;
  final snackbarKey = GlobalKey<ScaffoldState>();
  SharedPreferences sharedPreferences;
  bool _isLoading = false;

  void initState() {
    super.initState();
    if (this.mounted) {
      setState(() {
        id_fanbase = widget.idfan;
        groupname = widget.groupname;
        description = widget.description;
        Provider.of<ApiUnggahan>(context, listen: false)
            .getPostFanbaseSpecified(widget.idfan);
        followed();
        getfanbase();
        getUnggahan();
        getfollower();
      });
    }
  }

  getfanbase() async {
    var jsonResponse = null;
    var response = await http
        .get("https://discoverkorea.site/apiuser/fanbase2/$id_fanbase");
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
            namafanbase = data3[0]['group_name'];
            description = data3[0]['description'];
            chairman = data3[0]['chairman'];
            idroom = data3[0]['uid'];
            photofanbase = 'https://discoverkorea.site/uploads/profile_fanbase/' +data3[0]['photo'];
            if (chairman == uidloginnow) {
              admin = "1";
            } else {
              admin = "0";
            }
          });
        }
      }
    } else {
      print(response.body);
    }
    // photoprofile = 'https://discoverkorea.site/uploads/profile/' +
    //     data3[0]['profile_picture'];
    // print('profil url ' + '$photoprofile');
  }
  getfollower() async {

    var jsonResponse = null;
    var response =
    await http.get("https://discoverkorea.site/apiuser/followerfanbase/$id_fanbase");
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
  getUnggahan() async {

    var jsonResponse = null;
    var response =
    await http.get("https://discoverkorea.site/apiunggahfanbase/$id_fanbase");
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


  //sudah follow atau belum
  followed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
      // check whether the state object is in tree
      setState(() {
        uidloginnow = prefs.getString("uid");
      });
    }

    var jsonResponse = null;
    var response = await http.get(
        "https://discoverkorea.site/apiuser/fanbasefollowed/$uidloginnow/$id_fanbase");
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
              followyet = "0";
              if (followyet != "0") {
                ikutisaya = "Berhenti Mengikuti";
                warnaikuti = '0xff323aa8';
              } else {
                ikutisaya = "Ikuti Fanbase";
                warnaikuti = '0xfffab3040';
              }
            }

            print('ini uid login sekarang' + uidloginnow);
          });
        }
        print('Follow yet ini adalah' + followyet);
      }
    } else {
      print(response.body);
    }
  }

//follow
  void submit(BuildContext context) {
    if (followyet != "0") {
      Provider.of<ApiFanbase>(context, listen: false)
          .unfollowFanbase(uidloginnow, id_fanbase)
          .then((res) {
        if (res) {
          setState(() {
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
            initState();
          });
        }
      });
    } else {
      Provider.of<ApiFanbase>(context, listen: false)
          .followFanbase(uidloginnow, id_fanbase)
          .then((res) {
        if (res) {
          setState(() {
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
            initState();
          });
        }
      });
    }
  }

  void _showDialog() {
    // flutter defined function

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Pemberitahuan Fanbase"),
          content: new Text(
              "Jika ingin masuk public chat, harap mengikuti fanbase terlebih dahulu."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Tutup"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog2() {
    // flutter defined function

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Pemberitahuan Fanbase"),
          content: new Text(
              "Jika ingin unggah post public, harap mengikuti fanbase terlebih dahulu."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Tutup"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog3() {
    // flutter defined function

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Pemberitahuan Fanbase"),
          content:
              new Text("Hanya admin fanbase yang dapat melakukan pengaturan."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Tutup"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: snackbarKey,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.redAccent, Colors.blueAccent])),
                  child: Container(
                    width: double.infinity,
                    height: 350.0,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Align(
                            alignment: FractionalOffset(-0.03, 1),
                            child: FlatButton(
                              onPressed: () {
                                if (followyet == "0") {
                                  _showDialog();
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => GrupChatDetails(
                                            idfanbase: id_fanbase)),
                                  );
                                }
                              },
                              child: Icon(
                                Icons.chat,
                                size: 25,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          // Align(
                          //   alignment: FractionalOffset(1.03, 0.6),
                          //   child: FlatButton(
                          //     onPressed: () {
                          //       Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) => GrupSettings()),
                          //       );
                          //     },
                          //     child: Icon(
                          //       Icons.settings,
                          //       size: 25,
                          //       color: Colors.white,
                          //     ),
                          //   ),
                          // ),
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              '$photofanbase',
                            ),
                            radius: 50.0,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "$groupname",
                            style: TextStyle(
                              fontSize: 22.0,
                              color: Colors.white,
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
                                          "$panjangpost",
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
                                          "Pengikut",
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
                                                        Fanbasefollowing(idfanbase:id_fanbase),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment: FractionalOffset(1.1, 2),
                        child: FlatButton(
                          onPressed: () {
                            if (followyet == "0"|| admin=="0") {
                              _showDialog3();
                            } else if(followyet=="1" && admin=="1") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        GrupSettings(idfanbase: id_fanbase)),
                              );
                            }
                          },
                          child: Icon(
                            Icons.settings,
                            size: 25,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Align(
                        alignment: FractionalOffset(1.1, 2),
                        child: FlatButton(
                          onPressed: () {
                            if (followyet == "0") {
                              _showDialog2();
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MyHomePage(idfanbase: id_fanbase)),
                              );
                            }
                          },
                          child: Icon(
                            Icons.control_point_duplicate_outlined,
                            size: 25,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 30.0, horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Tentang  Fanbase:",
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontStyle: FontStyle.normal,
                            fontSize: 20.0),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "$description",
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
                          constraints:
                              BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
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
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                margin: EdgeInsets.only(bottom: 0),
                padding: EdgeInsets.only(bottom: 0),
                child: FutureBuilder(
                  future: Provider.of<ApiUnggahan>(context, listen: false)
                      .getFanbasePostSpecified(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasData) {
                      return Consumer<ApiUnggahan>(
                        builder: (context, data, _) {
                          return GridView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: data.dataPostFanbase.length,
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
                                                      data.dataPostFanbase[i]
                                                          .file),
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
                                                id: data.dataPostFanbase[i].id,
                                              )),
                                    ).then((value) => setState(() {}));
                                  },
                                );
                              });
                        },
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 100),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Center(
                                // child: new CircularProgressIndicator(),
                                ),
                            SizedBox(
                              height: 50,
                            ),
                            Text('Tidak ada Unggahan dari Fanbase')
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
              // Container(
              //   child: FutureBuilder<List<String>>(
              //     future: fetchGalleryData(),
              //     builder: (context, snapshot) {
              //       if (snapshot.hasData) {
              //         return GridView.builder(
              //             shrinkWrap: true,
              //             physics: ScrollPhysics(),
              //             itemCount: snapshot.data.length,
              //             gridDelegate:
              //                 SliverGridDelegateWithFixedCrossAxisCount(
              //                     crossAxisCount: 3),
              //             itemBuilder: (context, index) {
              //               return new InkWell(
              //                 child: new Card(
              //                   child: new GridTile(
              //                       child: Container(
              //                           decoration: new BoxDecoration(
              //                               image: new DecorationImage(
              //                                   image: new NetworkImage(
              //                                       snapshot.data[index]),
              //                                   fit: BoxFit.cover)))),
              //                 ),
              //                 onTap: () {
              //                   Navigator.push(
              //                       context,
              //                       MaterialPageRoute(
              //                         builder: (context) => ImageDetail(),
              //                       ));
              //                 },
              //               );
              //             });
              //       }
              //       return Center(child: CircularProgressIndicator());
              //     },
              //   ),
              // ),
            ],
          ),
        ));
  }
}

Future<List<String>> fetchGalleryData() async {
  try {
    final response = await http
        .get(
            'https://kaleidosblog.s3-eu-west-1.amazonaws.com/flutter_gallery/data.json')
        .timeout(Duration(seconds: 5));

    if (response.statusCode == 200) {
      return compute(parseGalleryData, response.body);
    } else {
      throw Exception('Failed to load');
    }
  } on SocketException catch (e) {
    throw Exception('Failed to load');
  }
}

List<String> parseGalleryData(String responseBody) {
  final parsed = List<String>.from(json.decode(responseBody));
  return parsed;
}
