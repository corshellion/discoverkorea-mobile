import 'package:discoverkorea/login_screen.dart';
import 'package:flutter/material.dart';

import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;
import 'package:dio/dio.dart';
import 'package:discoverkorea/grup/struktur.dart';
import 'package:discoverkorea/grup/informasigrup.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
class GrupSettings extends StatefulWidget {
  static final String path = "lib/src/pages/settings/settings1.dart";
  final String idfanbase;

  GrupSettings({this.idfanbase});
  @override
  _SettingsOnePageState createState() => _SettingsOnePageState();
}

class _SettingsOnePageState extends State<GrupSettings> {
  bool _dark;
  String idfangrup="";
  File imageFile;
  List data3;
  String namafanbase = "";
  String description = "";
  String chairman = "";
  String idroom = "";
  String photofanbase="";
  final snackbarKey = GlobalKey<ScaffoldState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    idfangrup=widget.idfanbase;
    getfanbase();
    _dark = false;
  }
  getfanbase() async {
    var jsonResponse = null;
    var response = await http
        .get("https://discoverkorea.site/apiuser/fanbase2/$idfangrup");
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
  Brightness _getBrightness() {
    return _dark ? Brightness.dark : Brightness.light;
  }
  Future<Response> sendForm(
      String url, Map<String, dynamic> data, Map<String, File> files) async {
    Map<String, MultipartFile> fileMap = {};
    for (MapEntry fileEntry in files.entries) {
      File file = fileEntry.value;
      String fileName = path.basename(file.path);
      fileMap[fileEntry.key] =
          MultipartFile(file.openRead(), await file.length(), filename: fileName);
    }
    data.addAll(fileMap);
    var formData = FormData.fromMap(data);
    Dio dio = new Dio();
    return await dio.post(url,
        data: formData, options: Options(contentType: 'multipart/form-data'));
  }
  Future<Response> sendFile(String url, File file) async {
    Dio dio = new Dio();
    var len = await file.length();
    var response = await dio.post(url,
        data: file.openRead(),
        options: Options(headers: {
          Headers.contentLengthHeader: len,
        } // set content-length
        ));
    return response;
  }
  _showSnackbar(String text) => scaffoldKey.currentState?.showSnackBar(
    new SnackBar(
      content: new Text(text),
    ),
  );
  _takePhoto() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);


    var image = imageFile;

    print('upload started');
    //upload image
    //scenario  one - upload image as poart of formdata
    var res1 = await sendForm('https://discoverkorea.site/apiuser/ubahfotofanbase',
        {'fanbase': idfangrup}, {'file': imageFile});
    print("res-1 $res1");
    setState(() {
      imageFile = image;
    });
    if (res1.statusCode == HttpStatus.OK||res1.statusCode == 200) {
      _showSnackbar('Unggahan berhasil!');
    } else {
      _showSnackbar('Unggahan Gagal, terjadi kesalahan!');
    }

  }
  @override
  Widget build(BuildContext context) {
    return Theme(
      isMaterialAppTheme: true,
      data: ThemeData(
        brightness: _getBrightness(),
      ),
      child: Scaffold(
        key: snackbarKey,
        backgroundColor: _dark ? null : Colors.grey.shade200,
        appBar: AppBar(
          elevation: 0,
          brightness: _getBrightness(),
          iconTheme: IconThemeData(color: _dark ? Colors.white : Colors.black),
          backgroundColor: Colors.transparent,
          title: Text(
            'Pengaturan Fanbase',
            style: TextStyle(color: _dark ? Colors.white : Colors.black),
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Card(
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    color: Color(0xffb31e63),
                    child: ListTile(
                      onTap: () {
                        //open edit profile
                      },
                      title: Text(
                        "$namafanbase",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      leading: CircleAvatar(
                         backgroundImage: NetworkImage('$photofanbase' ?? ''),
                      ),
                      trailing: new IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.red[200],
                        ),
                        onPressed: _takePhoto,
                        color: Colors.black,
                        tooltip: 'Unggah berita',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: Icon(
                            Icons.settings,
                            color: Color(0xffb31e63),
                          ),
                          title: Text("Ubah Struktur Anggota"),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Struktur(
                                      idfanbase: idfangrup)),
                            );
                          },
                        ),
                        _buildDivider(),
                        ListTile(
                          leading: Icon(
                            Icons.person,
                            color: Color(0xffb31e63),
                          ),
                          title: Text("Daftar Anggota Tertunda"),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Infogrup(
                                      idfanbase: idfangrup)),
                            );
                            //open change language
                          },
                        ),
                        _buildDivider(),
                        ListTile(
                          leading: Icon(
                            Icons.edit,
                            color: Color(0xffb31e63),
                          ),
                          title: Text("Ubah Informasi Grup"),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Infogrup(
                                      idfanbase: idfangrup)),
                            );
                            //open change language
                          },
                        ),

                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    "Pengaturan Penerimaan",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  SwitchListTile(
                    activeColor: Colors.purple,
                    contentPadding: const EdgeInsets.all(0),
                    value: true,
                    title: Text("Aktifkan Grup Tertutup"),
                    onChanged: (val) {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }
}
