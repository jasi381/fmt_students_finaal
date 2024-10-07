class ResponseModel {
  final bool? success;
  final String? message;

  ResponseModel({this.success, this.message});

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message};
  }

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      success: json['success'],
      message: json['message'],
    );
  }
}
