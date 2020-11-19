import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:discoverkorea/providers/api_mengikuti.dart';
import 'package:provider/provider.dart';
import 'package:discoverkorea/otherprofiles.dart';
import 'package:discoverkorea/profiles2.dart';

class Follower extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Follower> {
  List data3;
  String uid = "";
  String username = "";

  @override
  void initState() {
    getuser();
    super.initState();
  }

  getuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        username = prefs.getString("username");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int counter = 0;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          // CustomHeading(
          //   title: 'Pesan',
          // ),
          child: FutureBuilder(
            future: Provider.of<ApiMengikuti>(context, listen: false)
                .getProfileFollower(),
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
                                if (username ==
                                    data.dataMengikuti[i]
                                        .username) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProfileApp2(),
                                    ),
                                  );
                                } else if (username !=
                                    data.dataMengikuti[i]
                                        .username) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          OtherProfileApp(
                                            username: data
                                                .dataMengikuti[i]
                                                .username,
                                          ),
                                    ),
                                  );
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
                                          backgroundImage: NetworkImage(
                                              'https://discoverkorea.site/uploads/profile/' +
                                                  data.dataMengikuti[i]
                                                      .profile_picture),
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
                                              fontWeight: FontWeight.bold),
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
                                        child: Icon(
                                          Icons.chevron_right,
                                          size: 18,
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
                      Text('Tidak ada yang mengikuti')
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
