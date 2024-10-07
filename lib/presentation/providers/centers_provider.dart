import 'package:flutter/foundation.dart';
import 'package:students/domain/entities/tutor_entity.dart';
import 'package:students/domain/usecases/centers_use_case.dart';

class CentersProvider extends ChangeNotifier {
  final CentersUseCase centersUseCase;
  List<TutorEntity> _centers = [];
  bool _isLoading = false;
  String _errorMessage = '';

  CentersProvider(this.centersUseCase);

  List<TutorEntity> get centers => _centers;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchCenters(String phoneNumber, double lat, double long) async {
    _isLoading = true;
    notifyListeners();

    try {
      final centers = await centersUseCase.call(phoneNumber, lat, long);
      _centers = centers;
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to load centers';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
