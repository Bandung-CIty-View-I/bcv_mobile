import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'login_page.dart';
import 'navbar/navbar.dart';
import 'main_admin.dart';
import 'main_warga.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');
  final role = prefs.getString('role');

  Widget initialPage;

  if (token == null || role == null) {
    initialPage = LoginPage();
  } else {
    if (role == 'warga') {
      initialPage = CustomBottomNavBar(child: Dashboard1());
    } else if (role == 'admin') {
      initialPage = CustomBottomNavBar(child: DashboardAdmin());
    } else {
      initialPage = LoginPage();
    }
  }

  runApp(MyApp(initialPage: initialPage));
}

class MyApp extends StatelessWidget {
  final Widget initialPage;

  const MyApp({required this.initialPage, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}