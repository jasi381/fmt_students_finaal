import 'package:flutter/material.dart';
import 'package:students/domain/entities/student_profile_entity.dart';
import 'package:students/domain/usecases/profile_use_case.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileUseCase _profileUseCase;

  StudentProfileEntity? _studentProfileEntity;
  StudentProfileEntity? get studentProfileEntity => _studentProfileEntity;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ProfileProvider(this._profileUseCase);

  Future<void> fetchStudentProfile(String phone) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _studentProfileEntity = await _profileUseCase.call(phone);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
