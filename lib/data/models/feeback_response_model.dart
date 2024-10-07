class SubmitResponse {
  final bool success;
  final String message;

  SubmitResponse({required this.success, required this.message});

  // Factory constructor to create a SubmitResponse from JSON.
  factory SubmitResponse.fromJson(Map<String, dynamic> json) {
    return SubmitResponse(
      success: json['success'],
      message: json['message'],
    );
  }
}