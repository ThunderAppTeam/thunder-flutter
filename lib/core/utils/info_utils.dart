import 'dart:io';

String getCountryCode() {
  return Platform.localeName.split('_').last;
}
