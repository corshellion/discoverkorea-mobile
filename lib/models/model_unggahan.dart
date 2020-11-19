import 'dart:convert';

List<EmployeeModel> welcomeFromJson(String str) => List<EmployeeModel>.from(
    json.decode(str).map((x) => EmployeeModel.fromJson(x)));

class EmployeeModel {
  String id;
  int previlege;
  String status_post;
  String category;
  String username;
  String title;
  String status;
  String file;
  String type;
  String created_at;
  int liked;
  int bookmarks;
  int likes;
  EmployeeModel({
    this.id,
    this.previlege,
    this.status_post,
    this.category,
    this.username,
    this.title,
    this.status,
    this.file,
    this.type,
    this.created_at,
    this.liked,
    this.bookmarks,
    this.likes,
  });

  //FORMAT TO JSON
  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
    id: json["uid"],
    previlege: json["previlege"],
    status_post: json["status_post"],
    category: json["category"],
    username: json["username"],
    title: json["title"],
    status: json["status"],
    file: json["file"],
    type: json["type"],
    created_at: json["created_at"],
    liked: json["liked"],
    bookmarks: json["bookmark"],
    likes: json["likes"],
  );

//PARSE JSON
}
