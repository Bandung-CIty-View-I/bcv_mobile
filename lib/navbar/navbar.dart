import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'main_warga.dart';
// import 'main_admin.dart';
import '../other_menu.dart';
import '../otheradmin_menu.dart';

class CustomBottomNavBar extends StatefulWidget {
  final Widget child;

  const CustomBottomNavBar({required this.child, Key? key}) : super(key: key);

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _selectedIndex = 0;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  String? role;

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  Future<void> _loadRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getString('role');
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (role == 'admin') {
      if (index == 1) {
        _navigatorKey.currentState!.push(
            MaterialPageRoute(builder: (context) => const OtherMenuAdmin()));
      } else if (index == 0) {
        _navigatorKey.currentState!.popUntil((route) => route.isFirst);
      }
    } else if (role == 'warga') {
      if (index == 1) {
        _navigatorKey.currentState!.push(
            MaterialPageRoute(builder: (context) => const OtherMenu()));
      } else if (index == 0) {
        _navigatorKey.currentState!.popUntil((route) => route.isFirst);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: _navigatorKey,
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => widget.child,
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/home-icon.png')),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/threedots-icon.png')),
              label: 'Other'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.indigo[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
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
