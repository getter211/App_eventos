import 'dart:math';
import 'package:flutter/material.dart';
import 'package:proyecto_eventos/dtos/response/get_all_events_response.dart';
import 'package:proyecto_eventos/pages/calendar_screen.dart';
import 'package:proyecto_eventos/pages/create_event.dart';
import 'package:proyecto_eventos/pages/login_screen.dart';
import 'package:proyecto_eventos/pages/map_screen.dart';
import 'package:proyecto_eventos/pages/user_event_screen.dart';
import 'package:proyecto_eventos/providers/event_providers.dart';
import 'package:proyecto_eventos/providers/user_provider.dart'; // Importa UserProvider
import 'package:proyecto_eventos/widgets/card_event.dart';
import 'package:proyecto_eventos/widgets/forms_createEvent.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<GetAllEventsResponseDto> _eventosTemp = [];
  List<GetAllEventsResponseDto> _eventosOriginal = [];
  int xxx = 0;
  // 0 default
  // 1 active
  // 2 inactive
  // 3 completed
  // 4 cancelled
  // 5 date

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventProvider>(context, listen: false)
          .fetchEvents(); // Llama a fetchEvents en lugar de _fetchEvents
    });
  }

  void _filterEvents(int filter) {
    setState(() {
      xxx = filter;
      if (filter == 0) {
        _eventosTemp = [..._eventosOriginal];
      } else if (filter == 5) {
        _eventosTemp = [..._eventosOriginal]..sort((a, b) => a.date.compareTo(b.date));
      } else {
        _eventosTemp = _eventosOriginal.where((event) {
          switch (filter) {
            case 1:
              return event.status == 'active';
            case 2:
              return event.status == 'inactive';
            case 3:
              return event.status == 'completed';
            case 4:
              return event.status == 'cancelled';
            default:
              return true;
          }
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    final userProvider = Provider.of<UserProvider>(context); // Accede al UserProvider

    List<GetAllEventsResponseDto> eventos = eventProvider.events;
    _eventosOriginal = [...eventos];
    if (xxx == 0) {
      _eventosTemp = [...eventos];
    }
    if (xxx != 0) {
      DateTime now = DateTime.now().toUtc(); // Asegúrate de que la fecha actual esté en UTC

      for (GetAllEventsResponseDto element in _eventosTemp) {
        try {
          // Usa la fecha y hora directamente desde `date`
          DateTime eventDateTime = element.date.toUtc();

          // Ajustar la hora si el campo `time` proporciona una hora diferente
          if (element.time.isNotEmpty) {
            List<String> timeParts = element.time.split(':');
            eventDateTime = DateTime(
              eventDateTime.year,
              eventDateTime.month,
              eventDateTime.day,
              int.parse(timeParts[0]),
              int.parse(timeParts[1]),
              int.parse(timeParts[2]),
            ).toUtc();
          }

          if (eventDateTime.isBefore(now)) {
            print('Evento pasado: ${element.date.toIso8601String()} ${element.time}');
          }
        } catch (e) {
          // Manejo de errores si el formato es incorrecto
          print('Error al combinar fecha y hora: $e');
          continue; // Continúa con el siguiente elemento en caso de error
        }
      }
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Text(
                'Eventos Musicales',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month_outlined),
              title: const Text('Calendario'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ViewCalendarioEvento()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('Mis eventos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserEventsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('cerrar sesión'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'End Drawer Header',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: Builder(
                        builder: (BuildContext context) {
                          return IconButton(
                            onPressed: () {
                              _scaffoldKey.currentState?.openDrawer();
                            },
                            icon: const Icon(Icons.menu),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, bottom: 10, top: 10),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Hola de nuevo ${userProvider.username ?? 'Invitado'}😸\n',
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const TextSpan(
                              text: 'Mira los eventos \n',
                              style: TextStyle(fontSize: 15, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddEvents()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(16),
                    ),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('Añadir Evento', style: TextStyle(color: Colors.white)),
                  ),
                  DropdownButton<int>(
                    value: xxx,
                    icon: const Icon(Icons.filter_list, color: Color.fromARGB(255, 0, 0, 0)),
                    iconSize: 30,
                    dropdownColor: const Color.fromARGB(255, 241, 241, 241),
                    style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 16,
                    ),
                    underline: Container(
                      height: 1,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                    items: const [
                      DropdownMenuItem(value: 0, child: Text("Todos")),
                      DropdownMenuItem(value: 1, child: Text("Activo")),
                      DropdownMenuItem(value: 2, child: Text("Inactivo")),
                      DropdownMenuItem(value: 3, child: Text("Completado")),
                      DropdownMenuItem(value: 4, child: Text("Cancelado")),
                      DropdownMenuItem(value: 5, child: Text("Por Fecha")),
                    ],
                    onChanged: (value) {
                      _filterEvents(value!);
                    },
                    hint: const Text(
                      'Filtrar eventos',
                      style: TextStyle(
                        color: Color.fromARGB(136, 255, 255, 255),
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              ),
            ),
            eventProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ResponsiveGridRow(
                            children: _eventosTemp.map((event) {
                              return ResponsiveGridCol(
                                xs: 12,
                                sm: 6,
                                md: 4,
                                lg: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: CardEvent(
                                    onTap: (int value) {
                                      final eventProvider =
                                          Provider.of<EventProvider>(context, listen: false);
                                      eventProvider.refreshEvents();

// el parametro int solo es por que lo puso gpt si a ti te sirve retornar algun mensaje, texto o algo puedes retornarlo de tu card y mandarlo a tu home es una mejor forma de manejar los estados a este tipo de llamados se les conoce como inyeccuoin de codig o eso te facilitaram mira
// digamos que en la card validas cuando apreta y si todo esta bien haras estoi
                                    },
                                    item: event,
                                    imageUrl: 'assets/images/cardEvento.jpg',
                                    title: event.name,
                                    guests: event.description,
                                    isFree: true,
                                    dateTime: event.date,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
