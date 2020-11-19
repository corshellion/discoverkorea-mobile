import 'package:discoverkorea/models/model_unggahan.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiUnggahan extends ChangeNotifier {
  List<EmployeeModel> _data = [];
  List<EmployeeModel> get dataPost => _data;
  List<EmployeeModel> _datafanbase = [];
  List<EmployeeModel> get dataPostFanbase => _datafanbase;
  List<EmployeeModel> _datafollowing = [];
  List<EmployeeModel> get dataPostFollowing => _datafollowing;
  SharedPreferences sharedPreferences;
  String username = "unknown";
  String uid = "";

  ApiUnggahan() {
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
  Future<List<EmployeeModel>> getAllPost() async {
    final url = 'https://discoverkorea.site/apiunggah';
    final response = await http.get(url);
    if (response.body.isNotEmpty) {
      if (response.statusCode == 200) {
        final result =
        json.decode(response.body)['values'].cast<Map<String, dynamic>>();
        _data = result
            .map<EmployeeModel>((json) => EmployeeModel.fromJson(json))
            .toList();
        return _data;
      } else {}
    } else {
      print('Terjadi disini kesalahannya');
    }
  }
  Future<List<EmployeeModel>> getPost() async {
    final url = 'https://discoverkorea.site/apiunggahfollowing/$uid';
    final response = await http.get(url);
    print('uid ini adalah $uid');
    print(response.body);
    if (response.body.isNotEmpty) {
      if (response.statusCode == 200) {
        final result =
        json.decode(response.body)['values'].cast<Map<String, dynamic>>();
        _datafollowing = result
            .map<EmployeeModel>((json) => EmployeeModel.fromJson(json))
            .toList();
        return _datafollowing;
      } else {}
    } else {
      print('Terjadi disini kesalahannya');
    }
  }

  Future<List<EmployeeModel>> getPostSpecified() async {
    final url = 'https://discoverkorea.site/apiunggah/$username';
    final response = await http.get(url);
    if (response.body.isNotEmpty) {
      print('masuk sini pak ' + "$username" + "urlnya :" + url);
      if (response.statusCode == 200) {
        final result =
        json.decode(response.body)['values'].cast<Map<String, dynamic>>();
        _data = result
            .map<EmployeeModel>((json) => EmployeeModel.fromJson(json))
            .toList();
        return _data;
      } else {
        // throw Exception();
      }
    } else {
      print('Terjadi disini kesalahannya');
    }
  }
  Future<List<EmployeeModel>> getFanbasePostSpecified() async {
    final url = 'https://discoverkorea.site/apiunggahfanbase/$fanbaseid';
    final response = await http.get(url);
    if (response.body.isNotEmpty) {
      if (response.statusCode == 200) {
        final result =
        json.decode(response.body)['values'].cast<Map<String, dynamic>>();
        _datafanbase = result
            .map<EmployeeModel>((json) => EmployeeModel.fromJson(json))
            .toList();
        return _datafanbase;
      } else {
        print('respons'+response.body);
        // throw Exception();
      }
    } else {
      print('Terjadi disini kesalahannya');
    }
  }
  String fanbaseid="";
  Future<EmployeeModel> getPostFanbaseSpecified(String idfan) async {
    fanbaseid = idfan;
  }
  //mencari user lain
  String otheruser = "";
  Future<EmployeeModel> getOtherPostSpecified(String username) async {
    otheruser = username;
  }

  //mencari detail gambar profile
  Future<EmployeeModel> getdetailprofileimage(String id) async {
    return dataPost.firstWhere((i) => i.id == id);
  }
  //mencari detail gambar profile feeeed
  Future<EmployeeModel> getdetailprofileimage2(String id) async {
    return dataPostFollowing.firstWhere((i) => i.id == id);
  }
  Future<List<EmployeeModel>> getOtherPost() async {
    final url = 'https://discoverkorea.site/apiunggah/$otheruser';
    final response = await http.get(url);
    print('masuk sini pak ' + "$username" + "urlnya :" + url);
    if (response.statusCode == 200) {
      final result =
      json.decode(response.body)['values'].cast<Map<String, dynamic>>();
      _data = result
          .map<EmployeeModel>((json) => EmployeeModel.fromJson(json))
          .toList();
      return _data;
    } else {
      // throw Exception();
    }
  }
// //ADD DATA
// Future<bool> storeEmployee(String name, String salary, String age) async {
//   final url = 'http://employee-crud-flutter.daengweb.id/add.php';
//   final response = await http.post(url, body: {
//     'employee_name': name,
//     'employee_salary': salary,
//     'employee_age': age
//   });

//   final result = json.decode(response.body);
//   if (response.statusCode == 200 && result['message'] == 'success') {
//     notifyListeners();
//     return true;
//   }
//   return false;
// }

// Future<EmployeeModel> findEmployee(String id) async {
//   return _data.firstWhere((i) => i.id == id);
// }

// Future<bool> updateEmployee(id, name, salary, age) async {
//   final url = 'http://employee-crud-flutter.daengweb.id/update.php';
//   final response = await http.post(url, body: {
//     'id': id,
//     'employee_name': name,
//     'employee_salary': salary,
//     'employee_age': age
//   });

//   final result = json.decode(response.body);
//   if (response.statusCode == 200 && result['message'] == 'success') {
//     notifyListeners();
//     return true;
//   }
//   return false;
// }

// Future<void> deleteEmployee(String id) async {
//   final url = 'http://employee-crud-flutter.daengweb.id/delete.php';
//   await http.get(url + '?id=$id');
// }
}
