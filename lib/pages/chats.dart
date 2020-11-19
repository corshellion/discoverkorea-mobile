import 'package:discoverkorea/fanbase.dart';
import 'package:discoverkorea/autocomplete.dart';
import 'package:discoverkorea/providers/api_fanbase.dart';
import 'package:discoverkorea/utilities/custom_heading.dart';
import 'package:discoverkorea/grup/detailgroup.dart';
import 'package:discoverkorea/grup/searchfanbase.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:discoverkorea/providers/api_chat.dart';
import 'package:discoverkorea/home_page.dart';
import 'chat_details.dart';
import 'package:provider/provider.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  String sender1 = "";
  String receiver1 = "";
  String uidreceiver1;
  String uidsender1 = "";
  String username = "";
  List data3;
  String idroom = "";
  SharedPreferences sharedPreferences;

  void initState() {
    Provider.of<ApiChat>(context, listen: false).getRoom();
    super.initState();
    setState(() {
      getFromSharedPreferences();
    });
  }

//GET USER LOGIN
  void getFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
      // check whether the state object is in tree
      setState(() {
        username = prefs.getString("username");
        uidsender1 = prefs.getString("uid");
        print(username);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int counter = 0;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.4,
        backgroundColor: Colors.white,
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
                      MaterialPageRoute(builder: (context) => HomePage()),
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Riwayat Pesan',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                )
              ],
            )
          ],
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Fanbase(),
                ),
              );
            },
            child: Text('Buat Fanbase'),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CustomHeading(
              title: 'Fanbase',
            ),
            Row(
              children: <Widget>[
                Text(
                  "",
                  style: TextStyle(fontSize: 20),
                ),
                Spacer(),
                FlatButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchFanbase(),
                      ),
                    );
                  },
                  child: Text(
                    "Cari Fanbase >",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
            Container(
              height: 150,
              child: FutureBuilder(
                future: Provider.of<ApiFanbase>(context, listen: false)
                    .getAllFanbase(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    // jika sudah ada data
                    return Consumer<ApiFanbase>(
                      builder: (context, data, _) {
                        return ListView.builder(
                          itemCount: data.dataFanbase.length ?? null,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.all(15),
                          itemBuilder: (BuildContext context, int i) {
                            counter++;
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                color: Colors.transparent,
                                child: Column(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => DetailGrup(
                                                    idfan:
                                                        data.dataFanbase[i].uid,
                                                    groupname: data
                                                        .dataFanbase[i]
                                                        .group_name,
                                                    description: data
                                                        .dataFanbase[i]
                                                        .description,
                                                    chairman: data
                                                        .dataFanbase[i]
                                                        .chairman,
                                                  )),
                                        );
                                      }, // handle your onTap here
                                      child: Container(
                                        width: 90,
                                        height: 90,
                                        margin: EdgeInsets.only(right: 15),
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            'https://discoverkorea.site/uploads/profile_fanbase/'+data.dataFanbase[i].photo,
                                          ),
                                          radius: 50.0,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child:
                                          Text(data.dataFanbase[i].group_name),
                                    )
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
                          Text('Tidak ada Fanbase')
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
            CustomHeading(
              title: 'Pesan',
            ),
            FutureBuilder(
              future: Provider.of<ApiChat>(context, listen: false).getRoom(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData) {
                  // jika sudah ada data
                  return Consumer<ApiChat>(
                    builder: (context, data, _) {
                      return ListView.builder(
                        itemCount: data.dataRoom.length ?? null,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int i) {
                          return Material(
                            child: InkWell(
                              onTap: () async {
                                setState(() {
                                  if (data.dataRoom[i].username != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatDetails(
                                          username: username ?? null,
                                          receiver:
                                              data.dataRoom[i].username ?? null,
                                          uidreceiverpas:
                                              data.dataRoom[i].uid ?? null,
                                        ),
                                      ),
                                    ).then((value) => setState(() {}));
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Chats(),
                                      ),
                                    ).then((value) => setState(() {}));
                                  }
                                });
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
                                                    data.dataRoom[i]
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
                                            data.dataRoom[i].username,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 5),
                                          ),
                                          Text(
                                            'Detail Pesan',
                                            style: TextStyle(
                                              color: Color(0xff8f7f85),
                                              fontSize: 14,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 5),
                                          ),
                                          Text(
                                            '11:00 AM',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          )
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
                                        )
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
                        Text('Tidak ada Pesan')
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
