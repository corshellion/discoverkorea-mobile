import 'package:discoverkorea/models/model_notifikasi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiNotifikasi extends ChangeNotifier {
  List<NotificationModel> _data = [];
  List<NotificationModel> get dataNotif => _data;
  SharedPreferences sharedPreferences;
  String username = "unknown";
  ApiNotifikasi() {
    setup();
  }

  void setup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = (await prefs.getString('username') ?? 'unknown');
    username = url;
    notifyListeners();
  }

  Future<List<NotificationModel>> getNotif() async {
    final url = 'https://discoverkorea.site/apinotifikasi/$username';
    final response = await http.get(url);
    print('masuk sini pak e ' + username);
    if (response.statusCode == 200) {
      final result =
          json.decode(response.body)['values'].cast<Map<String, dynamic>>();
      _data = result
          .map<NotificationModel>((json) => NotificationModel.fromJson(json))
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
