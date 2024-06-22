import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MaterialApp(
    home: InputIPL(),
  ));
}

class InputIPL extends StatefulWidget {
  const InputIPL({super.key});

  @override
  _InputIPLstate createState() => _InputIPLstate();
}

class _InputIPLstate extends State<InputIPL> {
  final TextEditingController meterAkhirController = TextEditingController();
  File? _image;
  final picker = ImagePicker();

  List<String> nomorRumahList = [];
  String? selectedNomorRumah;
  String meterAwal = "";

  @override
  void initState() {
    super.initState();
    fetchNomorRumahList();
  }

  Future<void> fetchNomorRumahList() async {
    final response = await http.get(Uri.parse('https://api.example.com/nomor-rumah'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      setState(() {
        nomorRumahList = data.map((item) => item['nomorRumah'].toString()).toList();
      });
    } else {
      throw Exception('Failed to load nomor rumah');
    }
  }

  Future<void> fetchMeterAwal(String nomorRumah) async {
    final response = await http.get(Uri.parse('https://api.example.com/meter-awal?nomorRumah=$nomorRumah'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        meterAwal = data['meterAwal'].toString();
      });
    } else {
      throw Exception('Failed to load meter awal');
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

  void _submitData() async {
    if (meterAkhirController.text.isEmpty || _image == null || selectedNomorRumah == null) {
      // Show error message or handle invalid input
      return;
    }

    final request = http.MultipartRequest('POST', Uri.parse('https://api.example.com/input-ipl'));
    request.fields['nomorRumah'] = selectedNomorRumah!;
    request.fields['meterAkhir'] = meterAkhirController.text;
    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      // Handle successful response
    } else {
      // Handle error response
      throw Exception('Failed to submit data');
    }
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
              DropdownButton<String>(
                hint: const Text("Select Nomor Rumah"),
                value: selectedNomorRumah,
                items: nomorRumahList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedNomorRumah = newValue;
                    fetchMeterAwal(newValue!);
                  });
                },
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
                                  height: 200, // Set the height as needed
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
                  child: Text("Input IPL", style: TextStyle(color: Colors.black)),
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
