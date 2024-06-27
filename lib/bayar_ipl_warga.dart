import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'services/api_service.dart';
import 'main.dart';

void main() {
  runApp(const MaterialApp(
    home: BayarIPL(),
  ));
}

String formatRupiah(int number) {
  final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
  return formatCurrency.format(number);
}

class BayarIPL extends StatefulWidget {
  const BayarIPL({super.key});

  @override
  _BayarIPLstate createState() => _BayarIPLstate();
}

class _BayarIPLstate extends State<BayarIPL> {
  final ApiService _apiService = ApiService();
  late Future<Map<String, dynamic>> _futureBills;
  String idPelanggan = "";
  String totalTagihan = "";
  int? _paid;

  @override
  void initState() {
    super.initState();
    _futureBills = _fetchBills();
  }

  Future<Map<String, dynamic>> _fetchBills() async {
    final bills = await _apiService.getBills();
    return bills;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#F4EBE8'),
      appBar: AppBar(
        title: const Text(
          'Bayar IPL',
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
        child: FutureBuilder<Map<String, dynamic>>(
          future: _futureBills,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final bills = snapshot.data!;
              final int totalTag = bills['total_tag'];
              final int paid = bills['paid'];
              final String idpel = bills['user']['id_pelanggan_online'];
              final totalTagihan = formatRupiah(totalTag);
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                              Icon(MdiIcons.currencyUsd),
                              const SizedBox(width: 10),
                              const Text(
                                "Tagihan Bulan Ini",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            paid == 0 ? totalTagihan : 'Anda sudah membayar tagihan bulan ini!',
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Divider(color: Colors.black),
                          const SizedBox(height: 10.0),
                          Row(
                            children: [
                              const Text(
                                "Nomor Virtual Account",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            idpel,
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Divider(color: Colors.black),
                          const SizedBox(height: 20.0),
                          Text(
                            "Pembayaran iuran IPL dan air dapat dilakukan melalui virtual account dengan kode (59044)",
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(height: 40.0),
                          Text(
                            "Anda juga dapat melakukan pembayaran melalui transfer ke Bank BCA dengan nomor rekening : 1377775678 a.n. CV. Bandung City View.",
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Text(
                            "Bukti transfer dapat dikirim ke nomor WA: 082320462406",
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }
}