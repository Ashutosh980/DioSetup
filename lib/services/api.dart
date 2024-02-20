import 'package:dio/dio.dart';
import 'package:dio_setup/interceptor/dio_interceptor.dart';
import 'package:dio_setup/services/store.dart';
import 'package:flutter/material.dart';

class DemoAPI {
  late final Dio _dio;
  DemoAPI() {
    _dio = Dio();
    _dio.interceptors.add(DioInterceptor());
  }
  final String _loginUrl = "https://dummyjson.com/auth/login";

  final String _dataUrl = "https://dummyjson.com/auth/me";
  Map<String, dynamic> get _loginData => {
        "username": 'kminchelle',
        "password": '0lelplR',
        // expiresInMins: 60, // optional
      };
  Future<void> _saveToken(Map<String, dynamic> data) async {
    final token = data['token'];
    await Store.setToken(token);
  }

  String _getResult(Map<String, dynamic> json) {
    debugPrint("Data Received is $json");
    return 'Received $json objects';
  }

  Future<bool> dioLogin() async {
    final response = await _dio.post(
      _loginUrl,
      data: _loginData,
    );

    if (response.statusCode == 200) {
      await _saveToken(response.data);
      return true;
    }
    return false;
  }

  Future<String> dioGetData() async {
    try {
      final response = await _dio.get(
        _dataUrl,
      );
      if (response.statusCode == 200) {
        return _getResult(response.data);
      }
      return response.data as String;
    } on DioException catch (e) {
      return e.response?.data ?? "Error occured";
    }
  }
}