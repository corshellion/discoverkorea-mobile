import 'dart:convert';

List<NotificationModel> welcomeFromJson(String str) =>
    List<NotificationModel>.from(
        json.decode(str).map((x) => NotificationModel.fromJson(x)));

class NotificationModel {
  String id_notification;
  String from;
  String to;
  String message;
  String date;
  NotificationModel({
    this.id_notification,
    this.from,
    this.to,
    this.message,
    this.date,
  });

  //FORMAT TO JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id_notification: json["id_notification"],
        from: json["from"],
        to: json["to"],
        message: json["message"],
        date: json["date"],
      );

  //PARSE JSON
}
