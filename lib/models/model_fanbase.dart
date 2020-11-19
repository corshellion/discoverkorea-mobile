import 'dart:convert';

List<FanbaseModel> welcomeFromJson(String str) => List<FanbaseModel>.from(
    json.decode(str).map((x) => FanbaseModel.fromJson(x)));

class FanbaseModel {
  String id_kategori;
  String id_tag;
  String namakategori;
  String namatag;
  String uid;
  String role;
  String photo;
  String group_name;
  String username;
  String chairman;
  String description;
  String category;
  String message;
  String sender;
  String tanggal;
  String profile_picture;

  FanbaseModel({
    this.id_kategori,
    this.id_tag,
    this.namakategori,
    this.namatag,
    this.uid,
    this.role,
    this.photo,
    this.group_name,
    this.username,
    this.chairman,
    this.description,
    this.category,
    this.message,
    this.sender,
    this.tanggal,
    this.profile_picture,
  });

  //FORMAT TO JSON
  factory FanbaseModel.fromJson(Map<String, dynamic> json) => FanbaseModel(
        id_kategori: json["id_kategori"],
        id_tag: json["id_tag"],
        namakategori: json["namakategori"],
        namatag: json["namatag"],
        uid: json["uid"],
        role: json["role"],
        photo: json["photo"],
        group_name: json["group_name"],
        username: json["username"],
        chairman: json["chairman"],
        description: json["description"],
        category: json["category"],
        message: json["message"],
        sender: json["sender"],
        tanggal: json["tanggal_pesan"],
        profile_picture: json["profile_picture"],
      );

//PARSE JSON
}
