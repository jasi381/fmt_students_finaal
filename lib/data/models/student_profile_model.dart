class StudentProfileModel {
  final bool success;
  final StudentProfile studentProfile;

  StudentProfileModel({required this.success, required this.studentProfile});

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) {
    return StudentProfileModel(
      success: json['success'],
      studentProfile: StudentProfile.fromJson(json['data']),
    );
  }
}

class StudentProfile {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final String? date;
  final String? country;
  final String? state;
  final String? city;
  final String? pinCode;
  final String? userClass;
  final String? studentId;
  final String? merithubId;
  final String? wallet;

  StudentProfile({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.date,
    this.country,
    this.state,
    this.city,
    this.pinCode,
    this.userClass,
    this.studentId,
    this.merithubId,
    this.wallet,
  });

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      id: json['id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      date: json['date'] as String?,
      country: json['country'] as String?,
      state: json['state'] as String?,
      city: json['city'] as String?,
      pinCode: json['pin_code'] as String?,
      userClass: json['class'] as String?,
      studentId: json['studentid'] as String?,
      merithubId: json['merithubid'] as String?,
      wallet: json['wallet'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'date': date,
      'country': country,
      'state': state,
      'city': city,
      'pin_code': pinCode,
      'class': userClass,
      'studentid': studentId,
      'merithubid': merithubId,
      'wallet': wallet,
    };
  }
}
