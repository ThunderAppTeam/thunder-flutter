// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "commonConfirm": MessageLookupByLibrary.simpleMessage("확인"),
        "commonLogin": MessageLookupByLibrary.simpleMessage("로그인"),
        "phoneNumberButton": MessageLookupByLibrary.simpleMessage("인증문자 받기"),
        "phoneNumberFlagCode": MessageLookupByLibrary.simpleMessage("🇰🇷 +82"),
        "phoneNumberGuideText": MessageLookupByLibrary.simpleMessage(
            "아래 버튼을 누르면 위에 입력한 휴대폰 번호로 인증문자가 전송될 예정입니다."),
        "phoneNumberInputHint":
            MessageLookupByLibrary.simpleMessage("- 없이 숫자만 입력"),
        "phoneNumberTitle":
            MessageLookupByLibrary.simpleMessage("계정을 만들기 위해\n휴대폰 번호를 입력해주세요"),
        "verificationHint": MessageLookupByLibrary.simpleMessage("6자리 숫자"),
        "verificationResend":
            MessageLookupByLibrary.simpleMessage("인증문자 다시 받기"),
        "verificationTitle":
            MessageLookupByLibrary.simpleMessage("문자로 받은\n인증번호 6자리를 입력해주세요"),
        "welcomeAlreadyAccount":
            MessageLookupByLibrary.simpleMessage("이미 계정이 있나요?"),
        "welcomeDescription":
            MessageLookupByLibrary.simpleMessage("눈바디를 측정하고\n달라진 나를 확인하세요"),
        "welcomeStart": MessageLookupByLibrary.simpleMessage("시작하기"),
        "welcomeTitle": MessageLookupByLibrary.simpleMessage("⚡Thunder")
      };
}
