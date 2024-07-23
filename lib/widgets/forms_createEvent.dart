import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_eventos/config/app_sources.dart';
import 'package:proyecto_eventos/dtos/response/get_all_events_response.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto_eventos/pages/home_screen.dart';
import 'package:proyecto_eventos/providers/event_providers.dart';
import 'package:proyecto_eventos/widgets/my_dialogs.dart';
import 'dart:convert';

import 'package:responsive_grid/responsive_grid.dart';

class Estatus {
  final int id;
  final String name;
  // por quie algo se colo por el codium
  Estatus(this.id, this.name);

  @override
  String toString() {
    return name;
  }
}

class AddEvents extends StatefulWidget {
  final bool isCreate;
  final GetAllEventsResponseDto? event;
  final bool isEdit;
  final bool show;

  const AddEvents(
      {super.key, this.event, this.isCreate = true, this.isEdit = false, this.show = true});

  @override
  State<AddEvents> createState() => _AddEventsState();
}

class _AddEventsState extends State<AddEvents> {
  bool isLoading = true;
  bool userFound = false;
  final logger = Logger();
  final mapController = MapController();
  final _formKey = GlobalKey<FormState>();

  final format = DateFormat("yyyy-MM-dd");
  final timeFormat = DateFormat("HH:mm a");
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _guestsController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  List<User> _users = [];
  double lat = 0.0;
  double long = 0.0;
  Estatus? _selectedStatus;

  final List<Estatus> estatusList = [
    Estatus(1, 'active'),
    Estatus(2, 'inactive'),
    Estatus(3, 'cancelled'),
    Estatus(4, 'completed')
  ];

  @override
  void initState() {
    super.initState();
    _determinePosition().then((position) {
      setState(() {
        lat = position.latitude;
        long = position.longitude;
      });
      mapController.move(LatLng(lat, long), 15.0);
    });
    intDataUser();
  }

