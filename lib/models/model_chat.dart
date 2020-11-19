import 'dart:convert';

List<ChatModel> welcomeFromJson(String str) =>
    List<ChatModel>.from(json.decode(str).map((x) => ChatModel.fromJson(x)));

class ChatModel {
  String uid;
  String nama;
  String id_room;
  String message;
  String username;
  String sender2;
  String profile_picture;

  ChatModel({
    this.uid,
    this.nama,
    this.id_room,
    this.message,
    this.username,
    this.sender2,
    this.profile_picture,
  });

  //FORMAT TO JSON
  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        uid: json["uid"],
        nama: json["nama"],
        id_room: json["id_room"],
        message: json["message"],
        username: json["username"],
        sender2: json["sender"],
    profile_picture: json["profile_picture"],
      );

//PARSE JSON
}
