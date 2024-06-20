import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'tagihan_ipl_warga.dart';
import 'services/api_service.dart';
import 'navbar/navbar.dart';

void main() {
  runApp(MaterialApp(
    home: Dashboard1(),
  ));
}

String formatRupiah(int number) {
  final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
  return formatCurrency.format(number);
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

class Dashboard1 extends StatefulWidget {
  @override
  _Dashboard1State createState() => _Dashboard1State();
}

class _Dashboard1State extends State<Dashboard1> {
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
        body: MainContent(),
      ),
    );
  }
}

class MainContent extends StatefulWidget {
  @override
  State<MainContent> createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  final ApiService _apiService = ApiService();
  int? _bills;
  String? _name;
  List<dynamic> _schedules = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBills();
    _fetchName();
    _fetchSchedules();
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


  Future<void> _fetchBills() async {
    try {
      final bills = await _apiService.getBills();
      setState(() {
        _bills = bills;
      });
    } catch (e) {
      print('error');
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

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 20.0),
            height: 300.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.indigo[800],
            ),
            child: Stack(
              children: [
                const Positioned(
                  top : 0.0,
                  right: 10.0,
                  child: CircleAvatar(
                    radius: 40.0,
                    backgroundColor: Colors.white,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hi!',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(height: 5.0,),
                    Text(
                      _name ?? 'Loading...',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        fontSize: 30.0,
                      ),
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 2.0,
                      height: 30.0,
                    ),
                    const SizedBox(height: 5.0,),
                    const Text(
                      'Warga',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Roboto',
                        fontSize: 20.0,
                      ),
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 2.0,
                      height: 50.0,
                    ),
                    Text(
                      'Tagihan IPL bulan ini:\n${_bills != null ? formatRupiah(_bills!) : 'Loading...'}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Roboto',
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),

          Container(
            padding: const EdgeInsets.fromLTRB(24.0, 5.0, 10.0, 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.indigo[800],
            ),
            child: Row(
              children: [
                Icon(
                  MdiIcons.trashCan,
                  color: HexColor('#FFFFFF'),
                  size: 44.0,
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Wrap(
                    children: [
                      const Text(
                        'Jadwal ambil sampah:',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
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
                ),
              ],
            ),
          ),

          // Row(
          //   children: [
          //     Expanded(
          //       child: Container(
          //         padding: const EdgeInsets.fromLTRB(24.0, 5.0, 10.0, 5.0),
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(30.0),
          //           color: Colors.indigo[800],
          //         ),
          //         child: Row(
          //           children: [
          //             Icon(
          //               MdiIcons.trashCan,
          //               color: HexColor('#FFFFFF'),
          //               size: 44.0,
          //             ),
          //             const SizedBox(width: 8.0),
          //             Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Text(
          //                   'Jadwal ambil sampah:',
          //                   textAlign: TextAlign.start,
          //                   style: TextStyle(
          //                     color: Colors.white,
          //                     fontFamily: 'Roboto',
          //                     fontWeight: FontWeight.bold,
          //                     fontSize: 20.0,
          //                   ),
          //                 ),
          //                 Text(
          //                   scheduleText,
          //                   style: const TextStyle(
          //                     color: Colors.white,
          //                     fontFamily: 'Roboto',
          //                     fontSize: 22.0,
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 20.0,),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DetailIPL()));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor("#FE8660"),
                      fixedSize: const Size(0.0, 65.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      elevation: 10.0,
                      shadowColor: Colors.black.withOpacity(1.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Icon(
                          MdiIcons.receiptTextEdit,
                          color: HexColor('#253793'),
                          size: 44.0,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      const Center(
                        child: Text(
                          'Detail Tagihan IPL',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Roboto',
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}