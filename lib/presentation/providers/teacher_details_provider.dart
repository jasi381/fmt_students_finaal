import 'package:flutter/material.dart';
import 'package:students/domain/entities/teacher_details_entity.dart';
import 'package:students/domain/usecases/teacher_details_use_case.dart';

class TeacherDetailsProvider extends ChangeNotifier {
  final TeacherDetailsUseCase useCase;

  TeacherDetailsProvider(this.useCase);

  TeacherDetailsEntity? teacherDetails;
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchTeacherDetails(String id) async {
    isLoading = true;
    notifyListeners();

    try {
      teacherDetails = await useCase(id);
      errorMessage = null;
      print("SUCCESS DETAILS");
    } catch (e) {
      teacherDetails = null;
      errorMessage = e.toString();
      print("Error Details: ${e.toString()}");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
