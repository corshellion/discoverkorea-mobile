import 'package:discoverkorea/models/model_chat.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class ApiChat extends ChangeNotifier {
  List<ChatModel> _data = [];
  List<ChatModel> get dataChat => _data;
  List<ChatModel> _dataroom = [];
  List<ChatModel> get dataRoom => _dataroom;
  SharedPreferences sharedPreferences;
  String uid = "unknown";
  ApiChat() {
    notifyListeners();
    setup();
  }

  void setup() async {
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url2 = await prefs.getString('uid');
    uid = url2;

  }

  //mendapatkan info chat
  Future<List<ChatModel>> getChat(String idroom) async {
    final url = 'https://discoverkorea.site/apiuser/showpesan/$idroom';
    final response = await http.get(url);
    if (response.body.isNotEmpty) {
      if (response.statusCode == 200) {
        print('room chat $uid');
        final result =
        json.decode(response.body)['values'].cast<Map<String, dynamic>>();
        _data = result
            .map<ChatModel>((json) => ChatModel.fromJson(json))
            .toList();
        return _data;
      } else {}
    } else {
      print('Terjadi disini kesalahannya');
    }
  }
  // CHAT USER
  Future<bool> chatUser(String message, String username, String idroom) async {
    final url = 'https://discoverkorea.site/apiuser/pesan';
    final response = await http.post(url, body: {
      'message': message,
      'username': username,
      'idroom': idroom,
    });

    final result = json.decode(response.body);
    if (response.statusCode == 200 && result['message'] == 'Success!') {
      notifyListeners();
      return true;
    }
    return false;
  }
  // ROOM CHAT
  Future<List<ChatModel>> getRoom() async {
    final url = 'https://discoverkorea.site/apiuser/getroom/$uid';
    final response = await http.get(url);
    if (response.body.isNotEmpty) {
      if (response.statusCode == 200) {
        final result =
        json.decode(response.body)['values'].cast<Map<String, dynamic>>();
        _dataroom = result
            .map<ChatModel>((json) => ChatModel.fromJson(json))
            .toList();
        return _dataroom;
      } else {}
    } else {
      print('Terjadi disini kesalahannya');
    }
  }
}
