import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_eventos/dtos/response/get_all_events_response.dart';
import 'package:proyecto_eventos/providers/event_providers.dart';
import 'package:proyecto_eventos/providers/user_provider.dart';
import 'package:proyecto_eventos/widgets/card_event.dart';
import 'package:proyecto_eventos/widgets/forms_createEvent.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importa tu widget CardEvent

class UserEventsScreen extends StatefulWidget {
  const UserEventsScreen({super.key});

  @override
  _UserEventsScreenState createState() => _UserEventsScreenState();
}

class _UserEventsScreenState extends State<UserEventsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<GetAllEventsResponseDto> _eventosTemp = [];
  List<GetAllEventsResponseDto> _eventosOriginal = [];
  int _filter = 0;
  int? _userId = 0;
  Future<void> getUserIdFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt('userId');
  }

  @override
  void initState() {
    getUserIdFromPreferences();
    getUserId();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      // Solo llama fetchUserEvents si el usuario está autenticado
      if (userProvider.userLogin != null) {
        eventProvider.fetchUserEvents(userProvider.userLogin!.hashCode); // Usa el ID del usuario
      }
    });
  }

  Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt('userIdx') ?? 0;
    setState(() {});
  }

  void _filterEvents(int filter) {
    setState(() {
      _filter = filter;
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

    List<GetAllEventsResponseDto> eventos = eventProvider.events;
    _eventosOriginal = [...eventos];

    for (GetAllEventsResponseDto element in _eventosOriginal) {
      if (element.user.id == _userId) {
        _eventosTemp.add(element);
      }
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Tus eventos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
                                    isEdit: true,
                                    onTap: (int value) {
                                      // Maneja el evento de la tarjeta
                                      if (value == 1) {
                                        // Actualización o acción
                                      }
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
