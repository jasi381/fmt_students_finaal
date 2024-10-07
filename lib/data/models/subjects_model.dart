class SubjectsModel {
  final bool success;
  final List<String> subjects;

  SubjectsModel({
    required this.success,
    required this.subjects,
  });

  factory SubjectsModel.fromJson(Map<String, dynamic> json) {
    return SubjectsModel(
      success: json['success'],
      subjects: List<String>.from(json['subjects']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'subjects': subjects,
    };
  }
}
