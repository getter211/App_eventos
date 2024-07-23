import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto_eventos/dtos/response/get_all_events_response.dart';

class EventProvider extends ChangeNotifier {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<GetAllEventsResponseDto> _events = [];
  bool _isLoading = false;

  List<GetAllEventsResponseDto> get events => _events;
  bool get isLoading => _isLoading;

  EventProvider() {
    fetchEvents();
  }
  Future<void> refreshEvents() async {
    await fetchEvents();
  }
  Future<void> fetchEvents() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('http://localhost:3000/api/events/all'));

      if (response.statusCode == 200) {
        final List<dynamic> eventList = json.decode(response.body);
        _events = eventList.map((json) => GetAllEventsResponseDto.fromJson(json)).toList();
        notifyListeners();
      } else {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('Failed to load events')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
        const SnackBar(content: Text('An error occurred')),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserEvents(int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('http://localhost:3000/api/events/$userId'));

      if (response.statusCode == 200) {
        final List<dynamic> eventList = json.decode(response.body);
        _events = eventList.map((json) => GetAllEventsResponseDto.fromJson(json)).toList();
        notifyListeners();
      } else {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('Failed to load user events')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
        const SnackBar(content: Text('An error occurred')),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
