class LoginModel {
  final String? phone;

  LoginModel({this.phone});

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
    };
  }
}
