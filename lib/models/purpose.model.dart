enum Purpose {
  appointment,
  visit;

  static Purpose fromString(String s) {
    return s.toLowerCase() == "appointment"
        ? Purpose.appointment
        : Purpose.visit;
  }

  String get string => this == Purpose.appointment ? "Appointment" : "Visit";
}
