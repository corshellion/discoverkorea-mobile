import 'dart:async';

import 'package:flutter/material.dart';
import 'package:discoverkorea/grup/detailgroup.dart';
import 'package:discoverkorea/home_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:discoverkorea/providers/api_comments.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Comments extends StatefulWidget {
  final String idpost;
  final String user;
  Comments({this.idpost,this.user});

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  String usernamesender = "";
  String usernamereceiver = "";
  String uidreceiver1;
  String uidsender1 = "";
  String photoprofile = '';
  String namafanbase = "";
  String description = "";
  String chairman = "";
  String idroom = "";
  String username = "";
  String usernamepost="";
  List data3;
  final snackbarKey = GlobalKey<ScaffoldState>();
  final TextEditingController _chat = TextEditingController();
  String idpost = "";

  bool checkedvalue = false;

  void initState() {
    super.initState();
    if (this.mounted) {
      setState(() {
        idpost = widget.idpost;
        usernamepost = widget.user;
        getuser();
      });
    }
  }

  getuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        uidsender1 = prefs.getString("uid");
        username = prefs.getString("username");
      });
    }
  }

  Future<void> kirimpesan(BuildContext context) async {
    var jsonResponse = null;
    final urlmessage = 'https://discoverkorea.site/apiuser/kirimcomment';
    final response = await http.post(urlmessage, body: {
      'message': _chat.text,
      'uidsender': uidsender1,
      'idpost': idpost,
    });
    if (response.statusCode == 200) {
      _chat.text = '';
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
  }

  Future<void> laporkanpost(BuildContext context) async {
    var jsonResponse = null;
    final urlmessage = 'https://discoverkorea.site/apiuser/laporpost';
    final response = await http.post(urlmessage, body: {
      'idpost': idpost,
      'user': username,
    });
    if (response.statusCode == 200) {
      _chat.text = '';
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        if (this.mounted) {
          setState(() {
            Navigator.of(context).pop();
          });
        }
      }
    } else {
      var snackbar = SnackBar(
        content: Text(response.body,
            style: TextStyle(color: Colors.white.withOpacity(0.8))),
        backgroundColor: Colors.black,
      );
    }
  }
  Future<void> laporkanpengguna(BuildContext context) async {
    var jsonResponse = null;
    final urlmessage = 'https://discoverkorea.site/apiuser/laporpengguna';
    final response = await http.post(urlmessage, body: {
      'user1': usernamepost,
      'user2': username,
    });
    if (response.statusCode == 200) {
      _chat.text = '';
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        if (this.mounted) {
          setState(() {
            Navigator.of(context).pop();
          });
        }
      }
    } else {
      var snackbar = SnackBar(
        content: Text(response.body,
            style: TextStyle(color: Colors.white.withOpacity(0.8))),
        backgroundColor: Colors.black,
      );
    }
  }
  void _showDialog2() {
    // flutter defined function

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Laporkan"),
          content: new Text(
              "Apakah anda ingin melaporkan pengguna atau unggahan ini?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Laporkan Pengguna"),
              onPressed: () => laporkanpengguna(context),
            ),
            new FlatButton(
              child: new Text("Laporkan Unggahan"),
              onPressed: () => laporkanpost(context),
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
      appBar: AppBar(
        elevation: 0.4,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Row(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Komentar',
                  style: TextStyle(color: Colors.black),
                ),
                Text(
                  'Mulai berkomentar',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                )
              ],
            ),
            Align(
              alignment: FractionalOffset(-1, 1.5),
              child: FlatButton(
                onPressed: () {
                  _showDialog2();
                },
                child: Icon(
                  Icons.report,
                  size: 25,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          // IconButton(
          //     icon: Icon(Icons.home),
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => HomePage()),
          //       );
          //     }),
          // IconButton(
          //     icon: Icon(Icons.group),
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => DetailGrup( idfan: idpost,
          //           groupname: namafanbase,
          //           description: description,
          //           chairman: chairman,)),
          //       );
          //     }),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Flexible(
                  child: FutureBuilder(
                    future: Provider.of<ApiComments>(context, listen: false)
                        .getComment(idpost),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: Text('Memperbarui data..')
                            //child: CircularProgressIndicator(),
                            );
                      }
                      if (snapshot.hasData) {
                        return Consumer<ApiComments>(
                          builder: (context, data, _) {
                            return ListView.builder(
                              itemCount: data.dataComment.length ?? 0,
                              shrinkWrap: true,
                              reverse: true,
                              // ignore: missing_return
                              itemBuilder: (BuildContext context, int i) {
                                if (data.dataComment[i].sender == uidsender1) {
                                  return Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      children: <Widget>[
                                        // Text(
                                        //   'Today',
                                        //   style:
                                        //   TextStyle(color: Colors.grey, fontSize: 12),
                                        // ),
                                        Bubble(
                                          message: data.dataComment[i].message,
                                          username:
                                              data.dataComment[i].username,
                                          gambarprofile:
                                              'https://discoverkorea.site/uploads/profile/' +
                                                  data.dataComment[i]
                                                      .profile_picture,
                                          isMe: true,
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                if (data.dataComment[i].sender != uidsender1) {
                                  return Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      children: <Widget>[
                                        // Text(
                                        //   'Today',
                                        //   style:
                                        //   TextStyle(color: Colors.grey, fontSize: 12),
                                        // ),
                                        Bubble(
                                          message: data.dataComment[i].message,
                                          username:
                                              data.dataComment[i].username,
                                          gambarprofile:
                                              'https://discoverkorea.site/uploads/profile/' +
                                                  data.dataComment[i]
                                                      .profile_picture,
                                          isMe: false,
                                        ),
                                      ],
                                    ),
                                  );
                                }
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
                              Text('Mulai Komentar')
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 70.0,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.grey[300],
                  offset: Offset(-2, 0),
                  blurRadius: 5,
                ),
              ]),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _chat,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Ketikan Komentar',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => kirimpesan(context),
                    icon: Icon(
                      Icons.send,
                      color: Color(0xff3E8DF3),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Bubble extends StatelessWidget {
  final bool isMe;
  final String message;
  final String username;
  final String gambarprofile;

  Bubble({this.message, this.username, this.gambarprofile, this.isMe});

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: isMe ? EdgeInsets.only(left: 40) : EdgeInsets.only(right: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  gradient: isMe
                      ? LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          stops: [
                              0.1,
                              1
                            ],
                          colors: [
                              Colors.blueGrey,
                              Colors.blueGrey,
                            ])
                      : LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          stops: [
                              0.1,
                              1
                            ],
                          colors: [
                              Colors.greenAccent,
                              Colors.greenAccent,
                            ]),
                  borderRadius: isMe
                      ? BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                          bottomRight: Radius.circular(0),
                          bottomLeft: Radius.circular(15),
                        )
                      : BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                          bottomLeft: Radius.circular(0),
                        ),
                ),
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      message,
                      textAlign: isMe ? TextAlign.end : TextAlign.start,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                      ),
                    )
                  ],
                ),
              ),
              Column(
                  mainAxisAlignment:
                      isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      username,
                      textAlign: isMe ? TextAlign.end : TextAlign.start,
                      style: TextStyle(
                          color: isMe ? Colors.black : Colors.black,
                          fontSize: 10),
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      margin: EdgeInsets.fromLTRB(0, 5, 10, 0),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(gambarprofile),
                        backgroundColor: Colors.grey[200],
                        minRadius: 30,
                      ),
                    ),
                  ]),
            ],
          )
        ],
      ),
    );
  }
}
