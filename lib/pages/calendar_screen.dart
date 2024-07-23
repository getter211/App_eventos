// ignore_for_file: use_full_hex_values_for_flutter_colors, unnecessary_import, avoid_unnecessary_containers, use_build_context_synchronously, prefer_const_constructors, deprecated_member_use, unused_local_variable, unused_element, sized_box_for_whitespace, prefer_final_fields, unused_field, unrelated_type_equality_checks, unnecessary_string_interpolations, avoid_print, prefer_const_literals_to_create_immutables, unnecessary_nullable_for_final_variable_declarations, avoid_web_libraries_in_flutter, body_might_complete_normally_nullable, non_constant_identifier_names, no_leading_underscores_for_local_identifiers, duplicate_import

import 'dart:convert';
import 'dart:typed_data';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_eventos/dtos/response/get_all_events_response.dart';
import 'package:proyecto_eventos/pages/home_screen.dart';
import 'package:proyecto_eventos/widgets/forms_createEvent.dart';

import 'package:responsive_grid/responsive_grid.dart';
import 'dart:async';

import 'dart:convert';
import 'dart:typed_data';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:responsive_grid/responsive_grid.dart';
import 'dart:async';

class ViewCalendarioEvento extends StatefulWidget {
  static const String routeName = "v_calendario";

  const ViewCalendarioEvento({
    super.key,
  });

  @override
  State<ViewCalendarioEvento> createState() => _ViewCalendarioEventoState();
}

class _ViewCalendarioEventoState extends State<ViewCalendarioEvento> with TickerProviderStateMixin {
  int myUSUARIOAID = 0;
  String userName = 'Juan Pérez';
  String empresaName = 'Mi Empresa';

  EventController _eventController = EventController();
  String _currentView = 'Month'; // Inicialmente muestra la vista del mes
  double myWidthDialog = 0.0;
  double widthTabla = 0.0;

  bool filterDetected = false;
  bool isLoading = true;
  int anioActual = DateTime.now().year;

  GlobalKey keySucursal = GlobalKey();
  GlobalKey keyEsatus = GlobalKey();
  GlobalKey keyFechainicial = GlobalKey();
  GlobalKey keyFechafinal = GlobalKey();
  FocusNode sucursalFocusNode = FocusNode();
  FocusNode estatusFocusNode = FocusNode();
  FocusNode fechainicialFocusNode = FocusNode();
  FocusNode vehiculoFocusNode = FocusNode();
  FocusNode fechafinalFocusNode = FocusNode();
  TextEditingController fechaInicialController = TextEditingController();
  TextEditingController fechaFinalController = TextEditingController();
  TextEditingController folioController = TextEditingController();
  TextEditingController codigoController = TextEditingController();
  TextEditingController ordenServicioController = TextEditingController();
  TextEditingController vehiculoController = TextEditingController();
  TextEditingController findControllerActividades = TextEditingController();
  TextEditingController findControllerPlaca = TextEditingController();
  TextEditingController findNoEconomico = TextEditingController();

  bool advanced_Filters = false;

  Color colorDrawerSelect = const Color.fromARGB(255, 0, 0, 0);
  Color colorDrawer = Colors.grey[850] as Color;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<MonthViewState> _monthViewStateKey = GlobalKey<MonthViewState>();

  late TabController _tabController;
  bool isCalendar = true;

  var lanCL = <String, Map<String, String>>{
    'en': {},
    'es': {},
  };
  List<GetAllEventsResponseDto> _events = [];

