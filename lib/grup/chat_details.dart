import 'dart:async';

import 'package:flutter/material.dart';
import 'package:discoverkorea/grup/detailgroup.dart';
import 'package:discoverkorea/home_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:discoverkorea/providers/api_fanbase.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class GrupChatDetails extends StatefulWidget {
  final String idfanbase;

  GrupChatDetails({this.idfanbase});
  @override
  _ChatDetailsState createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<GrupChatDetails> {
  String usernamesender = "";
  String usernamereceiver = "";
  String uidreceiver1;
  String uidsender1 = "";
  String photoprofile='';
  String namafanbase="";
  String description="";
  String chairman="";
  String idroom="";
  List data3;
  final snackbarKey = GlobalKey<ScaffoldState>();
  final TextEditingController _chat = TextEditingController();
  String idfangrup="";

  bool checkedvalue = false;
  void initState() {
    super.initState();
    if (this.mounted) {
      setState(() {
        idfangrup = widget.idfanbase;
        getfanbase();
        getuser();
        // getroommessage();

        Timer timer;
        timer = Timer.periodic(Duration(seconds: 5), (Timer t) => getroommessage());
      });
    }
  }
  getfanbase() async {

    var jsonResponse = null;
    var response =
    await http.get("https://discoverkorea.site/apiuser/fanbase2/$idfangrup");
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
            namafanbase=data3[0]['group_name'];
            description=data3[0]['description'];
            chairman=data3[0]['chairman'];
            idroom=data3[0]['uid'];
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
  getuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        uidsender1 = prefs.getString("uid");
      });
    }
  }
  getroommessage() async {
    setState(() {
      Provider.of<ApiFanbase>(context, listen: false).getChat(idfangrup);
    });
  }
  Future<void> kirimpesan(BuildContext context) async {
    var jsonResponse = null;
    final urlmessage = 'https://discoverkorea.site/apiuser/kirimpesanfanbase';
    final response = await http.post(urlmessage, body: {
      'message': _chat.text,
      'uidsender': uidsender1,
      'idroom': idroom,
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
            Container(
              width: 40,
              height: 40,
              margin: EdgeInsets.fromLTRB(0, 5, 10, 0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(''),
                backgroundColor: Colors.grey[200],
                minRadius: 30,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '$namafanbase',
                  style: TextStyle(color: Colors.black),
                ),
                Text(
                  'Discover Now',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                )
              ],
            )
          ],
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              }),
          IconButton(
              icon: Icon(Icons.group),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetailGrup( idfan: idfangrup,
                    groupname: namafanbase,
                    description: description,
                    chairman: chairman,)),
                );
              }),
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
                    future: Provider.of<ApiFanbase>(context, listen: false)
                        .getChat(idfangrup),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: Text('Memperbarui data..')
                          //child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasData) {
                        return Consumer<ApiFanbase>(
                          builder: (context, data, _) {
                            return ListView.builder(
                              itemCount: data.dataFanbase.length ?? 0,
                              shrinkWrap: true,
                              reverse: true,
                              // ignore: missing_return
                              itemBuilder: (BuildContext context, int i) {
                                if (data.dataFanbase[i].sender ==uidsender1) {
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
                                          message: data.dataFanbase[i].message,
                                          username: data.dataFanbase[i].username,
                                          gambarprofile: 'https://discoverkorea.site/uploads/profile/'+data.dataFanbase[i].profile_picture,
                                          isMe: true,
                                        ),
                                        // Bubble(
                                        //   message: 'have you seen the docs yet?',
                                        //   isMe: true,
                                        // ),
                                        // Text(
                                        //   'Feb 25, 2018',
                                        //   style:
                                        //   TextStyle(color: Colors.grey, fontSize: 12),
                                        // ),
                                        // Bubble(
                                        //   message: 'i am fine !',
                                        //   isMe: false,
                                        // ),
                                        // Bubble(
                                        //   message: 'yes i\'ve seen the docs',
                                        //   isMe: false,
                                        // ),
                                      ],
                                    ),
                                  );
                                }
                                if (data.dataFanbase[i].sender !=uidsender1) {
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
                                          message: data.dataFanbase[i].message,
                                          username: data.dataFanbase[i].username,
                                          gambarprofile: 'https://discoverkorea.site/uploads/profile/'+data.dataFanbase[i].profile_picture,
                                          isMe: false,
                                        ),
                                        // Bubble(
                                        //   message: 'have you seen the docs yet?',
                                        //   isMe: true,
                                        // ),
                                        // Text(
                                        //   'Feb 25, 2018',
                                        //   style:
                                        //   TextStyle(color: Colors.grey, fontSize: 12),
                                        // ),
                                        // Bubble(
                                        //   message: 'i am fine !',
                                        //   isMe: false,
                                        // ),
                                        // Bubble(
                                        //   message: 'yes i\'ve seen the docs',
                                        //   isMe: false,
                                        // ),
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
                              Text('Mulai Chat')
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
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.camera,
                      color: Color(0xff3E8DF3),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.image,
                      color: Color(0xff3E8DF3),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _chat,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Ketikan Pesan',
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
  Bubble({this.message, this.username,this.gambarprofile, this.isMe});

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