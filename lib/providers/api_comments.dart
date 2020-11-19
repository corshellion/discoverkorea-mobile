import 'package:discoverkorea/models/model_comments.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class ApiComments extends ChangeNotifier {
  List<CommentModel> _data = [];
  List<CommentModel> get dataComment => _data;
  SharedPreferences sharedPreferences;
  String uid = "unknown";
  ApiComments() {
    notifyListeners();
    setup();
  }

  void setup() async {
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url2 = await prefs.getString('uid');
    uid = url2;

  }

  //mendapatkan info comments
  Future<List<CommentModel>> getComment(String idpost) async {
    final url = 'https://discoverkorea.site/apiuser/getcomment/$idpost';
    final response = await http.get(url);
    if (response.body.isNotEmpty) {
      if (response.statusCode == 200) {
        print('room chat $uid');
        final result =
        json.decode(response.body)['values'].cast<Map<String, dynamic>>();
        _data = result
            .map<CommentModel>((json) => CommentModel.fromJson(json))
            .toList();
        return _data;
      } else {}
    } else {
      print('Terjadi disini kesalahannya');
    }
  }
  // CHAT USER
  Future<bool> commentUser(String message, String username, String idpost) async {
    final url = 'https://discoverkorea.site/apiuser/kirimcomment';
    final response = await http.post(url, body: {
      'message': message,
      'username': username,
      'idpost': idpost,
    });

    final result = json.decode(response.body);
    if (response.statusCode == 200 && result['message'] == 'Success!') {
      notifyListeners();
      return true;
    }
    return false;
  }
}
