import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:proyecto_eventos/pages/calendar_screen.dart';
import 'package:proyecto_eventos/pages/create_event.dart';
import 'package:proyecto_eventos/pages/detail_event_screen.dart';
import 'package:proyecto_eventos/pages/home_screen.dart';
import 'package:proyecto_eventos/pages/login_screen.dart';
import 'package:proyecto_eventos/pages/register_screen.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_eventos/providers/event_providers.dart';
import 'package:proyecto_eventos/providers/place_search.dart';
import 'package:proyecto_eventos/providers/user_provider.dart';

void main() {
 
  initializeDateFormatting('es_ES', null).then((_) {
    runApp(const MainApp());
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
         ChangeNotifierProvider(
           create: (_) => EventProvider(),
        ),
        
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomeScreen(),
          '/create_event': (context) => const CreateEventScreen(),
          '/calendar': (context) => const ViewCalendarioEvento(),
          '/detail_event': (context) => DetailEventScreen(),
        },
      ),
    );
  }
}
