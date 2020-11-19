import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:discoverkorea/providers/api_mengikuti.dart';
import 'package:provider/provider.dart';
import 'package:discoverkorea/otherprofiles.dart';
import 'package:discoverkorea/profiles2.dart';
class Struktur extends StatefulWidget {

  final String idfanbase;

  Struktur({this.idfanbase});
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Struktur> {

  List data3;
  String uidnow="";
  String uidmember="";
  String username="";
  String id_fanbase="";
  String chairman="";
  @override
  void initState() {
    getuser();
    id_fanbase=widget.idfanbase;
    getfanbase();

    super.initState();
  }
  getuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        username = prefs.getString("username");
        uidnow=prefs.getString("uid");
      });
    }
  }
  getmember(uid) async {
    uidmember=uid;
    _showDialog();
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
            chairman = data3[0]['chairman'];

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
  Future<bool> editstruktur(BuildContext context) async {

    var jsonResponse = null;
    final url = 'https://discoverkorea.site/apiuser/updatestruktur';
    final response = await http.post(url, body: {
      'uidmember': uidmember,
      'uidmemberlama':uidnow,
      'uidfanbase': id_fanbase,
    });
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        if (this.mounted) {
          setState(() {});
        }
      }
    } else {
      var snackbar = SnackBar(
        content: Text(response.body,
            style: TextStyle(color: Colors.white.withOpacity(0.8))),
        backgroundColor: Colors.black,
      );
    }
    print(response.body);
  }
  void _showDialog() {
    // flutter defined function

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Pergantian Ketua Fanbase"),
          content: new Text(
              "Apakah anda ingin memberikan ketua kepada member ini?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Iya, Ganti Ketua"),
              onPressed: () => editstruktur(context),

            ),
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
    int counter = 0;
    return Scaffold(

      body: SingleChildScrollView(
        child: Container(
          padding:  new EdgeInsets.only(top:50),
          height: MediaQuery.of(context).size.height * 0.5,
          // CustomHeading(
          //   title: 'Pesan',
          // ),
          child: FutureBuilder(
            future:
            Provider.of<ApiMengikuti>(context, listen: false).getFanbaseFollower(id_fanbase),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                // jika sudah ada data
                return Consumer<ApiMengikuti>(
                  builder: (context, data, _) {
                    return ListView.builder(
                      padding: EdgeInsets.all(0),
                      itemCount: data.dataMengikuti.length,
                      itemBuilder: (context, i) {
                        return Material(
                          child: InkWell(
                            onTap: () {
                              try {
                                if (chairman ==uidnow) {

                                  getmember(data.dataMengikuti[i].uid);
                                } else {
                                }
                              } catch (e) {
                                print('salah disini');
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withAlpha(50),
                                    offset: Offset(0, 0),
                                    blurRadius: 5,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      Container(
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage('https://discoverkorea.site/uploads/profile/'+data.dataMengikuti[i].profile_picture),
                                          minRadius: 35,
                                          backgroundColor: Colors.grey[200],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          data.dataMengikuti[i].username,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18.0,
                                              fontWeight:
                                              FontWeight.bold),
                                        ),
                                        // Padding(
                                        //   padding: EdgeInsets.only(top: 5),
                                        // ),
                                        // Text(
                                        //   data.dataUser[i].message,
                                        //   style: TextStyle(
                                        //     color: Color(0xff8C68EC),
                                        //     fontSize: 14,
                                        //   ),
                                        // ),
                                        // Padding(
                                        //   padding: EdgeInsets.only(top: 5),
                                        // ),
                                        // Text(
                                        //   data.dataUser[i].date,
                                        //   style: TextStyle(
                                        //     color: Colors.grey,
                                        //     fontSize: 12,
                                        //   ),
                                        // )
                                      ],
                                    ),
                                  ),

                                  Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(right: 15),
                                        child:  Text(
                                          data.dataMengikuti[i].role,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12.0,
                                              fontWeight:
                                              FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
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
                      Text('Tidak ada yang diikuti')
                    ],
                  ),
                );
              }
            },
          ),

        ),
      ),
    );
  }
}
