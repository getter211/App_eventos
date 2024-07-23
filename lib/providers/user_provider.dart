// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:proyecto_eventos/dtos/request/user_login_request.dart';
import 'package:proyecto_eventos/dtos/response/use_register_response.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto_eventos/pages/home_screen.dart';
import 'package:proyecto_eventos/pages/login_screen.dart';
import 'package:proyecto_eventos/pages/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  final logger = Logger();
  UserLoginRequestDto? _userLogin;
  UserRegisterResponseDto? _userRegister;
  String? _username;

  bool isLoading = true;
  bool userFound = false;

  UserLoginRequestDto? get userLogin => _userLogin;
  UserRegisterResponseDto? get userRegister => _userRegister;
  String? get username => _username;
  UserProvider() {
    loadUserFromPreferences();
  }
  Future<void> saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userIdx', userId);
  }

  Future<void> saveUserToPreferences(int id, String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', id);
    await prefs.setString('username', username);
    _username = username;
    notifyListeners();
    logger.i("Guardado en SharedPreferences: userId = $id, username = $username");
  }

  Future<void> clearUserPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('username');
    _username = null; // Limpia el nombre de usuario
    notifyListeners(); // Notifica a los listeners sobre el cambio
    logger.i("Datos de usuario eliminados de SharedPreferences");
  }

  Future<void> loadUserFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    String? username = prefs.getString('username');

    if (userId != null && username != null) {
      userFound = true;
      _username = username;
      logger.i("Cargado desde SharedPreferences: userId = $userId, username = $username");
      notifyListeners();
    } else {
      logger.i("No se encontró usuario en SharedPreferences");
    }
  }

  Future<void> loginUser(String email, String password, BuildContext context) async {
    final userLogin = UserLoginRequestDto(email: email, password: password);

    final response = await http.post(
      Uri.parse('http://localhost:3000/api/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userLogin.toJson()),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final userId = responseData['user']['id'];
      final username = responseData['user']['username'];

      if (context.mounted) {
        saveUserId(userId);
        userFound = true;
        await saveUserToPreferences(userId, username);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Iniciado sesión con éxito')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } else {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error de inicio de sesión'),
              content: const Text(
                'La dirección de correo electrónico y/o la contraseña son incorrectos. Inténtalo de nuevo.',
              ),
              actions: [
                TextButton(
                  child: const Text('Entendido'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future<void> registerUser(
      String username, String email, String password, BuildContext context) async {
    final userRegister =
        UserRegisterResponseDto(username: username, email: email, password: password);

    final userLogin = UserLoginRequestDto(email: email, password: password);

    final responsePost = await http.post(
      Uri.parse('http://localhost:3000/api/auth/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userRegister.toJson()),
    );

    if (responsePost.statusCode == 201) {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userLogin.toJson()),
      );
      final responseData = json.decode(response.body);
      final userId = responseData['user']['id'];
      final username = responseData['user']['username'];

      if (context.mounted) {
        saveUserId(userId);
        userFound = true;
        await saveUserToPreferences(userId, username);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Te has registrado'),
              actions: [
                TextButton(
                  child: const Text('Entendido'),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error al registrarse'),
              content: const Text('Error al crear la cuenta'),
              actions: [
                TextButton(
                  child: const Text('Entendido'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }
}
