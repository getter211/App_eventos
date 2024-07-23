import 'package:flutter/material.dart';

class AuthForm extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final bool isLoginForm;

  const AuthForm({
    super.key,
    required this.title,
    this.subtitle,
    required this.buttonText,
    required this.onButtonPressed,
    this.isLoginForm = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 36.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 10),
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.grey[700],
            ),
          ),
        ],
        const SizedBox(height: 40),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Correo electrónico',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Contraseña',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onButtonPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(16),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (isLoginForm) ...[
          GestureDetector(
            onTap: () {
              // Navegar a la pantalla de registro
            },
            child: const Text(
              '¿No tienes cuenta? Regístrate',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
