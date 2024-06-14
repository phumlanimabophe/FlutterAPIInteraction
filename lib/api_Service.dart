import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {

  static const String url = 'http://127.0.0.1:8000';

  Future<List<dynamic>> getCustomers() async {
    final response = await http.post(
      Uri.parse('$url/customerslikegraph/'),
      body: {'option': 'list'},
    );
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body != null) {
        return body;
      } else {
        throw Exception('Response body is null');
      }
    } else {
      throw Exception('Failed to load customers');
    }
  }

  Future<dynamic> createCustomer(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$url/customerslikegraph/'),
      body: {...data, 'option': 'create'},
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create customer');
    }
  }

  Future<dynamic> getCustomer(int id) async {
    final response = await http.post(
      Uri.parse('$url/customerslikegraph/'),
      body: {'id': id.toString(), 'option': 'retrieve'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load customer');
    }
  }

  Future<void> deleteCustomer(dynamic id) async {
    final response = await http.post(
      Uri.parse('$url/customerslikegraph/'),
      body: {'first_name': id.toString(), 'option': 'destroy'},
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete customer');
    }
  }
}