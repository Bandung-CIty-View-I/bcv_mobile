import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';

void main() {
  runApp(const MaterialApp(
    home: DetailIPL(),
  ));
}

class DetailIPL extends StatefulWidget {
  const DetailIPL({super.key});

  @override
  _DetailIPLstate createState() => _DetailIPLstate();
}

class _DetailIPLstate extends State<DetailIPL> {
  String? selectedYear;
  String? selectedMonth;
  String meterAwal = "";
  String meterAkhir = "";
  String totalTunggakan = "";
  String totalTagihan = "";

  final List<String> years = List.generate(10, (index) => (2020 + index).toString());
  final List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June', 
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  void fetchData(String year, String month) async {
    final response = await http.get(Uri.parse('https://api.example.com/tagihan?year=$year&month=$month'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        meterAwal = data['meterAwal'].toString();
        meterAkhir = data['meterAkhir'].toString();
        totalTunggakan = data['totalTunggakan'].toString();
        totalTagihan = data['totalTagihan'].toString();
      });
    } else {
      // Jika gagal mengambil data dari API
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#F4EBE8'),
      appBar: AppBar(
        title: const Text(
          'Detail Tagihan IPL',
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
              hint: const Text("Select Year"),
              value: selectedYear,
              items: years.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedYear = newValue;
                  if (selectedYear != null && selectedMonth != null) {
                    fetchData(selectedYear!, selectedMonth!);
                  }
                });
              },
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              hint: const Text("Select Month"),
              value: selectedMonth,
              items: months.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedMonth = newValue;
                  if (selectedYear != null && selectedMonth != null) {
                    fetchData(selectedYear!, selectedMonth!);
                  }
                });
              },
            ),
            const SizedBox(height: 20),
            Expanded(
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
                        Icon(MdiIcons.water),
                        const SizedBox(width: 10),
                        const Text(
                          "Meter Awal",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      meterAwal,
                      style: const TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Divider(color: Colors.black),
                    const SizedBox(height: 20.0),
                    Row(
                      children: [
                        Icon(MdiIcons.waterCheck),
                        const SizedBox(width: 10),
                        const Text(
                          "Meter Akhir",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      meterAkhir,
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
                          "Total Tunggakan",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      totalTunggakan,
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
                          "Total Tagihan IPL",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      totalTagihan,
                      style: const TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}