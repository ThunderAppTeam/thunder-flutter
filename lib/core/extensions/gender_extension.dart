import 'package:flutter/material.dart';
import 'package:thunder/generated/l10n.dart';
import 'package:thunder/core/enums/gender.dart';

extension GenderX on Gender {
  String toDisplayString(BuildContext context) {
    switch (this) {
      case Gender.male:
        return S.of(context).commonMale;
      case Gender.female:
        return S.of(context).commonFemale;
    }
  }
}
