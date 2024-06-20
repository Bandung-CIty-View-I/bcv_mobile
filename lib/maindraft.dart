// import 'package:flutter/material.dart';
// import 'package:pro_tav1/input_ipl.dart';
// import 'package:pro_tav1/statusalat_page.dart';
// import 'otheradmin_menu.dart';
// import 'login_page.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'BCV I Mobile',
//       theme: ThemeData(
//         primarySwatch: Colors.indigo,
//       ),
//       initialRoute: '/login',
//       routes: {
//         '/login': (context) => const LoginPage(),
//       }
//     );
//   }
// }


// class HexColor extends Color {
//   static int _getColorFromHex(String hexColor) {
//     hexColor = hexColor.toUpperCase().replaceAll('#', '');
//     if (hexColor.length == 6) {
//       hexColor = 'FF' + hexColor;
//     }
//     return int.parse(hexColor, radix: 16);
//   }

//   HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
// }

// class DashboardAdmin extends StatefulWidget {
//   const DashboardAdmin({super.key});

//   @override
//   _DashboardAdminState createState() => _DashboardAdminState();
// }

// class _DashboardAdminState extends State<DashboardAdmin> {
//   int _selectedIndex = 0;
//   final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

//   void _onItemTapped(int index) {
//   setState(() {
//     _selectedIndex = index;
//   });

//   if (index == 1) {
//     _navigatorKey.currentState!.push(
//       MaterialPageRoute(builder: (context) => OtherMenuAdmin()),
//     );
//   } else if (index == 0) {
//     _navigatorKey.currentState!.popUntil((route) => route.isFirst);
//   }
// }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: HexColor('#F4EBE8'),
//       appBar: AppBar(
//         title: const Text(
//           'BCV 1',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.indigo[800],
//         elevation: 0.0,
//       ),
//       body: Navigator(
//         key: _navigatorKey,
//         onGenerateRoute: (settings) {
//           return MaterialPageRoute(
//             builder: (context) => MainContentAdmin(),
//           );
//         },
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//               icon: ImageIcon(AssetImage('assets/home-icon.png')),
//               label: 'Home'),
//           BottomNavigationBarItem(
//               icon: ImageIcon(AssetImage('assets/threedots-icon.png')),
//               label: 'Other'),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.indigo[800],
//         unselectedItemColor: Colors.grey,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }

// class MainContentAdmin extends StatefulWidget {
//   @override
//   State<MainContentAdmin> createState() => _MainContentAdminState();
// }

// class _MainContentAdminState extends State<MainContentAdmin> {
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 20.0),
//               height: 300.0,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(30.0),
//                 color: Colors.indigo[800],
//               ),
//               child: const Stack(
//                 children: [
//                   Positioned(
//                     top: 0.0,
//                     right: 10.0,
//                     child: CircleAvatar(
//                       radius: 40.0,
//                       backgroundColor: Colors.white,
//                     ),
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Hi!',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontFamily: 'Roboto',
//                           fontSize: 20.0,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 5.0,
//                       ),
//                       Text(
//                         'Butar Aja',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontFamily: 'Roboto',
//                           fontSize: 30.0,
//                         ),
//                       ),
//                       Divider(
//                         color: Colors.white,
//                         thickness: 2.0,
//                         height: 30.0,
//                       ),
//                       SizedBox(
//                         height: 5.0,
//                       ),
//                       Text(
//                         'Admin',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontFamily: 'Roboto',
//                           fontSize: 20.0,
//                         ),
//                       ),
//                       Divider(
//                         color: Colors.white,
//                         thickness: 2.0,
//                         height: 50.0,
//                       ),
//                       Text(
//                         'Tagihan IPL bulan ini: \n Rp.300.000,00',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontFamily: 'Roboto',
//                           fontSize: 20.0,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20.0),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Expanded(
//                   child: Container(
//                     padding: const EdgeInsets.fromLTRB(3.0, 3.0, 11.0, 0.0),
//                     height: 230.0,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => const StatusAlat()));
//                       },
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: HexColor('#FE8660'),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30.0),
//                           )),
//                       child: const Column(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Text(
//                             'Kondisi air dan alat',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontFamily: 'Roboto',
//                               fontSize: 16.0,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10.0),
//                 Expanded(
//                   child: Container(
//                     padding: const EdgeInsets.fromLTRB(11.0, 3.0, 5.0, 0.0),
//                     height: 230.0,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => const InputIPL()));
//                       },
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: HexColor('#FE8660'),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30.0),
//                           )),
//                       child: const Column(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Text(
//                             'IPL',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontFamily: 'Roboto',
//                               fontSize: 16.0,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
