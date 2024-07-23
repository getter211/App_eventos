// To parse this JSON data, do
//
//     final getAllEventsResponseDto = getAllEventsResponseDtoFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GetAllEventsResponseDto getAllEventsResponseDtoFromJson(String str) => GetAllEventsResponseDto.fromJson(json.decode(str));

String getAllEventsResponseDtoToJson(GetAllEventsResponseDto data) => json.encode(data.toJson());

class GetAllEventsResponseDto {
  final int id;
  final String name;
  final DateTime date;
  final String time;
  final String description;
  final String location;
  final String latitude;
  final String longitude;
  final int cost;
  final String status;
  final int createdBy;
  final String guest;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User user;
  final List<Registration> registrations;

  GetAllEventsResponseDto({
    required this.id,
    required this.name,
    required this.date,
    required this.time,
    required this.description,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.cost,
    required this.status,
    required this.createdBy,
    required this.guest,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.registrations,
  });

  factory GetAllEventsResponseDto.fromJson(Map<String, dynamic> json) => GetAllEventsResponseDto(
        id: json["id"],
        name: json["name"],
        date: DateTime.parse(json["date"]),
        time: json["time"],
        description: json["description"],
        location: json["location"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        cost: json["cost"],
        status: json["status"],
        createdBy: json["createdBy"],
        guest: json["guest"],

       //   "createdBy": 1,
       // "guest": "xxxx",

        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        user: User.fromJson(json["User"]),
        registrations:
            List<Registration>.from(json["Registrations"].map((x) => Registration.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "date": date.toIso8601String(),
        "time": time,
        "description": description,
        "location": location,
        "latitude": latitude,
        "longitude": longitude,
        "cost": cost,
        "status": status,
        "createdBy": createdBy,
        "guest": guest,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "User": user.toJson(),
        "Registrations": List<dynamic>.from(registrations.map((x) => x.toJson())),
      };
}

class Registration {
  final int id;
  final int eventId;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Registration({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Registration.fromJson(Map<String, dynamic> json) => Registration(
        id: json["id"],
        eventId: json["eventId"],
        userId: json["userId"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "eventId": eventId,
        "userId": userId,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

class User {
  final int id;
  final String username;
  final String email;
  final String password;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "password": password,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
