class RegisterModel {
  final String? name;
  final String? email;
  final String? address;
  final String? course;
  final String? state;
  final String? city;
  final String? pin_code;
  final String? phone;

  RegisterModel(
      {this.name,
      this.email,
      this.address,
      this.course,
      this.state,
      this.city,
      this.pin_code,
      this.phone});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'address': address,
      'class': course,
      'state': state,
      'city': city,
      'pin_code': pin_code,
      'phone': phone,
    };
  }
}
