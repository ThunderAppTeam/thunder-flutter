import 'package:json_annotation/json_annotation.dart';

class GenderConsts {
  static const String male = 'MALE';
  static const String female = 'FEMALE';
}

enum Gender {
  @JsonValue(GenderConsts.male)
  male,
  @JsonValue(GenderConsts.female)
  female;
}

extension GenderX on Gender {
  static Gender fromString(String value) {
    return Gender.values.firstWhere((e) => e.name == value.toLowerCase());
  }

  String toJson() {
    return name.toUpperCase();
  }
}
