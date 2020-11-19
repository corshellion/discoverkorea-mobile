import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:discoverkorea/providers/api_unggahan.dart';
import 'dart:async';
import 'package:discoverkorea/otherprofiles.dart';
import 'package:discoverkorea/profiles2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:discoverkorea/comments.dart';
import 'package:discoverkorea/models/model_unggahan.dart';
import 'dart:convert';

//
class ImageDetailFeed extends StatefulWidget {
  final String id;

  ImageDetailFeed({this.id});

  @override
  _DetailImageScreen createState() => _DetailImageScreen();
}

int count = 1;
int jumlahpostnambah = 0;
int postmax = 0;

class _DetailImageScreen extends State<ImageDetailFeed> {
  String id = "";
  String username = "";
  String usernameloginnow = "";
  String gambar = "";
  String title = "";
  String statuspost = "";
  String uidsender1 = "";
  String waktu = "";
  String intliked = "";
  String intbook = "";
  String intlikes = "";
  bool liked = false;
  bool bookmarked = false;
  SharedPreferences sharedPreferences;
  List<EmployeeModel> _dataPost = [];

  void initState() {
    id = widget.id;
    super.initState();
    getFromSharedPreferences();
    getdataspecified();
    Future.delayed(Duration.zero, () {
      Provider.of<ApiUnggahan>(context, listen: false)
          .getdetailprofileimage2(widget.id)
          .then((response) {
        setState(() {
          print(response);
          // print("ini like dari tabel"+response.likes.toString());
          getdataspecified();
          username = response.username;
          gambar = 'https://discoverkorea.site/uploads/file/' + response.file;
          title = response.title;
          statuspost = response.status;
          waktu = response.created_at;
          getFromSharedPreferences();
        });
        getdataspecified();
        // print("username" + username);
        // print("gambar" + gambar);
        // print("title" + title);
        // print("status" + status);
        // print("waktu" + waktu);
      });

    });

  }

  Future<List<EmployeeModel>> getdataspecified() async {
    final url = "https://discoverkorea.site/apiunggahdetail/$id/$uidsender1";
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final result =
          json.decode(response.body)['values'].cast<Map<String, dynamic>>();
      _dataPost = result
          .map<EmployeeModel>((json) => EmployeeModel.fromJson(json))
          .toList();
      if (this.mounted) {
        // check whether the state object is in tree
        setState(() {
          intbook = _dataPost[0].bookmarks.toString();
          intliked = _dataPost[0].liked.toString();
          intlikes = _dataPost[0].likes.toString();
          if (intliked == "1") {
            liked = true;
          } else {
            liked = false;
          }
          if (intbook == "1") {
            bookmarked = true;
          } else {
            bookmarked = false;
          }
        });
      }
      // return _datauser;

    } else {
      throw Exception();
    }
  }

//GET USER LOGIN
  void getFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
      // check whether the state object is in tree
      setState(() {
        usernameloginnow = prefs.getString("username");
        uidsender1 = prefs.getString("uid");
        print(username);
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
          setState(() {getdataspecified();});
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
          setState(() {getdataspecified();});
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
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          elevation: 0.4,
          backgroundColor: Colors.white,
          title: Text(
            'Detail ',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _refreshPage,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 2,
                  child: new Card(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          new Container(
                            height: MediaQuery.of(context).size.height * 0.67,
                            padding: const EdgeInsets.all(0.0),
                            margin: const EdgeInsets.all(0.0),
                            child:
                                Image.network(gambar, fit: BoxFit.cover ?? ''),
                          ),
                          new Container(
                              height: MediaQuery.of(context).size.height * 0.67,
                              margin: EdgeInsets.only(bottom: 100),
                              padding: EdgeInsets.only(bottom: 0),
                              child: InkWell(
                                onTap: () {},
                                child: Card(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      new Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 21.0),
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
                                                mainAxisSize: MainAxisSize.max,
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
                                                                  likes(id),
                                                              color: Colors
                                                                  .redAccent,
                                                              tooltip:
                                                                  'Unggah berita',
                                                            ),
                                                            Text(
                                                              intlikes +
                                                                  " likes",
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
                                                                  likes(id),
                                                              color:
                                                                  Colors.black,
                                                              tooltip:
                                                                  'Unggah berita',
                                                            ),
                                                            Text(
                                                              intlikes +
                                                                  " likes",
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
                                                            builder: (context) =>
                                                                Comments(
                                                                    idpost:
                                                                        id,user: username,)),
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
                                                              bookmark(id),
                                                          color: Colors.black,
                                                          tooltip:
                                                              'Pilih dari galeri',
                                                        )
                                                      : new IconButton(
                                                          icon: Icon(Icons
                                                              .bookmark_border),
                                                          onPressed: () =>
                                                              bookmark(id),
                                                          color: Colors.black,
                                                          tooltip:
                                                              'Pilih dari galeri',
                                                        ),
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                //print('sentuh');
                                                try {
                                                  if (usernameloginnow ==
                                                      username) {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProfileApp2(),
                                                      ),
                                                    );
                                                  } else if (usernameloginnow !=
                                                      username) {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            OtherProfileApp(
                                                          username: username,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                } catch (e) {
                                                  print('salah disini');
                                                }
                                              },
                                              child: Text(
                                                "$username",
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text("$title"),
                                            ),
                                            Text("Deskripsi"),
                                            Text(""),
                                            Text("$statuspost"),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        ],
                      )),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> _refreshPage() async {
    setState(() {
      Provider.of<ApiUnggahan>(context, listen: false)
          .getdetailprofileimage(widget.id);
    });
  }
}
