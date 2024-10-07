import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:students/data/models/home_booking_model.dart';
import 'package:students/data/models/response_model.dart';
import 'package:students/utils/constants.dart';

class HomeBookingDataSource{
  Future<ResponseModel> bookHomeClass(HomeBookingModel homeBookingModel,ApiType apiType) async{

     String url =
        '${Constants.baseUrl}${apiType.value}.php?API-Key=${Constants.apiKey}';

    final response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(homeBookingModel.toJson()));

    print("Response is: ${response.body}");

    if (response.statusCode != 200) {
      print("Error :${response.body}");
      print("Hello: $url");
      throw Exception('Failed to book session details');


    }

    final responseJson = json.decode(response.body);
    return ResponseModel.fromJson(responseJson);

  }
}

enum ApiType {
  center,
  home,
  online
}

extension StatusExtension on ApiType {
  String get value {
    switch (this) {
      case ApiType.home:
        return 'homeschedule';
      case ApiType.center:
        return 'centerschedule';
      case ApiType.online:
        return 'onlineschedule';
    }
  }
}