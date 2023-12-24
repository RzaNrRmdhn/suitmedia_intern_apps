import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intern_apps/model/model_user.dart';

class ApiService {
  final String apiUrl = "https://reqres.in/api/users?page=1&per_page=10";

  Future<List<User>> getUsers({required int Page}) async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
