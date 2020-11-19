import 'dart:convert';

List<CommentModel> welcomeFromJson(String str) =>
    List<CommentModel>.from(json.decode(str).map((x) => CommentModel.fromJson(x)));

class CommentModel {
  String uid;
  String id_post;
  String message;
  String username;
  String sender;
  String profile_picture;
  String tanggal_pesan;

  CommentModel({
    this.uid,
    this.id_post,
    this.message,
    this.username,
    this.sender,
    this.profile_picture,
    this.tanggal_pesan,
  });

  //FORMAT TO JSON
  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        uid: json["uid"],
        id_post: json["id_post"],
        message: json["message"],
        username: json["username"],
        sender: json["sender"],
        profile_picture: json["profile_picture"],
        tanggal_pesan: json["tanggal_pesan"],
      );

//PARSE JSON
}
