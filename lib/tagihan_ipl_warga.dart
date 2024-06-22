import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'services/api_service.dart';
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
  final ApiService apiService = ApiService();
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
    // Konversi nama bulan menjadi dua digit angka
    final monthIndex = months.indexOf(month) + 1; // Index dimulai dari 0
    final monthString = monthIndex.toString().padLeft(2, '0');
    final yearMonth = year + monthString;
    
  //   try {
  //     // final data = await apiService.getBillDetails(yearMonth);
  //     int tunggakan = 0;
  //     data.forEach((key, value) {
  //       if (key.startsWith('tunggakan_')) {
  //         tunggakan += int.parse(value.toString());
  //       }
  //     });
  //     setState(() {
  //       meterAwal = data['meter_awal'].toString();
  //       meterAkhir = data['meter_akhir'].toString();
  //       totalTunggakan = tunggakan.toString();
  //       totalTagihan = data['total_tag'].toString();
  //     });
  //   } catch (e) {
  //     print('Failed to load data: $e');
  //   }
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
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedYear != null && selectedMonth != null) {
                  fetchData(selectedYear!, selectedMonth!);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Silahkan pilih tahun dan bulan!')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: HexColor("#FE8660"), 
                elevation: 10.0,
                shadowColor: Colors.black.withOpacity(1.0),
              ),
                
              child: const Text(
                  'Cari',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Roboto',
                    fontSize: 20.0,
                  ),
                ),
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