  @override
  void initState() {
    super.initState();
    initFecha();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    final response = await http.get(Uri.parse('http://localhost:3000/api/events/all'));

    if (response.statusCode == 200) {
      final List<dynamic> eventList = json.decode(response.body);
      setState(() {
        _events = eventList.map((json) => GetAllEventsResponseDto.fromJson(json)).toList();
      });
      for (var event in _events) {
        _eventController.add(
          CalendarEventData(
            event: event,
            title: event.name,
            description: event.description,
            date: DateTime.parse(event.date.toString()),
            startTime: DateTime.parse(event.date.toString()),
            endTime: DateTime.parse(event.date.toString()),
            color: const Color.fromARGB(
                255, 0, 0, 0), // Puedes asignar colores según el tipo de evento
          ),
        );
      }
    } else {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load events')),
      );
    }
  }

  DateTime convertirFormatoFecha(String fecha) {
    DateTime fechaParseada = DateTime.parse(fecha);
    return fechaParseada;
  }

  String convertirFormatoFechaString(String fecha) {
    if (fecha.isEmpty || fecha == '') {
      return " - ";
    }

    DateTime formatoFecha = DateTime.parse(fecha);
    String fechaFormateada = DateFormat('yyyy-MM-dd').format(formatoFecha);
    return fechaFormateada;
  }

  void initFecha() {
    DateTime fechaInicial = DateTime(anioActual, 1, 1);
    DateTime fechaFinal = DateTime(anioActual, 12, 31);
    fechaInicialController.text = DateFormat('yyyy-MM-dd').format(fechaInicial).toString();
    fechaFinalController.text = DateFormat('yyyy-MM-dd').format(fechaFinal).toString();
  }

  @override
  void dispose() {
    sucursalFocusNode.dispose();
    estatusFocusNode.dispose();
    fechainicialFocusNode.dispose();
    vehiculoFocusNode.dispose();
    fechafinalFocusNode.dispose();
    super.dispose();
  }

  void changeView(String view) {
    setState(() {
      _currentView = view;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget calendarView;
    switch (_currentView) {
      case 'Day':
        calendarView = DayView(
          onEventTap: (events, date) => calendarTapped(
              context, events, date, widthTabla, myWidthDialog, userName, empresaName),
          headerStyle: HeaderStyle(
            decoration: BoxDecoration(color: const Color.fromARGB(255, 0, 0, 0)),
            headerTextStyle: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          dateStringBuilder: (date, {secondaryDate}) =>
              DateFormat('EEEE, d MMMM', 'es_ES').format(date),
          controller: _eventController,
        );
        break;
      case 'Week':
        calendarView = WeekView(
          onEventTap: (events, date) => calendarTapped(
              context, events, date, widthTabla, myWidthDialog, userName, empresaName),
          headerStringBuilder: (DateTime date, {DateTime? secondaryDate}) =>
              '${DateFormat('d \'de\' MMMM \'del\' yyyy', 'es_ES').format(date)} al ${secondaryDate != null ? DateFormat('d \'de\' MMMM \'del\' yyyy', 'es_ES').format(secondaryDate) : ''}',
          headerStyle: HeaderStyle(
            decoration: BoxDecoration(color: Colors.white),
            headerTextStyle: TextStyle(
              fontSize: 20,
              color: const Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.bold,
              backgroundColor: Colors.white,
            ),
          ),
          controller: _eventController,
        );
        break;
      case 'Month':
      default:
        calendarView = MonthView(
          key: _monthViewStateKey,
          borderColor: Colors.grey.shade100,
          cellAspectRatio: 3,
          controller: _eventController,
          onCellTap: (events, date) => calendarTapped(
              context, events, date, widthTabla, myWidthDialog, userName, empresaName),
          dateStringBuilder: (date, {secondaryDate}) => DateFormat('d').format(date),
          headerStyle: HeaderStyle(
            headerTextStyle: TextStyle(
              fontSize: 20,
              color: const Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.bold,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
          minMonth: DateTime(2020),
          maxMonth: DateTime(3000),
          initialMonth: DateTime(DateTime.now().year, DateTime.now().month),
        );
        break;
    }

    if (!isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Calendario',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color.fromARGB(255, 116, 114, 114),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        key: _scaffoldKey,
        body: Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
          child: SizedBox(
            child: MouseRegion(
              child: SafeArea(
                child: CalendarControllerProvider(
                  controller: _eventController,
                  child: calendarView,
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  void calendarTapped(BuildContext context, List<CalendarEventData<Object?>> events,
      DateTime details, double widthd, double myWidthDialog, String userName, String empresaName) {
    // Filtrar eventos para la fecha seleccionada
    var selectedEvents = events
        .where((event) =>
            event.date.year == details.year &&
            event.date.month == details.month &&
            event.date.day == details.day)
        .toList();

    if (selectedEvents.isNotEmpty) {
      String fechaFormateada = DateFormat('dd/MM/yyyy').format(details);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            alignment: Alignment.center,
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            elevation: 0.0,
            content: SingleChildScrollView(
              child: Container(
                width: myWidthDialog,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                      ),
                      child: ListTile(
                        visualDensity: VisualDensity.compact,
                        leading: Text(
                          "Fecha: $fechaFormateada",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.cancel, color: Colors.white),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          for (var event in selectedEvents)
                            Column(
                              children: [
                                Container(
                                  color: const Color(0xFFFFFFFF),
                                  padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                                  alignment: Alignment.centerLeft,
                                  child: ListTile(
                                    visualDensity: VisualDensity.compact,
                                    title: Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Título: ${event.title}',
                                                  style: const TextStyle(
                                                      fontSize: 16.0, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => AddEvents(
                                                                  event: event.event
                                                                      as GetAllEventsResponseDto,
                                                                  isCreate: true,
                                                                )));
                                                  },
                                                  icon: const Icon(Icons.more_vert)),
                                            ],
                                          ),
                                          const Divider(
                                            color: Colors.grey,
                                          ),
                                          Text(
                                            'Descripción: ${event.description}',
                                            style: const TextStyle(
                                                fontSize: 14.0, color: Color(0xFF4F4F4F)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const Divider(
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sin eventos para este día: ${DateFormat('dd/MM/yyyy').format(details)}'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
