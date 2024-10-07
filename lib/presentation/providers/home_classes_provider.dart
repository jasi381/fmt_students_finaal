import 'package:flutter/foundation.dart';
import 'package:students/domain/entities/home_class_entity.dart';
import 'package:students/domain/usecases/home_class_use_case.dart';


class HomeClassesProvider extends ChangeNotifier{

  final HomeClassUseCase homeClassUseCase;

  HomeClassesProvider(this.homeClassUseCase);

  HomeClassEntity? _schedule;
  bool _isLoading = false;
  String? _error;

  HomeClassEntity? get schedule => _schedule;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadSchedule(String teacherId)async{
    _isLoading = true;
    _error = null;
    notifyListeners();


    try{
      _schedule = await homeClassUseCase.call(teacherId);

      _schedule = HomeClassEntity(
          success: _schedule!.success,
          data: _schedule!.data
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      if (kDebugMode) {
        print("Error in fetching schedule: ${e.toString()}");
      }
      notifyListeners();
    }
  }
}