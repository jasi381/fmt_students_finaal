import 'package:flutter/foundation.dart';
import 'package:students/domain/entities/blogs_entity.dart';
import 'package:students/domain/entities/subjects_entity.dart';
import 'package:students/domain/entities/top_institutes_entity.dart';
import 'package:students/domain/usecases/home_use_case.dart';

class HomeProvider extends ChangeNotifier {
  final HomeUseCase homeUseCase;

  SubjectsEntity? _subjects;
  bool _isSubjectsLoading = false;
  String? _subjectsError;

  BlogEntity? _blogs;
  bool _isBlogsLoading = false;
  String? _blogsError;

  TopInstitutesEntity? _topInstitutes;
  bool _isTopInstitutesLoading = false;
  String? _topInstitutesError;

  HomeProvider(this.homeUseCase);

  SubjectsEntity? get subjects => _subjects;
  bool get isSubjectsLoading => _isSubjectsLoading;
  String? get subjectsError => _subjectsError;

  BlogEntity? get blogs => _blogs;
  bool get isBlogsLoading => _isBlogsLoading;
  String? get blogsError => _blogsError;


  TopInstitutesEntity? get topCenters => _topInstitutes;
  bool get isTopInstitutesLoading => _isTopInstitutesLoading;
  String? get topInstitutesError => _topInstitutesError;


  Future<void> loadSubjects() async {
    _isSubjectsLoading = true;
    _subjectsError = null;
    notifyListeners();

    try {
      _subjects = await homeUseCase.call();

      // Filter out any empty strings from the subjectList
      _subjects = SubjectsEntity(
        isSuccess: _subjects!.isSuccess,
        subjectList: _subjects!.subjectList.where((subject) => subject.isNotEmpty).toList(),
      );

      _isSubjectsLoading = false;
      notifyListeners();
      if (kDebugMode) {
        print("Filtered Subjects: ${_subjects?.subjectList.length}");
      }
    } catch (e) {
      _subjectsError = e.toString();
      _isSubjectsLoading = false;
      if (kDebugMode) {
        print("Error: ${e.toString()}");
      }
      notifyListeners();
    }
  }

  Future<void> loadBlogs() async {
    _isBlogsLoading = true;
    _blogsError = null;
    notifyListeners();

    try {
      _blogs = await homeUseCase.call1();

      // Filter out any empty strings from the subjectList
      _blogs = BlogEntity(
        success: _blogs!.success,
        blogs: _blogs!.blogs
      );

      _isBlogsLoading = false;
      notifyListeners();
      if (kDebugMode) {
        print("Filtered Subjects: ${blogs?.blogs.length}");
      }
    } catch (e) {
      _blogsError = e.toString();
      _isBlogsLoading = false;
      if (kDebugMode) {
        print("Error: ${e.toString()}");
      }
      notifyListeners();
    }
  }

  Future<void> loadTopInstitutes() async {
    _isTopInstitutesLoading = true;
    _topInstitutesError = null;
    notifyListeners();

    try {
      _topInstitutes = await homeUseCase.call2();

      // Filter out any empty strings from the subjectList
      _topInstitutes = TopInstitutesEntity(
          success: _topInstitutes!.success,
          institutes: _topInstitutes!.institutes
      );

      _isTopInstitutesLoading = false;
      notifyListeners();
      if (kDebugMode) {
        print("Filtered topInstitutes: ${topCenters?.institutes[0].id}");
      }
    } catch (e) {
      _topInstitutesError = e.toString();
      _isTopInstitutesLoading = false;
      if (kDebugMode) {
        print("Error: ${e.toString()}");
      }
      notifyListeners();
    }
  }
}
