import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String _baseUrl = 'https://bcv1.my.id/api';

  String get baseUrl => _baseUrl;

  Future<Map<String, dynamic>> login(String email, String password) async {
    final String url = '$_baseUrl/auth/login';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return responseBody;
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  Future<Map<String, dynamic>> getBills() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token tidak tersedia');
    }

    final String url = '$_baseUrl/bills';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return responseBody[0] as Map<String, dynamic>;
    } else {
      throw Exception('Failed to send request');
    }
  }

  Future<String> getName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token tidak tersedia');
    }

    final String url = '$_baseUrl/user/profile';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return responseBody['nama'].toString();
    } else {
      throw Exception('Failed to send request');
    }
  }

  Future<Map<String, dynamic>> getNameBills(String nomor_kavling, String blok) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final String url = '$_baseUrl/admin/find-name';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'nomor_kavling': nomor_kavling,
        'blok': blok,
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return responseBody as Map<String, dynamic>;
    } else {
      throw Exception('Failed to send request');
    }
  }

  Future<List<dynamic>> getSchedule() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final String url = '$_baseUrl/schedule';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to send request');
    }
  }

  Future<List<dynamic>> getContacts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final String url = '$_baseUrl/contacts';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to send request');
    }
  }

  Future<Map<String, dynamic>> getBillDetail(int user_id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final String url = '$_baseUrl/admin/get-meter-awal';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'user_id': user_id.toString(),
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return responseBody as Map<String, dynamic>;
    } else {
      throw Exception('Failed to send request');
    }
  }
  Future<Map<String, dynamic>> getBillByMonth(String thn_bl) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final String url = '$_baseUrl/bills/by-month';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'thn_bl': thn_bl,
      },
    );

    if (response.statusCode == 200) {
      return {
        'status': 200,
        'data': json.decode(response.body),
      };
    } else if (response.statusCode == 404) {
      return {
        'status': 404,
        'message': 'Tagihan tidak ditemukan untuk bulan tersebut',
      };
    } else {
      return {
        'status': 500,
        'message': 'Internal Server Error',
      };
    }
  }

  Future<int> inputIPL(int user_id, int paid_stat, String tahunBulan, int IPL, int meterAwal, int meterAkhir, int tunggakan1, int tunggakan2, int tunggakan3) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final String url = '$_baseUrl/admin/bills/add';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'user_id': user_id.toString(),
        'paid': paid_stat.toString(),
        'thn_bl': tahunBulan,
        'ipl': IPL.toString(),
        'meter_awal': meterAwal.toString(),
        'meter_akhir': meterAkhir.toString(),
        'tunggakan_1': tunggakan1.toString(),
        'tunggakan_2': tunggakan2.toString(),
        'tunggakan_3': tunggakan3.toString(),
      },
    );

    if (response.statusCode == 200) {
      return response.statusCode;
    } else {
      print('Request Headers: ${response.headers}');
      print('Request Body: ${response.body}');
      throw Exception('Failed to send request');
    }
  }
}