  Future<void> intDataUser() async {
    final response = await http.get(Uri.parse('http://localhost:3000/api/auth/users'));

    if (response.statusCode == 200) {
      final List<dynamic> eventList = json.decode(response.body);
      setState(() {
        _users = eventList.map((json) => User.fromJson(json)).toList();
      });
    } else {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load Users')),
      );
    }
    if (widget.event != null) {
      _nameController.text = widget.event!.name;
      _dateController.text = format.format(widget.event!.date);
      // Verifica si `widget.event!.time` es un `DateTime` o un `String`
      if (widget.event!.time is DateTime) {
        _timeController.text = timeFormat.format(widget.event!.time as DateTime);
      } else if (widget.event!.time is String) {
        // Asumiendo que el String está en formato HH:mm
        try {
          DateTime parsedTime = DateFormat("HH:mm").parse(widget.event!.time as String);
          _timeController.text = timeFormat.format(parsedTime);
        } catch (e) {
          // Maneja el error si el formato es incorrecto
          _timeController.text = '';
        }
      }
      _descriptionController.text = widget.event!.description;
      _locationController.text = widget.event!.location;
      _costController.text = widget.event!.cost.toString();

      _guestsController.text = widget.event!.guest;
      _selectedStatus = estatusList.firstWhere((element) => element.name == widget.event!.status);

      setState(() {
        lat = double.parse(widget.event!.latitude);
        long = double.parse(widget.event!.longitude);
        mapController.move(LatLng(lat, long), 15.0);
      });
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> saveData() async {
    if (widget.event != null) {
      // Update the event
      final response =
          await http.put(Uri.parse('http://localhost:3000/api/events/${widget.event!.id}'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({
                "name": _nameController.text,
                "date": formatDate(_dateController.text),
                "time": formatTime(_timeController.text),
                "description": _descriptionController.text,
                "location": _locationController.text,
                "latitude": lat,
                "longitude": long,
                "status": _selectedStatus?.name,
                "createdBy": 1,
                "guest": _guestsController.text,
                "cost": int.parse(_costController.text),
              }));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Evento actualizado con éxito')),
        );
        // Recargar la información del evento
        await intDataUser();

        final eventProvider = Provider.of<EventProvider>(context, listen: false);
        eventProvider.refreshEvents();
        xpop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al actualizar el evento')),
        );
      }
    } else {
      // Create the event
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/events/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": _nameController.text,
          "date": formatDate(_dateController.text),
          "time": formatTime(_timeController.text),
          "description": _descriptionController.text,
          "location": _locationController.text,
          "latitude": lat,
          "longitude": long,
          "status": _selectedStatus?.name,
          "createdBy": 1,
          "guest": _guestsController.text,
          "cost": int.parse(_costController.text),
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Evento creado con éxito')),
        );
        final eventProvider = Provider.of<EventProvider>(context, listen: false);
        eventProvider.refreshEvents();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al crear el evento')),
        );
      }
    }
  }

  void xpop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  String findNameUser(int id) {
    if (id != null || id > 0) {
      User user = _users.firstWhere((element) => element.id == id);
      return user.username;
    }
    return 'Aun no hay invitados';
  }

  void updatePoint(LatLng point) {
    setState(() {
      lat = point.latitude;
      long = point.longitude;
    });
  }

  String formatTime(String timeString) {
    try {
      // Parse the string based on the format you provided
      final DateFormat inputFormat = DateFormat('HH:mm a');
      final DateTime dateTime = inputFormat.parse(timeString);

      // Format it to the desired output format
      final DateFormat outputFormat = DateFormat('hh:mm a');
      return outputFormat.format(dateTime);
    } catch (e) {
      return 'Hora inválida';
    }
  }

  String formatDate(String dateString) {
    try {
      final DateTime dateTime = DateTime.parse(dateString);
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      return formatter.format(dateTime);
    } catch (e) {
      return 'Fecha inválida';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Evento')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      enabled: widget.show,
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Nombre del evento',
                        labelStyle: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                        hintText: 'Ingresa el nombre del evento',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: const Icon(Icons.event, color: Colors.black),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.black, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El nombre es requerido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      enabled: widget.show,
                      controller: _locationController,
                      decoration: InputDecoration(
                        labelText: 'Lugar',
                        labelStyle: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                        hintText: 'Ingresa el lugar del evento',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: const Icon(Icons.location_on, color: Colors.black),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.black, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El lugar es requerido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 300,
                      child: Stack(
                        children: [
                          FlutterMap(
                            mapController: mapController,
                            options: MapOptions(
                              initialCenter: LatLng(lat, long),
                              initialZoom: 15,
                              minZoom: 3,
                              onTap: (tapPosition, point) {
                                updatePoint(point);
                              },
                            ),
                            children: [
                              TileLayer(
                                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                tileProvider: CancellableNetworkTileProvider(),
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    width: 50,
                                    height: 50,
                                    point: LatLng(lat, long),
                                    child: const Icon(
                                      Icons.location_on,
                                      size: 30,
                                      color: Color.fromARGB(255, 218, 3, 3),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ResponsiveGridRow(rowSegments: 12, children: [
                      ResponsiveGridCol(
                        xl: 4,
                        lg: 4,
                        md: 4,
                        sm: 4,
                        xs: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DateTimeField(
                            enabled: widget.show,
                            format: format,
                            controller: _dateController,
                            decoration: InputDecoration(
                              labelText: 'Fecha',
                              labelStyle: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                              hintText: 'Selecciona la fecha del evento',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(color: Colors.black, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
                              ),
                            ),
                            onShowPicker: (context, currentValue) {
                              return showDatePicker(
                                context: context,
                                firstDate: DateTime.now(),
                                initialDate: currentValue ?? DateTime.now(),
                                lastDate: DateTime(2100),
                              );
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Por favor selecciona la fecha del evento';
                              }
                              if (value.isBefore(DateTime.now())) {
                                return 'La fecha del evento debe ser mayor a la fecha actual';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      ResponsiveGridCol(
                        xl: 4,
                        lg: 4,
                        md: 4,
                        sm: 4,
                        xs: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DateTimeField(
                            enabled: widget.show,
                            format: timeFormat,
                            controller: _timeController,
                            decoration: InputDecoration(
                              labelText: 'Hora',
                              labelStyle: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                              hintText: 'Selecciona la hora del evento',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(color: Colors.black, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'La hora es requerida';
                              }
                              return null;
                            },
                            onShowPicker: (context, currentValue) async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                                builder: (BuildContext context, Widget? child) {
                                  return child!;
                                },
                              );
                              return DateTimeField.convert(time);
                            },
                          ),
                        ),
                      ),
                      ResponsiveGridCol(
                        xl: 4,
                        lg: 4,
                        md: 4,
                        sm: 4,
                        xs: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            enabled: widget.show,
                            controller: _costController,
                            decoration: InputDecoration(
                              labelText: 'Costo',
                              labelStyle: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                              hintText: 'Ingresa el costo del evento',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              prefixIcon: const Icon(Icons.attach_money, color: Colors.black),
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(color: Colors.black, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[1-9][0-9]*')),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'El costo es requerido';
                              }
                              final numValue = int.tryParse(value);
                              if (numValue == null || numValue <= 1) {
                                return 'El costo debe ser mayor a 1';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ]),
                    TextFormField(
                      enabled: widget.show,
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Descripción',
                        labelStyle: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                        hintText: 'Ingresa una breve descripción del evento',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: const Icon(Icons.description, color: Colors.black),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.black, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La descripción es requerida';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      enabled: widget.show,
                      controller: _guestsController,
                      decoration: InputDecoration(
                        labelText: 'Invitado especial',
                        labelStyle: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                        hintText: 'Ingresa el nombre del invitado especial (opcional)',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: const Icon(Icons.person, color: Colors.black),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.black, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<Estatus>(
                      value: _selectedStatus,
                      items: estatusList.map((Estatus status) {
                        return DropdownMenuItem<Estatus>(
                          value: status,
                          child: Text(status.name),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Estatus',
                        labelStyle: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.black, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
                        ),
                      ),
                      onChanged: widget.show
                          ? (Estatus? newValue) {
                              setState(() {
                                _selectedStatus = newValue;
                              });
                            }
                          : null,
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor, seleccione el estatus del evento';
                        }
                        return null;
                      },
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8.0),
                        const Text(
                          'Registros de Invitados:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4.0),
                        widget.event != null
                            ? Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ListView.builder(
                                  itemCount: widget.event?.registrations.length ?? 0,
                                  itemBuilder: (context, index) {
                                    try {
                                      Registration place = widget.event!.registrations[index];
                                      return ListTile(
                                        title: Text(findNameUser(place.userId)),
                                      );
                                    } catch (e) {
                                      return const ListTile(
                                        title: Text(''),
                                      );
                                    }
                                  },
                                ),
                              )
                            : Container()
                      ],
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: 400,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final event = {
                              "name": _nameController.text,
                              "date": _dateController.text,
                              "time": _timeController.text,
                              "description": _descriptionController.text,
                              "special_guests": _guestsController.text,
                              "cost": _costController.text,
                              "latitude": lat,
                              "longitude": long,
                              "location_name": _locationController.text,
                              "status": _selectedStatus?.name,
                              "createdBy": 3,
                            };
                            logger.d(event);
                            saveData();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(16),
                        ),
                        child: Text(
                          widget.event != null ? 'Editar evento' : 'Crear evento',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
