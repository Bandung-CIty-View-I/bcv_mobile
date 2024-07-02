import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'services/api_service.dart';
import 'main.dart';

void main() {
  runApp(const MaterialApp(
    home: DetailIPL(),
  ));
}

String formatRupiah(int number) {
  final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
  return formatCurrency.format(number);
}

class DetailIPL extends StatefulWidget {
  const DetailIPL({super.key});

  @override
  _DetailIPLstate createState() => _DetailIPLstate();
}

class _DetailIPLstate extends State<DetailIPL> {
  final ApiService _apiService = ApiService();
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

  String getMonthNumber(String month) {
    final DateTime date = DateFormat.MMMM().parse(month);
    return DateFormat('MM').format(date);
  }

  void fetchData() async {
    if (selectedYear != null && selectedMonth != null) {
      String monthNumber = getMonthNumber(selectedMonth!);
      String thnBl = '$selectedYear$monthNumber';

      // Panggil API service
      var response = await _apiService.getBillByMonth(thnBl);

      if (response['status'] == 200) {
        int tunggakan_1 = response['data']['tunggakan_1'];
        int tunggakan_2 = response['data']['tunggakan_2'];
        int tunggakan_3 = response['data']['tunggakan_3'];
        int tunggakan_total = tunggakan_1 + tunggakan_2 + tunggakan_3;
        setState(() {
          meterAwal = response['data']['meter_awal'].toString();
          meterAkhir = response['data']['meter_akhir'].toString();
          totalTunggakan = formatRupiah(tunggakan_total);
          totalTagihan = formatRupiah(response['data']['total_tag']);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
      }
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DropdownButton<String>(
                hint: Text('Select Year'),
                value: selectedYear,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedYear = newValue;
                  });
                },
                items: years.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              DropdownButton<String>(
                hint: Text('Select Month'),
                value: selectedMonth,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedMonth = newValue;
                  });
                },
                items: months.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (selectedYear != null && selectedMonth != null) {
                    fetchData();
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
              Container(
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
                    const SizedBox(height: 10.0),
                    Text(
                      meterAwal,
                      style: const TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    const SizedBox(height: 5.0),
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
                    const SizedBox(height: 10.0),
                    Text(
                      meterAkhir,
                      style: const TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    const SizedBox(height: 5.0),
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
                    const SizedBox(height: 10.0),
                    Text(
                      totalTunggakan,
                      style: const TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    const SizedBox(height: 5.0),
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
                    const SizedBox(height: 10.0),
                    Text(
                      totalTagihan,
                      style: const TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Divider(color: Colors.black),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}