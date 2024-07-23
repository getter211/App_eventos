import 'package:flutter/material.dart';
import 'package:proyecto_eventos/widgets/forms_createEvent.dart'; // Ensure the import path is correct

class CreateEventScreen extends StatelessWidget {
  const CreateEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Nuevo Evento'),
      ),
      body: const AddEvents(), // Include the CreateEvent widget here
    );
  }
}
