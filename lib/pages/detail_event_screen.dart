import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';

class DetailEventScreen extends StatelessWidget {
  
  DetailEventScreen({super.key, Key});

  // Evento ficticio de Skrillex en México
  final Map<String, dynamic> event = {
    "name": "Concierto de Skrillex en México",
    "date": "2024-08-10",
    "time": "20:00",
    "description":
        "¡No te pierdas la presentación épica de Skrillex en México! Un evento lleno de energía y ritmos únicos que no puedes perderte.",
    "location": "Estadio Azteca, Ciudad de México",
    "guests": "Artistas invitados sorpresa",
    "cost": 350,
    "status": "Activo",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Evento'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ResponsiveGridRow(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ResponsiveGridCol(
              xs: 12,
              md: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16.0),
                  Text(
                    event['name'],
                    style: const TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Fecha: ${event['date']}',
                    style: const TextStyle(fontSize: 20.0, color: Colors.black54),
                  ),
                  Text(
                    'Hora: ${event['time']}',
                    style: const TextStyle(fontSize: 20.0, color: Colors.black54),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Descripción:',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Text(
                    event['description'],
                    style: const TextStyle(fontSize: 18.0, color: Colors.black87),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Ubicación:',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Text(
                    event['location'],
                    style: const TextStyle(fontSize: 18.0, color: Colors.black87),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Invitados:',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Text(
                    event['guests'],
                    style: const TextStyle(fontSize: 18.0, color: Colors.black87),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Costo: \$${event['cost']}',
                    style: const TextStyle(fontSize: 20.0, color: Colors.black),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Estatus: ${event['status']}',
                    style: const TextStyle(fontSize: 20.0, color: Colors.black),
                  ),
                  const SizedBox(height: 32.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          // Navegar a la pantalla de edición
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => EditEventScreen(event: event)));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(16),
                        ),
                        icon: const Icon(Icons.edit, color: Colors.white),
                        label: const Text('Editar', style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 16.0),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Implementar la lógica para registrarse al evento
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(16),
                        ),
                        icon: const Icon(Icons.event_available, color: Colors.white),
                        label: const Text('Registrarse', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
