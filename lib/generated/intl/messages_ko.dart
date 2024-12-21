// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ko locale. All the
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
  String get localeName => 'ko';

  static String m0(nickname) => "${nickname}님의\n생년월일은 언제신가요?";

  static String m1(nickname) => "${nickname}님의\n성별을 알려주세요";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "birthdateGuideText": MessageLookupByLibrary.simpleMessage(
            "회원님의 나이 정보가 프로필에 표시됩니다. 생년월일은 공개되지 않습니다."),
        "birthdateInvalidAgeSubtitle": MessageLookupByLibrary.simpleMessage(
            "만 18세 미만은 썬더를 이용하실 수 없어요. 나중에 다시 만나요."),
        "birthdateInvalidAgeTitle":
            MessageLookupByLibrary.simpleMessage("서비스 이용가능 연령이 아니에요"),
        "birthdateInvalidDateSubtitle": MessageLookupByLibrary.simpleMessage(
            "입력하신 생년월일이 올바른 날짜가 아닙니다. 입력하신 정보를 다시 한 번 확인해주세요."),
        "birthdateInvalidDateTitle":
            MessageLookupByLibrary.simpleMessage("올바른 날짜를 입력해주세요"),
        "birthdateTitle": m0,
        "commonConfirm": MessageLookupByLibrary.simpleMessage("확인"),
        "commonFemale": MessageLookupByLibrary.simpleMessage("여성"),
        "commonLogin": MessageLookupByLibrary.simpleMessage("로그인"),
        "commonMale": MessageLookupByLibrary.simpleMessage("남성"),
        "commonNext": MessageLookupByLibrary.simpleMessage("다음"),
        "genderTitle": m1,
        "nicknameGuideText": MessageLookupByLibrary.simpleMessage(
            "닉네임은 프로필에 표시되는 이름입니다. 나중에 다시 변경할 수 있습니다."),
        "nicknameHint":
            MessageLookupByLibrary.simpleMessage("닉네임 최소 2글자 최대 8글자"),
        "nicknameTitle": MessageLookupByLibrary.simpleMessage(
            "회원등록을 시작할게요!\n어떤 닉네임을 사용하시겠어요?"),
        "phoneNumberButton": MessageLookupByLibrary.simpleMessage("인증문자 받기"),
        "phoneNumberErrorSubtitle": MessageLookupByLibrary.simpleMessage(
            "입력하신 휴대폰 번호가 올바른 형식이 아닙니다. 입력하신 정보를 다시 한 번 확인해주세요."),
        "phoneNumberErrorTitle":
            MessageLookupByLibrary.simpleMessage("올바른 휴대폰 번호를 입력해주세요"),
        "phoneNumberFlagCode": MessageLookupByLibrary.simpleMessage("🇰🇷 +82"),
        "phoneNumberGuideText": MessageLookupByLibrary.simpleMessage(
            "아래 버튼을 누르면 위에 입력한 휴대폰 번호로 인증문자가 전송될 예정입니다."),
        "phoneNumberInputHint":
            MessageLookupByLibrary.simpleMessage("- 없이 숫자만 입력"),
        "phoneNumberTitle":
            MessageLookupByLibrary.simpleMessage("계정을 만들기 위해\n휴대폰 번호를 입력해주세요"),
        "termsAllAgree": MessageLookupByLibrary.simpleMessage("모두 동의"),
        "termsConfirm": MessageLookupByLibrary.simpleMessage("동의하고 시작하기"),
        "termsMarketing": MessageLookupByLibrary.simpleMessage("마케팅 정보 수신 동의"),
        "termsOptional": MessageLookupByLibrary.simpleMessage("선택"),
        "termsPrivacy": MessageLookupByLibrary.simpleMessage("개인정보 수집 및 이용"),
        "termsRequired": MessageLookupByLibrary.simpleMessage("필수"),
        "termsService": MessageLookupByLibrary.simpleMessage("서비스 이용약관"),
        "termsTitle":
            MessageLookupByLibrary.simpleMessage("썬더를 이용하려면 동의가 필요해요"),
        "verificationHint": MessageLookupByLibrary.simpleMessage("6자리 숫자"),
        "verificationResend":
            MessageLookupByLibrary.simpleMessage("인증문자 다시 받기"),
        "verificationTitle":
            MessageLookupByLibrary.simpleMessage("문자로 받은\n인증번호 6자리를 입력해주세요"),
        "verificationWrongCode":
            MessageLookupByLibrary.simpleMessage("인증번호가 틀렸습니다."),
        "welcomeAlreadyAccount":
            MessageLookupByLibrary.simpleMessage("이미 계정이 있나요?"),
        "welcomeDescription":
            MessageLookupByLibrary.simpleMessage("눈바디를 측정하고\n달라진 나를 확인하세요"),
        "welcomeStart": MessageLookupByLibrary.simpleMessage("시작하기"),
        "welcomeTitle": MessageLookupByLibrary.simpleMessage("⚡Thunder")
      };
}
