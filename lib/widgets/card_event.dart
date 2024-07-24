import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_eventos/dtos/response/get_all_events_response.dart';
import 'package:proyecto_eventos/pages/home_screen.dart';
import 'package:proyecto_eventos/providers/event_providers.dart';
import 'package:proyecto_eventos/widgets/forms_createEvent.dart';
import 'package:proyecto_eventos/widgets/my_dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardEvent extends StatefulWidget {
  final GetAllEventsResponseDto item;
  final String imageUrl;
  final String title;
  final DateTime dateTime;
  final bool isFree;
  final String guests;
  final void Function(int)? onTap;
  final bool isEdit;

  const CardEvent({
    super.key,
    required this.item,
    required this.imageUrl,
    required this.title,
    required this.dateTime,
    required this.isFree,
    required this.guests,
    required this.onTap,
    this.isEdit = false,
    
  });

  @override
  _CardEventState createState() => _CardEventState();
}

class _CardEventState extends State<CardEvent> {
  late Future<int?> userIdFuture;
  late Future<bool> isRegisteredFuture;
  int xxx = 0;

  @override
  void initState() {
    super.initState();
    getUserIdx();
    userIdFuture = getUserId();
    isRegisteredFuture = Future.value(
        false); // Inicializa la futura verificación como no registrado
  }

  // Función para obtener el userId desde SharedPreferences
  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  // Función para verificar si el usuario ya está registrado en el evento
  Future<bool> isUserRegistered(int eventId, int userId) async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://localhost:3000/api/events/registrationStatus?eventId=$eventId&userId=$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData[
            'isRegistered']; // Asegúrate de que la respuesta contenga este campo
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<int?> getUserIdx() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    xxx = prefs.getInt('userIdx') ?? 0;
    setState(() {});
    return null;
  }

  // Función para registrar al usuario en el evento
  Future<void> registerUser(int eventId, int userId) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/events/registerToEvent'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "eventId": eventId,
          "userId": userId,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          isRegisteredFuture = isUserRegistered(
              eventId, userId); // Refresca el estado de registro
        });
        myDialogDone(context, "Registrado con éxito");
        final eventProvider =
            Provider.of<EventProvider>(context, listen: false);
        eventProvider.refreshEvents();
      } else if (response.statusCode == 400) {
        myDialogBlueWarning(context, "Ya está registrado");
      } else {
        myDialogWarning2(context, "Error al registrarse. Inténtalo de nuevo");
      }
    } catch (e) {
      myDialogWarning2(context, "Error de conexión. Inténtalo de nuevo");
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');

    return Container(
      margin: const EdgeInsets.all(10.0),
      height: 450,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey, width: 2),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                widget.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.item.status,
                        
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.cost < 0
                            ? 'Gratis'
                            : 'Costo: \$${widget.item.cost}',
                        style: const TextStyle(fontSize: 15),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 15),
                          const SizedBox(width: 5),
                          Text(dateFormat.format(widget.dateTime)),
                          const SizedBox(width: 10),
                          const Icon(Icons.access_time, size: 15),
                          const SizedBox(width: 5),
                          Text(widget.item.time),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Invitado: ${widget.item.guest}',
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddEvents(
                                show: widget.isEdit,
                                isCreate: true,
                                event: widget.item,
                                // Mantén el parámetro isEdit
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                        child: Text(
                          widget.isEdit ? 'Editar Evento' : 'Ver Detalles',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Visibility(
                        visible: widget.isEdit,
                        child: DeleteEventButton(eventId: widget.item.id)),
                      Visibility(
                        visible: widget.isEdit
                            ? false
                            : xxx == widget.item.user.id
                                ? false
                                : true,
                        child: FutureBuilder<int?>(
                          future: userIdFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }

                            final userId = snapshot.data;
                            if (userId == null) {
                              return const Text(
                                  "Error al obtener el ID del usuario");
                            }

                            return FutureBuilder<bool>(
                              future: isUserRegistered(widget.item.id, userId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }

                                final isRegistered = snapshot.data ?? false;

                                return ElevatedButton(
                                  onPressed: isRegistered
                                      ? null
                                      : () async {
                                          await registerUser(
                                              widget.item.id, userId);
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isRegistered
                                        ? Colors.grey
                                        : Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                  ),
                                  child: Text(
                                    isRegistered
                                        ? 'Ya Registrado'
                                        : 'Registrarse',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class DeleteEventButton extends StatefulWidget {
  final int eventId;

  const DeleteEventButton({super.key, required this.eventId});

  @override
  State<DeleteEventButton> createState() => _DeleteEventButtonState();
}

class _DeleteEventButtonState extends State<DeleteEventButton> {
  Future<void> deleteEvent(int id) async {
    final url = Uri.parse('http://localhost:3000/api/events/$id');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        // Si la eliminación es exitosa, puedes mostrar un mensaje o realizar alguna acción
        print('Event deleted successfully');
        final eventProvider = Provider.of<EventProvider>(context, listen: false);
        eventProvider.refreshEvents(); Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        // Si hay un error, puedes manejarlo aquí
        print('Failed to delete the event');
      }
    } catch (error) {
      // Si hay un error en la solicitud, puedes manejarlo aquí
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(16),
      ),
      onPressed: () async {
        await deleteEvent(widget.eventId);
        // Aquí puedes agregar alguna acción después de eliminar el evento, como mostrar un snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Evento eliminado'),
          ),
        );
      },
      child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
    );
  }
}
