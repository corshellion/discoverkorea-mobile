import 'package:discoverkorea/models/model_fanbase.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiFanbase extends ChangeNotifier {
  List<FanbaseModel> _data = [];
  List<FanbaseModel> get dataFanbase => _data;
  List<FanbaseModel> _data2 = [];
  List<FanbaseModel> get dataFanbase2 => _data2;
  List<FanbaseModel> _data3 = [];
  List<FanbaseModel> get dataFanbase3 => _data3;
  SharedPreferences sharedPreferences;
  String username = "unknown";
  String uid = "";

  ApiFanbase() {
    notifyListeners();
    setup();
  }

  void setup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = (await prefs.getString('username') ?? 'unknown');
    String url2 = await prefs.getString('uid');
    username = url;
    uid = url2;
    notifyListeners();
  }

  Future<List<FanbaseModel>> getFanbase() async {
    final url = 'https://discoverkorea.site/getkfanbase';
    final response = await http.get(url);
    if (response.body.isNotEmpty) {
      print('masuk sini pak e ' + username);
      if (response.statusCode == 200) {
        final result =
            json.decode(response.body)['values'].cast<Map<String, dynamic>>();
        _data3 = result
            .map<FanbaseModel>((json) => FanbaseModel.fromJson(json))
            .toList();
        return _data3;
      } else {
        // throw Exception();
      }
    } else {
      print('Terjadi disini kesalahannya');
    }
  }

  // FOLLOW  FANBASE
  Future<bool> followFanbase(String idpengikut, String idfanbase) async {
    final url = 'https://discoverkorea.site/apiuser/followfanbase';
    final response = await http.post(url, body: {
      'idpengikut': idpengikut,
      'idfanbase': idfanbase,
    });

    final result = json.decode(response.body);
    if (response.statusCode == 200 && result['message'] == 'Success!') {
      notifyListeners();
      return true;
    }
    return false;
  }

  // unFOLLOW  FANBASE
  Future<bool> unfollowFanbase(String idpengikut, String idfanbase) async {
    final url = 'https://discoverkorea.site/apiuser/unfollowfanbase';
    final response = await http.post(url, body: {
      'idmember': idpengikut,
      'idfanbase': idfanbase,
    });

    final result = json.decode(response.body);
    if (response.statusCode == 200 && result['message'] == 'Success!') {
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<List<FanbaseModel>> getAllKategori() async {
    final url = 'https://discoverkorea.site/getkategori';
    final response = await http.get(url);
    if (response.body.isNotEmpty) {
      if (response.statusCode == 200) {
        final result =
            json.decode(response.body)['values'].cast<Map<String, dynamic>>();
        _data2 = result
            .map<FanbaseModel>((json) => FanbaseModel.fromJson(json))
            .toList();
        return _data2;
      } else {}
    } else {
      print('Terjadi disini kesalahannya');
    }
  }

  Future<List<FanbaseModel>> getAllFanbase() async {
    final url = 'https://discoverkorea.site/apiuser/fanbase/$uid';
    final response = await http.get(url);
    if (response.body.isNotEmpty) {
      if (response.statusCode == 200) {
        final result =
            json.decode(response.body)['values'].cast<Map<String, dynamic>>();
        _data = result
            .map<FanbaseModel>((json) => FanbaseModel.fromJson(json))
            .toList();
        return _data;
      } else {}
    } else {
      print('Terjadi disini kesalahannya');
    }
  }

  Future<List<FanbaseModel>> getChat(String idfangrup) async {
    final url = 'https://discoverkorea.site/apiuser/getfanbasechat/$idfangrup';
    final response = await http.get(url);
    if (response.body.isNotEmpty) {
      if (response.statusCode == 200) {
        final result =
            json.decode(response.body)['values'].cast<Map<String, dynamic>>();
        _data = result
            .map<FanbaseModel>((json) => FanbaseModel.fromJson(json))
            .toList();
        return _data;
      } else {}
    } else {
      print('Terjadi disini kesalahannya');
    }
  }


}
