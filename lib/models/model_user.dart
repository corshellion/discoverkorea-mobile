import 'dart:convert';

List<UserModel> welcomeFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

class UserModel {
  String uid;
  String previlege;
  String verified;
  String username;
  String profile_picture;
  String status;
  String nama;
  String biodata;
  String email;
  String nohp;
  String alamat;
  String password;
  String remember_token;
  String created_at;
  String updated_at;
  UserModel({
    this.uid,
    this.previlege,
    this.verified,
    this.username,
    this.profile_picture,
    this.status,
    this.nama,
    this.biodata,
    this.email,
    this.nohp,
    this.alamat,
    this.password,
    this.remember_token,
    this.created_at,
    this.updated_at,
  });

  //FORMAT TO JSON
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json["uid"],
        previlege: json["previlege"],
        verified: json["verified"],
        username: json["username"],
        profile_picture: json["profile_picture"],
        status: json["status"],
        nama: json["nama"],
        biodata: json["biodata"],
        email: json["email"],
        nohp: json["nohp"],
        alamat: json["alamat"],
        password: json["password"],
        remember_token: json["remember_token"],
        created_at: json["created_at"],
        updated_at: json["updated_at"],
      );

  //PARSE JSON
}
