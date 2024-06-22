import 'package:flutter/material.dart';
import 'input_ipl.dart';
import 'services/api_service.dart';
import 'statusalat_page.dart';
import 'navbar/navbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    home: DashboardAdmin(),
  ));
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

class DashboardAdmin extends StatefulWidget {
  @override
  _DashboardAdminState createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  @override
  Widget build(BuildContext context) {
    return CustomBottomNavBar(
      child: Scaffold(
        backgroundColor: HexColor('#F4EBE8'),
        appBar: AppBar(
          title: const Text(
            'BCV 1',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.indigo[800],
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: MainContentAdmin(),
        )
      ),
    );
  }
}

class MainContentAdmin extends StatefulWidget {
  @override
  State<MainContentAdmin> createState() => _MainContentAdminState();
}

class _MainContentAdminState extends State<MainContentAdmin> {
  final ApiService _apiService = ApiService();
  List<dynamic> _schedules = [];
  bool isLoading = true;
  String? _name;

  @override
  void initState() {
    super.initState();
    _fetchSchedules();
    _fetchName();
  }

  Future<void> _fetchSchedules() async {
    try {
      final List<dynamic> fetchedSchedules = await _apiService.getSchedule();
      setState(() {
        _schedules = fetchedSchedules;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchName() async {
    try {
      final name = await _apiService.getName();
      setState(() {
        _name = name;
      });
    } catch (e) {
      print('error');
    }
  }


  @override
  Widget build(BuildContext context) {
    final scheduleText = _schedules.isNotEmpty
      ? _schedules.map((schedule) => 
      '${schedule['hari']} Jam ${schedule['waktu']}').join('\n'): 'Loading...';

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 20.0),
              
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.indigo[800],
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0.0,
                    right: 10.0,
                    child: CircleAvatar(
                      radius: 40.0,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage('assets/person-icon.png'),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        _name ?? 'Loading...',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                          fontSize: 30.0,
                        ),
                      ),
                      Divider(
                        color: Colors.white,
                        thickness: 2.0,
                        height: 30.0,
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'Admin',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Roboto',
                          fontSize: 20.0,
                        ),
                      ),
                      Divider(
                        color: Colors.white,
                        thickness: 2.0,
                        height: 50.0,
                      ),
                      Text(
                        'Jadwal ambil sampah:',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Roboto',
                          fontSize: 20.0,
                        ),
                      ),
                      Text(
                        scheduleText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Roboto',
                          fontSize: 22.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(3.0, 3.0, 11.0, 0.0),
                    height: 230.0,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StatusAlat(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HexColor('#FE8660'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        elevation: 10.0,
                        shadowColor: Colors.black.withOpacity(1.0),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 30.0),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: HexColor('#FFAB90'),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Icon(
                              MdiIcons.wrenchCog,
                              size: 100.0,
                              color: Colors.black,
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.only(bottom: 16.0),
                            child: Text(
                              'Kondisi air dan alat',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10.0), // Ubah dari height ke width
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(11.0, 3.0, 5.0, 0.0),
                    height: 230.0,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InputIPL(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HexColor('#FE8660'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        elevation: 10.0,
                        shadowColor: Colors.black.withOpacity(1.0),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 30.0),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: HexColor('#FFAB90'),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Icon(
                              MdiIcons.receiptTextEdit,
                              size: 100.0,
                              color: Colors.black,
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.only(bottom: 16.0),
                            child: Text(
                              'Input IPL',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
