class HomeClassResponse {
  final bool success;
  final List<DaySchedule> data;

  HomeClassResponse({required this.success, required this.data});

  factory HomeClassResponse.fromJson(Map<String, dynamic> json) {
    return HomeClassResponse(
      success: json['success'],
      data: List<DaySchedule>.from(json['data'].map((item) => DaySchedule.fromJson(item))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class DaySchedule {
  final String date;
  final List<Slot> slots;

  DaySchedule({required this.date, required this.slots});

  factory DaySchedule.fromJson(Map<String, dynamic> json) {
    return DaySchedule(
      date: json['date'],
      slots: List<Slot>.from(json['slots'].map((item) => Slot.fromJson(item))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'slots': slots.map((item) => item.toJson()).toList(),
    };
  }
}

class Slot {
  final String time;
  final bool disabled;

  Slot({required this.time, required this.disabled});

  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(
      time: json['time'],
      disabled: json['disabled'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'disabled': disabled,
    };
  }
}
