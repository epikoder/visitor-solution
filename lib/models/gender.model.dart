enum Gender {
  male,
  female;

  static Gender fromString(String s) {
    return s.toLowerCase() == "male" ? Gender.male : Gender.female;
  }

  String get string => this == Gender.male ? "Male" : "Female";
}
