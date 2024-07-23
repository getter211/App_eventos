// To parse this JSON data, do
//
//     final userRegisterResponseDto = userRegisterResponseDtoFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

UserRegisterResponseDto userRegisterResponseDtoFromJson(String str) => UserRegisterResponseDto.fromJson(json.decode(str));

String userRegisterResponseDtoToJson(UserRegisterResponseDto data) => json.encode(data.toJson());

class UserRegisterResponseDto {
    final String username;
    final String email;
    final String password;

    UserRegisterResponseDto({
        required this.username,
        required this.email,
        required this.password,
    });

    factory UserRegisterResponseDto.fromJson(Map<String, dynamic> json) => UserRegisterResponseDto(
        username: json["username"],
        email: json["email"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "password": password,
    };
}
