import 'dart:convert';

List<MengikutiModel> welcomeFromJson(String str) => List<MengikutiModel>.from(
    json.decode(str).map((x) => MengikutiModel.fromJson(x)));

class MengikutiModel {
  String uid;
  String id_following;
  String id_follower;
  String role;
  String username;
  String profile_picture;

  MengikutiModel({
    this.uid,
    this.id_following,
    this.id_follower,
    this.role,
    this.username,
    this.profile_picture,
  });

  //FORMAT TO JSON
  factory MengikutiModel.fromJson(Map<String, dynamic> json) => MengikutiModel(
        uid: json["uid"],
        id_following: json["id_following"],
        id_follower: json["id_follower"],
        role: json["role"],
        username: json["username"],
        profile_picture: json["profile_picture"],
      );

//PARSE JSON
}
