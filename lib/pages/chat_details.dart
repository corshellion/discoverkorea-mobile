import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:discoverkorea/otherprofiles.dart';
import 'package:discoverkorea/providers/api_chat.dart';
import 'package:provider/provider.dart';
import 'package:discoverkorea/pages/chats.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatDetails extends StatefulWidget {
  final String username;
  final String receiver;
  final String uidreceiverpas;

  ChatDetails({this.username, this.receiver, this.uidreceiverpas});

  @override
  _ChatDetailsState createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {
  String usernamesender = "";
  String usernamereceiver = "";
  String uidreceiver1;
  String uidsender1 = "";
  String photoprofile='';
  List data3;
  String idroom = "";
  bool checkedvalue = false;
  SharedPreferences sharedPreferences;
  final TextEditingController _chat = TextEditingController();
  Timer timer;
  void initState() {
    Provider.of<ApiChat>(context, listen: false)
        .getChat(idroom);
    super.initState();
    if (this.mounted) {
      setState(() {
        getuser();
        getmessage();
        usernamesender = widget.username;
        usernamereceiver = widget.receiver;
        uidreceiver1 = widget.uidreceiverpas;
        print('Username Receiver adalah $usernamereceiver dan uid receiver $uidreceiver1 dan username adalah $usernamesender');
        Timer timer;
        timer = Timer.periodic(Duration(seconds: 5), (Timer t) => getmessage());
      });
    }
  }

  getuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        uidsender1 = prefs.getString("uid");
      });
    }
    var jsonResponse = null;
    var response =
    await http.get("https://discoverkorea.site/apiuser/$usernamereceiver");
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
    photoprofile = 'https://discoverkorea.site/uploads/profile/' +
        data3[0]['profile_picture'];
    print('profil url ' + '$photoprofile');
  }

  getroommessage() async {
    setState(() {
      Provider.of<ApiChat>(context, listen: false).getChat(idroom);
    });
  }

  getmessage() async {
    if (checkedvalue == false) {
      var jsonResponse = null;
      final url = 'https://discoverkorea.site/apiuser/pesan';
      final response = await http.post(url, body: {
        'user1': uidsender1,
        'user2': uidreceiver1,
      });
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
              idroom = data3[0]['id_room'];
              print(response.body);
             // print("Data foto profil chat"+data3[0]['profile_picture']);
              print('id room >>>' + idroom);
              getroommessage();
            });
          }
        }
      } else {
        print('salah >>>');
        // print(response.body);
      }
    }
  }

  Future<void> postmessage(BuildContext context) async {
    var jsonResponse = null;
    final urlmessage = 'https://discoverkorea.site/apiuser/kirimpesan';
    final response2 = await http.post(urlmessage, body: {
      'message': _chat.text,
      'uidsender': uidsender1,
      'idroom': idroom,
    });
    if (response2.statusCode == 200) {
      _chat.text = '';
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
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.4,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Row(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: const EdgeInsets.only(right: 20),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Chats()),
                      );
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: 25,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Container(
                width: 40,
                height: 40,
                margin: EdgeInsets.fromLTRB(0, 5, 10, 0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage('$photoprofile'),
                  backgroundColor: Colors.grey[200],
                  minRadius: 30,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "$usernamereceiver",
                    style: TextStyle(color: Colors.black,fontSize: 15),
                  ),
                  Text(
                    'Online Now',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                  )
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.095,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Tooltip(
                    waitDuration: Duration(seconds: 1),
                    showDuration: Duration(seconds: 2),
                    padding: EdgeInsets.all(5),
                    preferBelow: true,
                    margin: EdgeInsets.all(5),
                    height: 10,
                    textStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.normal),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blueGrey),
                    message:
                        "Berfungsi untuk melihat riwayat pesan sebelumnya.",
                    child: Icon(
                      Icons.info,
                      size: 10,
                      color: Colors.black,
                    ),
                  ),
                  Text("Matikan Auto Reload",
                      style: TextStyle(color: Colors.black, fontSize: 12)),
                  Checkbox(
                    value: checkedvalue,
                    onChanged: (bool value) {
                      setState(() {
                        if (checkedvalue == false) {
                          checkedvalue = true;
                        } else {
                          checkedvalue = false;
                        }
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Flexible(
                    child: FutureBuilder(
                      future: Provider.of<ApiChat>(context, listen: false)
                          .getChat(idroom),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: Text('Memperbarui data..')
                              //child: CircularProgressIndicator(),
                              );
                        }
                        if (snapshot.hasData) {
                          return Consumer<ApiChat>(
                            builder: (context, data, _) {
                              return ListView.builder(
                                itemCount: data.dataChat.length ?? 0,
                                shrinkWrap: true,
                                reverse: true,
                                itemBuilder: (BuildContext context, int i) {
                                  if (data.dataChat[i].sender2 == uidsender1) {
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
                                            message: data.dataChat[i].message,
                                            username: data.dataChat[i].nama,
                                            gambarprofile: 'https://discoverkorea.site/uploads/profile/'+data.dataChat[i].profile_picture,
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
                                  if (data.dataChat[i].sender2 != uidsender1) {
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
                                            message: data.dataChat[i].message,
                                            username: data.dataChat[i].nama,
                                            gambarprofile: 'https://discoverkorea.site/uploads/profile/'+data.dataChat[i].profile_picture,
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
                      onPressed: () => postmessage(context),
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
