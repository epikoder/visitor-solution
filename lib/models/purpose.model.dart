enum Purpose {
  appointment,
  visit;

  Purpose fromString(String s) {
    return s.toLowerCase() == "appointment"
        ? Purpose.appointment
        : Purpose.visit;
  }

  String get string => this == Purpose.appointment ? "Appointment" : "Visit";
}
