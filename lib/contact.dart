import 'package:url_launcher/url_launcher.dart';
import 'package:bcv1mobile/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'main.dart';

void main() {
  runApp(const MaterialApp(
    home: ContactMenu(),
  ));
}
class ContactMenu extends StatefulWidget {
  const ContactMenu({super.key});
  @override
  _ContactMenustate createState() => _ContactMenustate();
}
class _ContactMenustate extends State<ContactMenu> {

  final ApiService _apiService = ApiService(); // Instantiate ApiService
  late Future<List<dynamic>> _futureContacts;

  @override
  void initState() {
    super.initState();
    _futureContacts = _fetchContacts();
  }

  Future<List<dynamic>> _fetchContacts() async {
    final contacts = await _apiService.getContacts();
    return contacts;
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#F4EBE8'),
      appBar: AppBar(
        title: const Text(
          'Kontak',
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
        child: FutureBuilder<List<dynamic>>(
          future: _futureContacts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final contacts = snapshot.data!;

              return ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  final String name = contact['nama'];
                  final String number = contact['nomor'];
                  final String type = contact['jenis'];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: GestureDetector(
                      onTap: () => _makePhoneCall(number),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Colors.grey[400],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$type ($name)',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  Text(
                                    number,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                      fontSize: 16.0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  );
                },
              );
            } else {
              return Center(child: Text('No contacts available'));
            }
          },
        ),
      ),
    );
  }
}