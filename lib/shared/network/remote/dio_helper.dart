import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class DioHelper
{
  static Dio dio;

  static init() {
     dio = Dio(
       BaseOptions(
         connectTimeout: 20 * 1000,
         receiveTimeout: 20 * 1000,
      baseUrl: 'https://newsapi.org/',
      receiveDataWhenStatusError: true,
    ),
     );
  }

  static Future<Response> getData({
    @required String url,
    @required Map<String, dynamic> query,
  }) async
  {
    return await dio.get(
      url,
      queryParameters: query,
    );
  }
  }
