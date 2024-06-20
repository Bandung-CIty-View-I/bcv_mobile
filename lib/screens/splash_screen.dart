import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bcv1mobile/login_page.dart';
import 'package:bcv1mobile/main_warga.dart';
import 'package:bcv1mobile/main_admin.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _glowAnimation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _glowAnimation = ColorTween(
      begin: Colors.transparent,
      end: Colors.white,
    ).animate(_controller);

    _controller.repeat(reverse: true);
    
    _navigateToNextPage();
  }

  Future<void> _navigateToNextPage() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? isLoggedIn = prefs.getBool('isLoggedIn');

    Future.delayed(const Duration(seconds: 2), () {
      if (isLoggedIn == true) {
        // Navigate to the main page depending on the user role
        final String? role = prefs.getString('role');
        if (role == 'warga') {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => Dashboard1(),
          ));
        } else if (role == 'admin') {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => DashboardAdmin(),
          ));
        }
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => const LoginPage(),
        ));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [HexColor("#253793"), HexColor("#F4D772")],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.6, 1.0],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _glowAnimation,
                builder: (context, child) {
                  return Icon(
                    MdiIcons.homeCity,
                    color: _glowAnimation.value,
                    size: 100.0,
                  );
                },
              ),
              const SizedBox(height: 10.0),
              AnimatedBuilder(
                animation: _glowAnimation,
                builder: (context, child) {
                  return Text(
                    'Bandung City View I\nMobile',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _glowAnimation.value,
                      fontFamily: 'BebasNeue',
                      fontSize: 45.0,
                      fontStyle: FontStyle.italic,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}