import 'dart:async';
import 'package:flutter/material.dart';
import 'package:discoverkorea/animation/FadeAnimation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:discoverkorea/grup/detailgroup.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Fanbase extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Fanbase> {
  final TextEditingController _namafanbase = TextEditingController();
  final TextEditingController _tag1 = TextEditingController();
  final TextEditingController _tag2 = TextEditingController();
  final TextEditingController _deskripsi = TextEditingController();
  String _mySelection;
  String id_fanbase = "";
  String groupname = "";
  String description = "";
  String chairman = "";
  String uidchairman = "";
  List data3;
  final snackbarKey = GlobalKey<ScaffoldState>();
  // //auto complete
  // static const JsonCodec JSON = const JsonCodec();
  //
  // final key = new GlobalKey<ScaffoldState>();
  // final TextEditingController _searchQueryController =
  // new TextEditingController();
  // final FocusNode _focusNode = new FocusNode();
  //
  // bool _isSearching = true;
  // String _searchText = "";
  // List<String> _searchList = List();
  // bool _onTap = false;
  // int _onTapTextLength = 0;
  //
  // _SuggestionsPageState() {
  //   _searchQueryController.addListener(() {
  //     if (_searchQueryController.text.isEmpty) {
  //       setState(() {
  //         _isSearching = false;
  //         _searchText = "";
  //         _searchList = List();
  //       });
  //     } else {
  //       setState(() {
  //         _isSearching = true;
  //         _searchText = _searchQueryController.text;
  //         _onTap = _onTapTextLength == _searchText.length;
  //       });
  //     }
  //   });
  // }
  // //

  final String url = "https://discoverkorea.site/getkategori";

  List data = List(); //edited line

  Future<String> getSWData() async {
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    setState(() {
      data = resBody['values'];
      print(data);
    });
  }
  //GET USER LOGIN
  void getFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
      // check whether the state object is in tree
      setState(() {
        uidchairman = prefs.getString("uid");
      });
    }
  }

  Future<void> submit(BuildContext context) async {
    Map data2 = {
      'group_name': _namafanbase.text,
      'category': _mySelection.toString(),
      'subkategori1': _tag1.text,
      'subkategori2': _tag2.text,
      'description': _deskripsi.text,
      'chairman': uidchairman,
    };
    var jsonResponse = null;
    var response = await http
        .post("https://discoverkorea.site/apiuser/createfanbase", body: data2);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse['message'] == 'Success!') {
        if (this.mounted) {
          setState(() {
            //RESPONSE YANG DIDAPATKAN DARI API TERSEBUT DI DECODE
            var content = json.decode(response.body);
            //KEMUDIAN DATANYA DISIMPAN KE DALAM VARIABLE data,
            //DIMANA SECARA SPESIFIK YANG INGIN KITA AMBIL ADALAH ISI DARI KEY hasil
            data3 = content['values'];
            id_fanbase = data3[0]['uid'];
            groupname = data3[0]['group_name'];
            description = data3[0]['description'];
            chairman = data3[0]['chairman'];
          });
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => DetailGrup(
                        idfan: id_fanbase,
                        groupname: groupname,
                        description: description,
                        chairman: chairman,
                      )),
              (Route<dynamic> route) => false);

        }
      }else
        {
          print(jsonResponse['message']);
          var snackbar = SnackBar(
            content: Text(jsonResponse['message'], style: TextStyle(color: Colors.white.withOpacity(0.8))),
            backgroundColor: Colors.black,
          );
          snackbarKey.currentState.showSnackBar(snackbar);
        }
    } else {
      //print('ini respon terakhir'+response.body);
      var snackbar = SnackBar(
        content: Text(response.body, style: TextStyle(color: Colors.white.withOpacity(0.8))),
        backgroundColor: Colors.black,
      );
      snackbarKey.currentState.showSnackBar(snackbar);
     print(response.body);
    }
  }

  @override
  void initState() {
    super.initState();
    this.getSWData();
    getFromSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: snackbarKey,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background3.png'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        child: FadeAnimation(
                            1.6,
                            Container(
                              margin: EdgeInsets.only(top: 50),
                              child: Center(
                                child: Text(
                                  "",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      FadeAnimation(
                          1.8,
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(143, 148, 251, .2),
                                      blurRadius: 20.0,
                                      offset: Offset(0, 10))
                                ]),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[100]))),
                                  child: TextField(
                                    controller: _namafanbase,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Nama Fanbase",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400])),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[100]))),
                                  child: TextField(
                                    controller: _deskripsi,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Deskripsi",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400])),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[100]))),
                                  child: DropdownButton(
                                    isExpanded: true,
                                    hint:
                                        Text("Silahkan Pilih Kategori Fanbase"),
                                    items: data.map((item) {
                                      return new DropdownMenuItem(
                                        child: new Text(item['namakategori']),
                                        value: item['namakategori'].toString(),
                                      );
                                    }).toList(),
                                    onChanged: (newVal) {
                                      setState(() {
                                        _mySelection = newVal;
                                      });
                                    },
                                    value: _mySelection,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: _tag1,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Tag 1",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400])),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: _tag2,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Tag 2",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400])),
                                  ),
                                )
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      FadeAnimation(
                        2,
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 0.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(30.0),
                            shadowColor: Colors.orangeAccent.shade100,
                            elevation: 8.0,
                            child: MaterialButton(
                              minWidth: 400.0,
                              height: 50.0,
                              onPressed: () => submit(context),
                              color: Color(0xffa8325c),
                              child: Text('Buat Fanbase',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

// import "package:flutter/material.dart";
// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// void main() => runApp(MaterialApp(
//   title: "Hospital Management",
//   home: Fanbase(),
// ));
//
// class Fanbase extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<Fanbase> {
//   String _mySelection;
//
//   final String url = "https://discoverkorea.site/getkategori";
//
//   List data = List(); //edited line
//
//   Future<String> getSWData() async {
//     var res = await http
//         .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
//     var resBody = json.decode(res.body);
//
//     setState(() {
//       data = resBody['values'];
//       print(data);
//     });
//
//
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     this.getSWData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       appBar: AppBar(
//         title: Text("Hospital Management"),
//       ),
//       body: new Center(
//         child: new DropdownButton(
//           items: data.map((item) {
//             return new DropdownMenuItem(
//               child: new Text(item['nama']),
//               value: item['id_kategori'].toString(),
//             );
//           }).toList(),
//           onChanged: (newVal) {
//             setState(() {
//               _mySelection = newVal;
//             });
//           },
//           value: _mySelection,
//         ),
//       ),
//     );
//   }
// }
