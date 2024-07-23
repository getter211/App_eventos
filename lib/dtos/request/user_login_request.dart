// To parse this JSON data, do
//
//     final userLoginRequestDto = userLoginRequestDtoFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

UserLoginRequestDto userLoginRequestDtoFromJson(String str) => UserLoginRequestDto.fromJson(json.decode(str));

String userLoginRequestDtoToJson(UserLoginRequestDto data) => json.encode(data.toJson());

class UserLoginRequestDto {
    final String email;
    final String password;

    UserLoginRequestDto({
        required this.email,
        required this.password,
    });

    factory UserLoginRequestDto.fromJson(Map<String, dynamic> json) => UserLoginRequestDto(
        email: json["email"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
    };
}
