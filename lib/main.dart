import 'package:flutter/material.dart';
import 'package:hotel_reservation_app/dashboard_page.dart';
import 'package:hotel_reservation_app/login_page.dart';
import 'package:hotel_reservation_app/room_list_page.dart';
import 'package:hotel_reservation_app/signup_page.dart';

void main() {
  runApp(const HotelReservationApp());
}

class HotelReservationApp extends StatelessWidget {
  const HotelReservationApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryTeal = Color(0xFF0F4C4C);
    const secondaryAmber = Color(0xFFC88A3B);
    const warmSurface = Color(0xFFF7F6F2);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryTeal,
      primary: primaryTeal,
      secondary: secondaryAmber,
      surface: warmSurface,
      brightness: Brightness.light,
    );

    return MaterialApp(
      title: 'Borneo Crest Hotel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: warmSurface,
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryTeal,
          foregroundColor: Colors.white,
          centerTitle: false,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryTeal, width: 1.8),
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 1.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/rooms': (context) => const RoomListPage(),
      },
    );
  }
}
