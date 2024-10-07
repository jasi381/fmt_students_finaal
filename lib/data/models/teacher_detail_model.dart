class TeacherDetailsResponse {
  final bool success;
  final List<Rating> ratings;
  final TeacherDetails teacherProfile;

  TeacherDetailsResponse({
    required this.success,
    required this.ratings,
    required this.teacherProfile,
  });

  factory TeacherDetailsResponse.fromJson(Map<String, dynamic> json) {
    return TeacherDetailsResponse(
      success: json['success'],
      ratings: (json['ratings'] as List)
          .map((rating) => Rating.fromJson(rating))
          .toList(),
      teacherProfile: TeacherDetails.fromJson(json['teacherprofile']),
    );
  }
}

// Rating class
class Rating {
  final String studentName;
  final String rating;
  final String comment;

  Rating({
    required this.studentName,
    required this.rating,
    required this.comment,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      studentName: json['student_name'],
      rating: json['rating'],
      comment: json['comment'],
    );
  }
}

// TeacherDetails class
class TeacherDetails {
  final String id;
  final String teacherId;
  final String merithubid;
  final String name;
  final String email;
  final String classType;
  final String phone;
  final String gender;
  final String about;
  final String photo;
  final String subject;
  final String board;
  final String location;
  final String seassionPrice;
  final String education;
  final String experience;
  final String className;
  final String onlinePrice;
  final String homePrice;
  final String isVerified;

  TeacherDetails({
    required this.id,
    required this.teacherId,
    required this.merithubid,
    required this.name,
    required this.email,
    required this.classType,
    required this.phone,
    required this.gender,
    required this.about,
    required this.photo,
    required this.subject,
    required this.board,
    required this.location,
    required this.seassionPrice,
    required this.education,
    required this.experience,
    required this.className,
    required this.onlinePrice,
    required this.homePrice,
    required this.isVerified,
  });

  factory TeacherDetails.fromJson(Map<String, dynamic> json) {
    return TeacherDetails(
      id: json['id'],
      teacherId: json['teacher_id'],
      merithubid: json['merithubid'],
      name: json['name'],
      email: json['email'],
      classType: json['class_type'],
      phone: json['phone'],
      gender: json['gender'],
      about: json['about'],
      photo: json['photo'],
      subject: json['subject'],
      board: json['board'],
      location: json['location'],
      seassionPrice: json['seassion_price'],
      education: json['education'],
      experience: json['experiance'],
      className: json['class'],
      onlinePrice: json['online_price'],
      homePrice: json['home_price'],
      isVerified: json['verified'],
    );
  }
}
