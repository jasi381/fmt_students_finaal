class HomeBookingModel {
  final String phone;
  final String amount;
  final String teacher;
  final String classTime;
  final String classDate;

  HomeBookingModel({
    required this.phone,
    required this.amount,
    required this.teacher,
    required this.classTime,
    required this.classDate,
  });

  factory HomeBookingModel.fromJson(Map<String, dynamic> json) {
    return HomeBookingModel(
      phone: json['phone'],
      amount: json['amount'],
      teacher: json['teacher'],
      classTime: json['classtime'],
      classDate: json['classdate'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'amount': amount,
      'teacher': teacher,
      'classtime': classTime,
      'classdate': classDate,
    };
  }
}
