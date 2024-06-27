import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
// import 'dart:convert';
import 'dart:io';
// import 'package:http/http.dart' as http;
import 'services/api_service.dart'; // Import ApiService
import 'package:gallery_saver/gallery_saver.dart';

void main() {
  runApp(const MaterialApp(
    home: InputIPL(),
  ));
}

String addMonthToDate(DateTime date, int monthsToAdd) {
  int year = date.year;
  int month = date.month + monthsToAdd;

  // Adjust year and month if month goes beyond December
  while (month > 12) {
    month -= 12;
    year += 1;
  }

  return DateFormat('yyyyMM').format(DateTime(year, month));
}

class InputIPL extends StatefulWidget {
  const InputIPL({super.key});

  @override
  _InputIPLstate createState() => _InputIPLstate();
}

class _InputIPLstate extends State<InputIPL> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController meterAkhirController = TextEditingController();

  File? _image;
  final picker = ImagePicker();

  String? _nama;

  List<String> blokList = ['A', 'B', 'C', 'Daytona', 'Estoril', 'Imola', 'Indiana Polis', 'Interlagos', 'Laguna Seca', 'Le Mans', 'Monaco', 'Monza', 'Silverstone'];
  List<String> nomorKavlingList = [];
  String? selectedBlok;
  String? selectedNomorKavling;
  int? meterAwal;
  int? biayaIPL;
  int? user_id;
  int? tunggakan_1;
  int? tunggakan_2;
  int? tunggakan_3;
  int? last_month_bills;
  int? last_month_paid;

  final ApiService _apiService = ApiService(); // Instantiate ApiService

  final String FormatTanggal = addMonthToDate(DateTime.now(), 1);
  
  Future<void> _inputIPL(meterAkhir) async{
    int? tunggakan_1_new, tunggakan_2_new, tunggakan_3_new;
    try{

      // Pengecekan tunggakan bulan lalu
      if (last_month_paid == 0){
        if (tunggakan_1 != null){
          if (tunggakan_2 != null){
            tunggakan_3_new = tunggakan_3! + tunggakan_2!;
            tunggakan_2_new = tunggakan_1!;
            tunggakan_1_new = last_month_bills!;
          } else {
            tunggakan_2_new = tunggakan_1!;
            tunggakan_1_new = last_month_bills!;
          }
        } else {
          tunggakan_1_new = last_month_bills!;
        }
      } else {
        tunggakan_1_new = 0;
        tunggakan_2_new = 0;
        tunggakan_3_new = 0;
      }

      final response = await _apiService.inputIPL(
        user_id!, 0, FormatTanggal, biayaIPL!, meterAwal!, meterAkhir, tunggakan_1_new ?? 0, tunggakan_2_new ?? 0, tunggakan_3_new ?? 0
      );

      if (response == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data berhasil dikirim')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim data, silakan coba lagi')),
        );
      }
    } catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengirim data, silakan coba lagi')),
      );
      throw e;
    }
  }

  void fetchNomorKavlingList(String blok) {
    if (blok == 'A') {
      setState(() {
        nomorKavlingList = ['A1'];
      });
    } else if (blok == 'B') {
      setState(() {
        nomorKavlingList = ['B1', 'B2'];
      });
    } else if (blok == 'C') {
      setState(() {
        nomorKavlingList = ['C1', 'C2'];
      });
    } else if (blok == 'Daytona') {
      setState(() {
        nomorKavlingList = ['110'];
      });
    }
  }

    Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _saveImage() async {
    if (_image != null) {
      try {
        final Directory? directory = await getExternalStorageDirectory();
        final String path = directory!.path;
        final String FormatTanggal = DateFormat('yyyyMMdd_HH:mm').format(DateTime.now());
        final String fileName = '${selectedBlok}_${selectedNomorKavling}_Taken@${FormatTanggal}.jpg';
        final File newImage = await _image!.copy('$path/$fileName');

        await GallerySaver.saveImage(newImage.path);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Foto telah disimpan di galeri anda!')),
        );
      } catch (e) {
        print('Error saving image: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan foto')),
        );
      }
    }
  }

  void _checkNameAndMeterAwal() async {
    final response = await _apiService.getNameBills(selectedNomorKavling!, selectedBlok!);

    final String nama = response['nama'];
    final int userid = response['user_id'];

    final billDetail = await _apiService.getBillDetail(userid);

    final int meter_akhir = billDetail['meter_akhir'];
    final int hargaipl = billDetail['ipl'];
    final int tunggakan1 = billDetail['tunggakan_1'];
    final int tunggakan2 = billDetail['tunggakan_2'];
    final int tunggakan3 = billDetail['tunggakan_3'];
    final int lastMonthBills = billDetail['tag_now'];
    final int lastMonthPaid = billDetail['paid'];

    setState(() {
      _nama = nama;
      namaController.text = _nama!;
      meterAwal = meter_akhir;
      biayaIPL = hargaipl;
      user_id = userid;
      tunggakan_1 = tunggakan1;
      tunggakan_2 = tunggakan2;
      tunggakan_3 = tunggakan3;
      last_month_bills = lastMonthBills;
      last_month_paid = lastMonthPaid;
    });
  }

  void _submitData() {
    final String meterAkhirText = meterAkhirController.text;

    if (selectedBlok == null || selectedBlok!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Blok harus diisi terlebih dahulu!')),
      );
      return;
    }
    if (selectedNomorKavling == null || selectedNomorKavling!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nomor Kavling harus diisi terlebih dahulu!')),
      );
      return;
    }
    if (meterAkhirText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Meter akhir harus diisi terlebih dahulu!')),
      );
      return;
    }
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Anda harus mengambil gambar terlebih dahulu!')),
      );
      return;
    }

    final int? meterAkhir = int.tryParse(meterAkhirText);

    if (meterAkhir! < meterAwal!) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pastikan besaran meter akhir! Meter akhir tidak dapat kurang dari meter awal!')),
      );
      return;
    }

    _inputIPL(meterAkhir);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#F4EBE8'),
      appBar: AppBar(
        title: const Text(
          'Input Tagihan IPL',
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
              Row(
                children: [
                  DropdownButton<String>(
                    hint: const Text("Pilih Blok"),
                    value: selectedBlok,
                    items: blokList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedBlok = newValue;
                        selectedNomorKavling = null;
                        nomorKavlingList = [];
                        fetchNomorKavlingList(newValue!);
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButton<String>(
                    hint: const Text("Pilih Nomor Kavling"),
                    value: selectedNomorKavling,
                    items: nomorKavlingList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedNomorKavling = newValue;
                        // Memanggil _submitData jika kedua dropdown sudah terpilih
                        if (selectedBlok != null && selectedNomorKavling != null) {
                          _checkNameAndMeterAwal();
                        }
                      });
                    },
                  ),
                ],              
              ),
              const SizedBox(height: 20),
              TextField(
                controller: namaController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: "Nama",
                  border: OutlineInputBorder(),
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
                      meterAwal != null ? meterAwal.toString() : '-',
                      style: const TextStyle(
                        fontSize: 16.0,
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
                    TextField(
                      controller: meterAkhirController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Masukkan Meter Akhir',
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Center(
                      child: _image == null
                          ? ElevatedButton.icon(
                              onPressed: _pickImage,
                              icon: Icon(MdiIcons.camera, color: Colors.black),
                              label: Text(
                                "Ambil Gambar",
                                style: TextStyle(color: Colors.black),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: HexColor('#FE8660'),
                              ),
                            )
                          : Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.file(
                                      _image!,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: _pickImage,
                                      icon: Icon(MdiIcons.refresh, color: Colors.black),
                                      label: Text(
                                        "Ulang",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: HexColor('#FE8660'),
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: _saveImage,
                                      icon: Icon(MdiIcons.contentSave, color: Colors.black),
                                      label: Text(
                                        "Simpan",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: HexColor('#FE8660'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _submitData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: HexColor('#FE8660'),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text("Unggah Data!", style: TextStyle(color: Colors.black)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Utility class for hex color conversion
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
