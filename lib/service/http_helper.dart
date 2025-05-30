import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpHelper {
  static String baseUrl = 'flexe-nfc-api.somee.com';
  static String loginUrl = 'api/v1/login';
  static String getCardInfoUrl = 'api/v1/getCardInfo';
  static String addOrderUrl = 'api/v1/addOrder';
  static String confirmOrderUrl = 'api/v1/confirmOrder';

// login
  static Future<http.Response> login(
      {required String name, required String passWord}) async {
    var url = Uri.http(baseUrl, loginUrl);
    final response = await http.post(url,
        body: jsonEncode({'name': name, "password": passWord}),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 401) {
      throw Exception('خطأ في اسم المستخدم او كلمة المرور');
    } else {
      throw Exception('حدث خطأ ما ${response.statusCode}');
    }
  }

//getCardInfo
  static Future<http.Response> getCardInfo({
    required String token,
    required String cardId,
  }) async {
    var url = Uri.http(baseUrl, getCardInfoUrl, {'cardID': cardId});
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});

    return response;
  }

//addOrder
  static Future<http.Response> addOrder(
      {required String token,
      required String internalCode, // رقم العملية
      required DateTime date, //"2023-09-04T07:30:58.185Z",
      required num litres,
      required num deductedPoints,
      required cardId}) async {
    var url = Uri.http(baseUrl, addOrderUrl);
    final response = await http.post(url,
        body: jsonEncode({
          'internal_code': internalCode, // رقم العملية
          'date': date.toIso8601String(),
          'litres': litres,
          'deducted_points': deductedPoints,
          'card_id': cardId
        }),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        });
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('request failed');
    }
  }

  //confirmOrder
  static Future<http.Response> confirmOrder({
    required String token,
    required String internalCode,
    required String otpCode,
  }) async {
    var url = Uri.http(baseUrl, confirmOrderUrl,
        {'internal_code': internalCode, 'OTP_code': otpCode});
    var response =
        await http.post(url, headers: {'Authorization': 'Bearer $token'});
    return response;
  }
}
