import 'package:flutter/foundation.dart';
import 'package:students/data/models/response_model.dart';
import 'package:students/domain/entities/home_booking_entity.dart';
import 'package:students/domain/usecases/home_booking_use_case.dart';

import '../../data/datasources/home_booking_data_source.dart';

class HomeBookingProvider extends ChangeNotifier {
  final HomeBookingUseCase homeBookingUseCase;

  HomeBookingProvider(this.homeBookingUseCase);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _message;
  String? get message => _message;

  String? _error;
  String? get error=> _error;

  ResponseModel? _response;
  ResponseModel? get response => _response;

  Future<void> bookSession(HomeBookingEntity homeBookingEntity,ApiType apiType) async {
    _isLoading = true;
    _message = null;
    _error = null;
    _response = null;
    notifyListeners();

    try {
       _response = await homeBookingUseCase(homeBookingEntity,apiType);
       _message = 'Session Booked Successfully';
    } catch (e) {
      _error = e.toString();
      debugPrint("Book Session error: $_error");
    } finally {
      _isLoading = false;
      debugPrint("Book Session response: ${_response?.message ?? 'null'}");
      debugPrint("Book Session message: $_message");
      debugPrint("Book Session error: $_error");
      notifyListeners();
    }
  }
}
