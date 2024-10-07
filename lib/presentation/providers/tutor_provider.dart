import 'package:flutter/foundation.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:fuzzywuzzy/model/extracted_result.dart';
import 'package:students/data/datasources/tutor_data_source.dart';
import 'package:students/domain/entities/tutor_entity.dart';
import 'package:students/domain/usecases/tutor_use_case.dart';


class TutorProvider extends ChangeNotifier {
  final TutorUseCase _tutorUseCase;
  final List<TutorEntity> _allTutors = [];
  List<TutorEntity> _displayedTutors = [];
  List<TutorEntity> _bestTutors = [];
  bool _isLoading = false;
  bool _hasMoreData = true;
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  String _currentQuery = '';

  TutorProvider(this._tutorUseCase);

  List<TutorEntity> get tutors => _displayedTutors;
  List<TutorEntity> get bestTutors => _bestTutors;
  bool get isLoading => _isLoading;
  bool get hasMoreData => _hasMoreData;

  // Fetch all tutors from the API at once
 // Fetch all tutors from the API at once

  Future<void> fetchAllTutors(ApiType type,{String? phoneNumber}) async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final allTutors = await _tutorUseCase(type,phoneNumber: phoneNumber); // Fetch all tutors
      // Ensure unique tutors before adding
      for (var tutor in allTutors) {
        if (!_allTutors.contains(tutor)) {
          _allTutors.add(tutor);
        }
      }
      _applyFilters();  // Apply filters to initialize the first page
      _filterBestTutors();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Function to filter best tutors
  void _filterBestTutors() {
    _bestTutors = _allTutors
        .where((tutor) => tutor.best!)  // Filter by isBest
        .take(8)  // Limit to 8 items
        .toList();
    notifyListeners();
  }

  Future<void> refresh() async {
    _currentPage = 1;
    _hasMoreData = true;
    _currentQuery = '';
    _applyFilters();
    notifyListeners();
  }

  // Search tutors based on the query
  // Search tutors based on the query
  Future<void> searchTutors(String query) async {
    _currentQuery = query.toLowerCase();
    _currentPage = 1; // Reset to the first page for a new search
    _hasMoreData = true; // Reset hasMoreData for a new search

    // Clear the previously displayed tutors
    _displayedTutors.clear();

    _applyFilters(); // Reapply filters to update the displayed list
    notifyListeners();
  }

  void resetFilters() {
    _currentQuery = '';
    _applyFilters();
    notifyListeners();
  }

  // Apply filters and pagination
  void _applyFilters() {
    List<TutorEntity> filteredTutors = _allTutors;

    if (_currentQuery.isNotEmpty) {
      // Filter based on search query
      filteredTutors = _allTutors.where((tutor) =>
      (tutor.name?.toLowerCase().contains(_currentQuery) ?? false) ||
          (tutor.subject?.toLowerCase().contains(_currentQuery) ?? false)).toList();
    }

    // Apply pagination
    final int startIndex = (_currentPage - 1) * _itemsPerPage;
    final int endIndex = startIndex + _itemsPerPage;

    // Prevent startIndex from exceeding the length of filteredTutors
    if (startIndex >= filteredTutors.length) {
      _hasMoreData = false; // No more data available
      return;
    }

    final newTutors = filteredTutors.sublist(
      startIndex,
      endIndex > filteredTutors.length ? filteredTutors.length : endIndex,
    );

    // Clear the displayed tutors if it's the first page
    if (_currentPage == 1) {
      _displayedTutors.clear(); // Clear previous results for a fresh search
    }

    // Add unique tutors only
    for (var tutor in newTutors) {
      if (!_displayedTutors.contains(tutor)) {
        _displayedTutors.add(tutor);
      }
    }

    // Check if more data is available for future pages
    _hasMoreData = endIndex < filteredTutors.length;

    _filterBestTutors();
  }




  // Load more tutors when scrolling to the bottom of the list
  Future<void> loadMoreTutors() async {
    if (_isLoading || !_hasMoreData) return;

    _currentPage++;
    _applyFilters();
    notifyListeners();
  }

  List<TutorEntity> getSuggestions(String query) {
    if (query.isEmpty) {
      return [];
    }

    final lowercaseQuery = query.toLowerCase();
    return _allTutors
        .where((tutor) =>
    (tutor.name?.toLowerCase().contains(lowercaseQuery) ?? false) ||
        (tutor.subject?.toLowerCase().contains(lowercaseQuery) ?? false))
        .toList();
  }

  void updateSuggestions(String query) {
    if (query.isEmpty) {
      resetFilters();
    } else {
      _currentQuery = query.toLowerCase();
      _displayedTutors = getSuggestions(query);
      notifyListeners();
    }
  }
}