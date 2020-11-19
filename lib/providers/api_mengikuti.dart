import 'package:discoverkorea/models/model_mengikuti.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class ApiMengikuti extends ChangeNotifier {
  List<MengikutiModel> _data = [];
  List<MengikutiModel> get dataMengikuti => _data;
  SharedPreferences sharedPreferences;
  String uid = "";
  String uid2="";
  ApiMengikuti() {
    notifyListeners();
    setup();
  }

  void setup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url2 = await prefs.getString('uid');
    uid = url2;
    notifyListeners();
  }

  //mendapatkan info following
  Future<List<MengikutiModel>> getProfileFollowing() async {
    final url = 'https://discoverkorea.site/apiuser/following/$uid';
    final response = await http.get(url);
    if (response.body.isNotEmpty) {
      if (response.statusCode == 200) {
        print('uid following $uid');
        final result =
        json.decode(response.body)['values'].cast<Map<String, dynamic>>();
        _data = result
            .map<MengikutiModel>((json) => MengikutiModel.fromJson(json))
            .toList();
        return _data;
      } else {}
    } else {
      print('Terjadi disini kesalahannya');
    }
  }
  //mendapatkan info follower
  Future<List<MengikutiModel>> getProfileFollower() async {
    final url = 'https://discoverkorea.site/apiuser/follower/$uid';
    final response = await http.get(url);
    if (response.body.isNotEmpty) {
      if (response.statusCode == 200) {
        print('uid following $uid');
        final result =
        json.decode(response.body)['values'].cast<Map<String, dynamic>>();
        _data = result
            .map<MengikutiModel>((json) => MengikutiModel.fromJson(json))
            .toList();
        return _data;
      } else {}
    } else {
      print('Terjadi disini kesalahannya');
    }
  }

  //mendapatkan info follower fanbase
  Future<List<MengikutiModel>> getFanbaseFollower(String idfanbase) async {
    final url = 'https://discoverkorea.site/apiuser/followerfanbase/$idfanbase';
    final response = await http.get(url);
    if (response.body.isNotEmpty) {
      if (response.statusCode == 200) {
        print('uid fanbase $idfanbase');
        final result =
        json.decode(response.body)['values'].cast<Map<String, dynamic>>();
        _data = result
            .map<MengikutiModel>((json) => MengikutiModel.fromJson(json))
            .toList();
        return _data;
      } else {}
    } else {
      print('Terjadi disini kesalahannya');
    }
  }
  //info detail data orang yang akan dilihat follower,following,fanbase

  Future<MengikutiModel> getOtherUserSpecified(String uid) async {
    uid2 = uid;
  }


  //mendapatkan info following orang lain
  Future<List<MengikutiModel>> getProfileFollowing2() async {
    final url = 'https://discoverkorea.site/apiuser/following/$uid2';
    final response = await http.get(url);
    if (response.body.isNotEmpty) {
      if (response.statusCode == 200) {
        print('uid following 2 $uid2');
        final result =
        json.decode(response.body)['values'].cast<Map<String, dynamic>>();
        _data = result
            .map<MengikutiModel>((json) => MengikutiModel.fromJson(json))
            .toList();
        return _data;
      } else {}
    } else {
      print('Terjadi disini kesalahannya');
    }
  }
  //mendapatkan info follower orang lain
  Future<List<MengikutiModel>> getProfileFollower2() async {
    final url = 'https://discoverkorea.site/apiuser/follower/$uid2';
    final response = await http.get(url);
    if (response.body.isNotEmpty) {
      if (response.statusCode == 200) {
        print('uid following 2 $uid2');
        final result =
        json.decode(response.body)['values'].cast<Map<String, dynamic>>();
        _data = result
            .map<MengikutiModel>((json) => MengikutiModel.fromJson(json))
            .toList();
        return _data;
      } else {}
    } else {
      print('Terjadi disini kesalahannya');
    }
  }
  // FOLLOW USER
  Future<bool> followUser(String mengikuti, String pengikut) async {
    final url = 'https://discoverkorea.site/apiuser/followuser';
    final response = await http.post(url, body: {
      'mengikuti': mengikuti,
      'pengikut': pengikut,
    });

    final result = json.decode(response.body);
    if (response.statusCode == 200 && result['message'] == 'Success!') {
      notifyListeners();
      return true;
    }
    return false;
  }

}
