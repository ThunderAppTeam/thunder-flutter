class Validators {
  static bool isValidPhoneNumber(String phoneNumber) {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    return cleanNumber.length == 11 && cleanNumber.startsWith('010');
  }

  static bool isValidNickname(String nickname) => nickname.length >= 2;
  static bool isValidAge(DateTime birthDate) => birthDate.year >= 1900;
}
