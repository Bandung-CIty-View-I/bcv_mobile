// import 'package:flutter/material.dart';
// // import 'services/api_service.dart';
// import 'main_warga.dart';

// void main() {
//   runApp(const MaterialApp(
//     home: LoginPage(),
//   ));
// }

// class HexColor extends Color {
//   static int _getColorFromHex(String hexColor) {
//     hexColor = hexColor.toUpperCase().replaceAll('#', '');
//     if (hexColor.length == 6) {
//       hexColor = 'FF$hexColor';
//     }
//     return int.parse(hexColor, radix: 16);
//   }

//   HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
// }

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   String _errorMessage = '';

//   Future<void> _login() async {
//     if (_formKey.currentState!.validate()) {
//       try {

//         final role = await login(
//           _emailController.text,
//           _passwordController.text,
//         );

//         if (role == 'warga') {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => Dashboard1()), // Sesuaikan dengan halaman utama warga Anda
//           );
//         }
//       } catch (e) {   
//           setState(() {
//             _errorMessage = 'invalid email';
//           }
//         );

//       }
//     } else {
//         setState(() {
//             _errorMessage = 'invalid email';
//           }
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         constraints: const BoxConstraints.expand(),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [HexColor("#253793"), HexColor("#F4D772")],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             stops: const [0.6, 1.0],
//           ),
//         ),
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 20.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const Text(
//                     'WELCOME!',
//                     style: TextStyle(
//                       fontSize: 50.0,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'BebasNeue',
//                       color: Colors.white,
//                       letterSpacing: 3.0,
//                     ),
//                   ),
//                   const SizedBox(height: 15.0),
//                   const Text(
//                     'Bandung City View I',
//                     style: TextStyle(
//                       fontSize: 20.0,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'BebasNeue',
//                       color: Colors.white,
//                       letterSpacing: 1.0,
//                     ),
//                   ),
//                   const SizedBox(height: 5.0),
//                   Image.asset(
//                     'assets/login-image.png',
//                     fit: BoxFit.contain,
//                     width: 300.0,
//                     height: 300.0,
//                   ),
//                   const SizedBox(height: 15.0),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Email',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18.0,
//                           fontFamily: 'BebasNeue',
//                         ),
//                       ),
//                       TextFormField(
//                         controller: _emailController,
//                         decoration: InputDecoration(
//                           hintText: 'Masukkan username anda...',
//                           hintStyle: const TextStyle(color: Colors.grey),
//                           filled: true,
//                           fillColor: Colors.transparent,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20.0),
//                             borderSide: const BorderSide(color: Colors.white),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20.0),
//                             borderSide: const BorderSide(color: Colors.white),
//                           ),
//                           errorBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20.0),
//                             borderSide: const BorderSide(color: Colors.red),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20.0),
//                             borderSide: const BorderSide(color: Colors.white),
//                           ),
//                         ),
//                         style: const TextStyle(color: Colors.white),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Masukkan username anda!';
//                           }
//                           return null;
//                         },
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 15.0),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Password',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18.0,
//                           fontFamily: 'BebasNeue',
//                         ),
//                       ),
//                       TextFormField(
//                         controller: _passwordController,
//                         decoration: InputDecoration(
//                           hintText: 'Masukkan password...',
//                           hintStyle: const TextStyle(color: Colors.grey),
//                           filled: true,
//                           fillColor: Colors.transparent,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20.0),
//                             borderSide: const BorderSide(color: Colors.white),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20.0),
//                             borderSide: const BorderSide(color: Colors.white),
//                           ),
//                           errorBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20.0),
//                             borderSide: const BorderSide(color: Colors.red),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20.0),
//                             borderSide: const BorderSide(color: Colors.white),
//                           ),
//                         ),
//                         style: const TextStyle(color: Colors.white),
//                         obscureText: true,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Masukkan password anda!';
//                           }
//                           return null;
//                         },
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 25.0),
//                   Center(
//                     child: ElevatedButton(
//                       onPressed: _login,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: HexColor("#FE8660"),
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                       ),
//                       child: const Text(
//                         'Sign in',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontFamily: 'Roboto',
//                           letterSpacing: 1.0,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20.0),
//                     if (_errorMessage.isNotEmpty)
//                     Text(
//                       _errorMessage,
//                       style: const TextStyle(
//                       color: Colors.red,
//                       fontSize: 16.0,
//                       fontFamily: 'Roboto',
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
