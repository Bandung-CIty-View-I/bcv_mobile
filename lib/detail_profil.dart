import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'services/api_service.dart';

void main() {
  runApp(const MaterialApp(
    home: DetailProfil(),
  ));
}

class DetailProfil extends StatefulWidget {
  const DetailProfil({super.key});

  @override
  _DetailProfilState createState() => _DetailProfilState();
}

class _DetailProfilState extends State<DetailProfil> {
  String? selectedResident;
  String email = "";
  String noRumah = "";
  String tagihanIPL = "";
  String tunggakan = "";
  List<String> residents = [];

  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    fetchResidents();
  }

  void fetchResidents() async {
    try {
      final fetchedResidents = await apiService.fetchResidents();
      setState(() {
        residents = fetchedResidents;
      });
    } catch (e) {
      // Handle error
      print(e);
    }
  }

  void fetchResidentDetails(String residentName) async {
    try {
      final details = await apiService.fetchResidentDetails(residentName);
      setState(() {
        email = details['email'].toString();
        noRumah = details['noRumah'].toString();
        tagihanIPL = details['tagihanIPL'].toString();
        tunggakan = details['tunggakan'].toString();
      });
    } catch (e) {
      // Handle error
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#F4EBE8'),
      appBar: AppBar(
        title: const Text(
          'Profil Warga',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo[800],
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            MdiIcons.arrowLeft,
            color: Colors.white,
            ),
          iconSize: 40.0,
          alignment: Alignment.topLeft,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DropdownButton<String>(
              hint: const Text("Pilih Nama Warga"),
              value: selectedResident,
              items: residents.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedResident = newValue;
                  if (selectedResident != null) {
                    fetchResidentDetails(selectedResident!);
                  }
                });
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.grey[400],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(MdiIcons.email),
                          const SizedBox(width: 10),
                          const Text(
                            "Email",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Divider(color: Colors.black),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          Icon(MdiIcons.home),
                          const SizedBox(width: 10),
                          const Text(
                            "No. Rumah",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        noRumah,
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Divider(color: Colors.black),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          Icon(MdiIcons.currencyUsd),
                          const SizedBox(width: 10),
                          const Text(
                            "Tagihan IPL",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        tagihanIPL,
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Divider(color: Colors.black),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          Icon(MdiIcons.currencyUsd),
                          const SizedBox(width: 10),
                          const Text(
                            "Tunggakan",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        tunggakan,
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
