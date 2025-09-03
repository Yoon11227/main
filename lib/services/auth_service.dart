import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // kIsWeb 사용 시 필요

class AuthService {
  final String baseUrl = kIsWeb
      ? "http://192.168.0.6:3000"   // 웹 브라우저 실행 시 PC IP
      : "http://10.0.2.2:3000";     // 안드로이드 에뮬레이터 실행 시

  Future<bool> register(String email, String password) async {
    try{
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      return response.statusCode == 200;
    } catch (e){
      print("회원가입 중 에러떳습니다");
      return false;
    }
  }

  Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['token'];
    } else {
      return null;
    }
  }
}
