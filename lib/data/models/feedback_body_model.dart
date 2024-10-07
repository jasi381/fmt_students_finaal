class SubmitRequest {
  final String phone;
  final String comment;

  SubmitRequest({required this.phone, required this.comment});

  // Convert a SubmitRequest into a Map.
  Map<String, dynamic> toJson() => {
    "phone": phone,
    "comment": comment,
  };
}