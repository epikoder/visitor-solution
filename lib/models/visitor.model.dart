import 'package:get/get.dart';
import 'package:visitor_solution/models/gender.model.dart';
import 'package:visitor_solution/models/purpose.model.dart';

class Visitor {
  Visitor({
    required this.fname,
    required this.lname,
    required this.phone,
    required this.department,
    required this.photo,
    required this.gender,
    required this.purpose,
    required this.vid,
    required this.date,
    this.clockedInAt,
    this.clockedOutAt,
  });
  final String fname;
  final String lname;
  final String phone;
  final Gender gender;
  final Purpose purpose;
  final String department;
  final String photo;
  final String vid;
  final DateTime date;
  DateTime? clockedInAt;
  DateTime? clockedOutAt;

  String get name => "${lname.capitalizeFirst} ${fname.capitalizeFirst}";
  bool get canClockIn => clockedInAt == null;
  bool get canClockOut => clockedOutAt == null;

  factory Visitor.fromJson(Map<String, dynamic> data) {
    return Visitor(
      fname: data["fname"],
      lname: data['lname'],
      phone: data['phone'],
      date: DateTime.parse(data["date"]),
      vid: data["vid"],
      photo: data["photo"],
      gender: Gender.fromString(data['gender'] as String),
      purpose: Purpose.fromString(data['purpose'] as String),
      department: data["department"],
      clockedInAt: data["clocked_in_at"] != null
          ? DateTime.parse(data["clocked_in_at"])
          : null,
      clockedOutAt: data["clocked_out_at"] != null
          ? DateTime.parse(data["clocked_out_at"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "fname": fname,
      "lname": lname,
      "phone": phone,
      "date": date.toIso8601String(),
      "vid": vid,
      "photo": photo,
      "gender": gender.string.toLowerCase(),
      "purpose": purpose.string.toLowerCase(),
      "department": department,
      "clocked_in_at": clockedInAt?.toIso8601String(),
      "clocked_out_at": clockedOutAt?.toIso8601String(),
    };
  }
}
