import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:discoverkorea/pages/chats.dart';
import 'package:discoverkorea/providers/api_unggahan.dart';
import 'package:provider/provider.dart';
import 'package:discoverkorea/otherprofiles.dart';
import 'package:discoverkorea/profiles2.dart';
import 'package:discoverkorea/comments.dart';
import 'package:discoverkorea/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

//
import 'package:discoverkorea/image_detailfeed.dart';
import 'dart:convert';

class BeerListPage extends StatefulWidget {
  BeerListPage({Key key}) : super(key: key);

  @override
  BeerListPageState1 createState() => BeerListPageState1();
}

int count = 1;
int jumlahpostnambah = 0;
int postmax = 0;

class BeerListPageState1 extends State<BeerListPage> {
  String username = "";
  String uidsender1 = "";
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    getuser();
  }

  getuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        username = prefs.getString("username");
        uidsender1 = prefs.getString("uid");
      });
    }
  }

  Future<void> likes(String idpost) async {
    var jsonResponse = null;
    final urlmessage = 'https://discoverkorea.site/apiuser/like';
    final response2 = await http.post(urlmessage, body: {
      'idpost': idpost,
      'uidprofile': uidsender1,
    });
    if (response2.statusCode == 200) {
      jsonResponse = json.decode(response2.body);
      if (jsonResponse != null) {
        if (this.mounted) {
          setState(() {});
        }
      }
    } else {
      var snackbar = SnackBar(
        content: Text(response2.body,
            style: TextStyle(color: Colors.white.withOpacity(0.8))),
        backgroundColor: Colors.black,
      );
    }
  }

  Future<void> bookmark(String idpost) async {
    var jsonResponse = null;
    final urlmessage = 'https://discoverkorea.site/apiuser/bookmark';
    final response2 = await http.post(urlmessage, body: {
      'idpost': idpost,
      'uidprofile': uidsender1,
    });
    if (response2.statusCode == 200) {
      jsonResponse = json.decode(response2.body);
      if (jsonResponse != null) {
        if (this.mounted) {
          setState(() {});
        }
      }
    } else {
      var snackbar = SnackBar(
        content: Text(response2.body,
            style: TextStyle(color: Colors.white.withOpacity(0.8))),
        backgroundColor: Colors.black,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              fit: BoxFit.contain,
              height: 25,
            ),
            Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Discover Korea',
                  style: new TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                )),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.messenger_outline_sharp),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Chats()),
                );
              }),
        ],
      ),
      body: RefreshIndicator(
          onRefresh: _refreshPage,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 90.0,
                  child: ListView(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Card(
                        child: Row(
                          children: <Widget>[
                            InkWell(
                              child: Container(
                                width: 70,
                                height: 70,
                                padding:
                                    const EdgeInsets.only(top: 90.0, right: 26),
                                alignment: Alignment.bottomRight,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/discoverkorea-budaya.png'),
                                      fit: BoxFit.cover),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    // Text(
                                    //   "Budaya",
                                    //   style: TextStyle(
                                    //       fontFamily: 'AirbnbCerealBold',
                                    //       fontSize: 15,
                                    //       fontWeight: FontWeight.bold,
                                    //       color: Colors.black),
                                    // ),
                                    // Text(
                                    //   "1,243 Place",
                                    //   style: TextStyle(
                                    //       fontFamily: 'AirbnbCerealBook',
                                    //       fontSize: 19,
                                    //       color: Colors.black),
                                    // ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                print("Tapped on container");
                              },
                            ),
                          ],
                        ),
                      ),
                      Card(
                        child: Row(
                          children: <Widget>[
                            InkWell(
                              child: Container(
                                width: 70,
                                height: 70,
                                padding:
                                    const EdgeInsets.only(top: 90.0, right: 26),
                                alignment: Alignment.bottomRight,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/discoverkorea-kuliner.png'),
                                      fit: BoxFit.cover),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    // Text(
                                    //   "Kuliner",
                                    //   style: TextStyle(
                                    //       fontFamily: 'AirbnbCerealBold',
                                    //       fontSize: 15,
                                    //       fontWeight: FontWeight.bold,
                                    //       color: Colors.black),
                                    // ),
                                    // Text(
                                    //   "1,243 Place",
                                    //   style: TextStyle(
                                    //       fontFamily: 'AirbnbCerealBook',
                                    //       fontSize: 19,
                                    //       color: Colors.black),
                                    // ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                print("Tapped on container");
                              },
                            ),
                          ],
                        ),
                      ),
                      Card(
                        child: Row(
                          children: <Widget>[
                            InkWell(
                              child: Container(
                                width: 70,
                                height: 70,
                                padding:
                                    const EdgeInsets.only(top: 90.0, right: 26),
                                alignment: Alignment.bottomRight,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/discoverkorea-kpop.png'),
                                      fit: BoxFit.cover),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    // Text(
                                    //   "",
                                    //   style: TextStyle(
                                    //       fontFamily: 'AirbnbCerealBold',
                                    //       fontSize: 15,
                                    //       fontWeight: FontWeight.bold,
                                    //       color: Colors.black),
                                    // ),
                                    // Text(
                                    //   "1,243 Place",
                                    //   style: TextStyle(
                                    //       fontFamily: 'AirbnbCerealBook',
                                    //       fontSize: 19,
                                    //       color: Colors.black),
                                    // ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                print("Tapped on container");
                              },
                            ),
                          ],
                        ),
                      ),
                      Card(
                        child: Row(
                          children: <Widget>[
                            InkWell(
                              child: Container(
                                width: 70,
                                height: 70,
                                padding:
                                    const EdgeInsets.only(top: 90.0, right: 16),
                                alignment: Alignment.bottomRight,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/discoverkorea-teknologi.png'),
                                      fit: BoxFit.cover),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    // Text(
                                    //   "Teknologi",
                                    //   style: TextStyle(
                                    //       fontFamily: 'AirbnbCerealBold',
                                    //       fontSize: 15,
                                    //       fontWeight: FontWeight.bold,
                                    //       color: Colors.black),
                                    // ),
                                    // Text(
                                    //   "1,243 Place",
                                    //   style: TextStyle(
                                    //       fontFamily: 'AirbnbCerealBook',
                                    //       fontSize: 19,
                                    //       color: Colors.black),
                                    // ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                print("Tapped on container");
                              },
                            ),
                          ],
                        ),
                      ),
                      Card(
                        child: Row(
                          children: <Widget>[
                            InkWell(
                              child: Container(
                                width: 70,
                                height: 70,
                                padding:
                                    const EdgeInsets.only(top: 90.0, right: 26),
                                alignment: Alignment.bottomRight,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/discoverkorea-politik.png'),
                                      fit: BoxFit.cover),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    // Text(
                                    //   "Politik",
                                    //   style: TextStyle(
                                    //       fontFamily: 'AirbnbCerealBold',
                                    //       fontSize: 15,
                                    //       fontWeight: FontWeight.bold,
                                    //       color: Colors.black),
                                    // ),
                                    // Text(
                                    //   "1,243 Place",
                                    //   style: TextStyle(
                                    //       fontFamily: 'AirbnbCerealBook',
                                    //       fontSize: 19,
                                    //       color: Colors.black),
                                    // ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                print("Tapped on container");
                              },
                            ),
                          ],
                        ),
                      ),
                      Card(
                        child: Row(
                          children: <Widget>[
                            InkWell(
                              child: Container(
                                width: 70,
                                height: 70,
                                padding:
                                    const EdgeInsets.only(top: 90.0, right: 26),
                                alignment: Alignment.bottomRight,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/discoverkorea-sejarah.png'),
                                      fit: BoxFit.cover),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    // Text(
                                    //   "Sejarah",
                                    //   style: TextStyle(
                                    //       fontFamily: 'AirbnbCerealBold',
                                    //       fontSize: 15,
                                    //       fontWeight: FontWeight.bold,
                                    //       color: Colors.black),
                                    // ),
                                    // Text(
                                    //   "1,243 Place",
                                    //   style: TextStyle(
                                    //       fontFamily: 'AirbnbCerealBook',
                                    //       fontSize: 19,
                                    //       color: Colors.black),
                                    // ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                print("Tapped on container");
                              },
                            ),
                          ],
                        ),
                      ),
                      Card(
                        child: Row(
                          children: <Widget>[
                            InkWell(
                              child: Container(
                                width: 70,
                                height: 70,
                                padding:
                                    const EdgeInsets.only(top: 90.0, right: 17),
                                alignment: Alignment.bottomRight,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/discoverkorea-pendidikan.png'),
                                      fit: BoxFit.cover),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    // Text(
                                    //   "Pendidikan",
                                    //   style: TextStyle(
                                    //       fontFamily: 'AirbnbCerealBold',
                                    //       fontSize: 15,
                                    //       fontWeight: FontWeight.bold,
                                    //       color: Colors.white),
                                    // ),
                                    // Text(
                                    //   "1,243 Place",
                                    //   style: TextStyle(
                                    //       fontFamily: 'AirbnbCerealBook',
                                    //       fontSize: 19,
                                    //       color: Colors.black),
                                    // ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                print("Tapped on container");
                              },
                            ),
                          ],
                        ),
                      ),
                      Card(
                        child: Row(
                          children: <Widget>[
                            InkWell(
                              child: Container(
                                width: 70,
                                height: 70,
                                padding:
                                    const EdgeInsets.only(top: 90.0, right: 17),
                                alignment: Alignment.bottomRight,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/discoverkorea-kesehatan.png'),
                                      fit: BoxFit.cover),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    // Text(
                                    //   "Kesehatan",
                                    //   style: TextStyle(
                                    //       fontFamily: 'AirbnbCerealBold',
                                    //       fontSize: 15,
                                    //       fontWeight: FontWeight.bold,
                                    //       color: Colors.black),
                                    // ),
                                    // Text(
                                    //   "1,243 Place",
                                    //   style: TextStyle(
                                    //       fontFamily: 'AirbnbCerealBook',
                                    //       fontSize: 19,
                                    //       color: Colors.black),
                                    // ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                print("Tapped on container");
                              },
                            ),
                          ],
                        ),
                      ),
                      Card(
                        child: Row(
                          children: <Widget>[
                            InkWell(
                              child: Container(
                                width: 70,
                                height: 70,
                                padding:
                                    const EdgeInsets.only(top: 90.0, right: 19),
                                alignment: Alignment.bottomRight,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/discoverkorea-olahraga.png'),
                                      fit: BoxFit.cover),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    // Text(
                                    //   "Olahraga",
                                    //   style: TextStyle(
                                    //       fontFamily: 'AirbnbCerealBold',
                                    //       fontSize: 15,
                                    //       fontWeight: FontWeight.bold,
                                    //       color: Colors.black),
                                    // ),
                                    // Text(
                                    //   "1,243 Place",
                                    //   style: TextStyle(
                                    //       fontFamily: 'AirbnbCerealBook',
                                    //       fontSize: 19,
                                    //       color: Colors.black),
                                    // ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                print("Tapped on container");
                              },
                            ),
                          ],
                        ),
                      ),
                      Card(
                        child: Row(
                          children: <Widget>[
                            InkWell(
                              child: Container(
                                width: 70,
                                height: 70,
                                padding:
                                    const EdgeInsets.only(top: 90.0, right: 26),
                                alignment: Alignment.bottomRight,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/discoverkorea-pariwisata.png'),
                                      fit: BoxFit.cover),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "Wisata",
                                      style: TextStyle(
                                          fontFamily: 'AirbnbCerealBold',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    // Text(
                                    //   "1,243 Place",
                                    //   style: TextStyle(
                                    //       fontFamily: 'AirbnbCerealBook',
                                    //       fontSize: 19,
                                    //       color: Colors.black),
                                    // ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                print("Tapped on container");
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.67,
                  margin: EdgeInsets.only(bottom: 100),
                  padding: EdgeInsets.only(bottom: 0),
                  child: FutureBuilder(
                    future: Provider.of<ApiUnggahan>(context, listen: false)
                        .getPost(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasData) {
                        return Consumer<ApiUnggahan>(
                          builder: (context, data, _) {
                            postmax = data.dataPostFollowing.length;
                            return ListView.builder(
                              padding: EdgeInsets.all(0),
                              itemCount: data.dataPostFollowing.length,
                              itemBuilder: (context, i) {
                                bool liked = false;
                                bool bookmarked = false;
                                if (data.dataPostFollowing[i].liked == 1) {
                                  liked = true;
                                }
                                if (data.dataPostFollowing[i].bookmarks == 1) {
                                  bookmarked = true;
                                }
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ImageDetailFeed(
                                                id: data
                                                    .dataPostFollowing[i].id,
                                              )),
                                    ).then((value) => setState(() {}));
                                  },
                                  child: Card(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    color: Colors.white,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        new Container(
                                          padding: const EdgeInsets.all(0.0),
                                          margin: const EdgeInsets.all(0.0),
                                          child: Image.network(
                                              'https://discoverkorea.site/uploads/file/' +
                                                  data.dataPostFollowing[i]
                                                      .file),
                                        ),
                                        new Container(
                                          margin: const EdgeInsets.only(
                                              bottom: 21.0),
                                          padding: const EdgeInsets.only(
                                              left: 10.0, top: 6),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: new Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    liked
                                                        ? Column(
                                                            children: [
                                                              IconButton(
                                                                icon: Icon(Icons
                                                                    .favorite),
                                                                onPressed: () =>
                                                                    likes(data
                                                                        .dataPostFollowing[
                                                                            i]
                                                                        .id),
                                                                color: Colors
                                                                    .redAccent,
                                                                tooltip:
                                                                    'Unggah berita',
                                                              ),
                                                              Text(
                                                                data
                                                                    .dataPostFollowing[
                                                                i]
                                                                    .likes
                                                                    .toString()+" likes",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          )
                                                        : Column(
                                                            children: [
                                                              IconButton(
                                                                icon: Icon(Icons
                                                                    .favorite_border),
                                                                onPressed: () =>
                                                                    likes(data
                                                                        .dataPostFollowing[
                                                                            i]
                                                                        .id),
                                                                color: Colors
                                                                    .black,
                                                                tooltip:
                                                                    'Unggah berita',
                                                              ),
                                                              Text(
                                                                data
                                                                    .dataPostFollowing[
                                                                        i]
                                                                    .likes
                                                                    .toString()+" likes",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ),
                                                    new IconButton(
                                                      icon: Icon(Icons
                                                          .chat_bubble_outline),
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      Comments(idpost:data.dataPostFollowing[
                                                                          i]
                                                                          .id,user:data.dataPostFollowing[i]
                                                                          .username)),
                                                        );
                                                      },
                                                      color: Colors.black,
                                                      tooltip: 'Unggah berita',
                                                    ),
                                                    bookmarked
                                                        ? new IconButton(
                                                            icon: Icon(
                                                                Icons.bookmark),
                                                            onPressed: () =>
                                                                bookmark(data
                                                                    .dataPostFollowing[
                                                                        i]
                                                                    .id),
                                                            color: Colors.black,
                                                            tooltip:
                                                                'Pilih dari galeri',
                                                          )
                                                        : new IconButton(
                                                            icon: Icon(Icons
                                                                .bookmark_border),
                                                            onPressed: () =>
                                                                bookmark(data
                                                                    .dataPostFollowing[
                                                                        i]
                                                                    .id),
                                                            color: Colors.black,
                                                            tooltip:
                                                                'Pilih dari galeri',
                                                          ),
                                                  ],
                                                ),
                                              ),
                                              new GestureDetector(
                                                onTap: () {
                                                  //print('sentuh');
                                                  try {
                                                    if (username ==
                                                        data
                                                            .dataPostFollowing[
                                                                i]
                                                            .username) {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProfileApp2(),
                                                        ),
                                                      );
                                                    } else if (username !=
                                                        data
                                                            .dataPostFollowing[
                                                                i]
                                                            .username) {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              OtherProfileApp(
                                                            username: data
                                                                .dataPostFollowing[
                                                                    i]
                                                                .username,
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  } catch (e) {
                                                    print('salah disini');
                                                  }
                                                },
                                                child: Text(
                                                  data.dataPostFollowing[i]
                                                      .username,
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(data
                                                    .dataPostFollowing[i]
                                                    .title),
                                              ),
                                              Text(
                                                data.dataPostFollowing[i]
                                                    .created_at,
                                                style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.5)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
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
                              Text('Tidak ada Unggahan dari Idolmu')
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Future<void> _refreshPage() async {
    setState(() {
      if (jumlahpostnambah + 5 <= postmax) {
        jumlahpostnambah += 5;
      }
      Provider.of<ApiUnggahan>(context, listen: false).getPost();
    });
  }

  ///
  ///
}
