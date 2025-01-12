import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:thunder/generated/l10n.dart';

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

  String toDisplayString(BuildContext context) {
    switch (this) {
      case Gender.male:
        return S.of(context).commonMale;
      case Gender.female:
        return S.of(context).commonFemale;
    }
  }

  String toJson() {
    return name.toUpperCase();
  }
}
