// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `로그인`
  String get commonLogin {
    return Intl.message(
      '로그인',
      name: 'commonLogin',
      desc: '',
      args: [],
    );
  }

  /// `확인`
  String get commonConfirm {
    return Intl.message(
      '확인',
      name: 'commonConfirm',
      desc: '',
      args: [],
    );
  }

  /// `다음`
  String get commonNext {
    return Intl.message(
      '다음',
      name: 'commonNext',
      desc: '',
      args: [],
    );
  }

  /// `여성`
  String get commonFemale {
    return Intl.message(
      '여성',
      name: 'commonFemale',
      desc: '',
      args: [],
    );
  }

  /// `남성`
  String get commonMale {
    return Intl.message(
      '남성',
      name: 'commonMale',
      desc: '',
      args: [],
    );
  }

  /// `⚡Thunder`
  String get welcomeTitle {
    return Intl.message(
      '⚡Thunder',
      name: 'welcomeTitle',
      desc: '',
      args: [],
    );
  }

  /// `눈바디를 측정하고\n달라진 나를 확인하세요`
  String get welcomeDescription {
    return Intl.message(
      '눈바디를 측정하고\n달라진 나를 확인하세요',
      name: 'welcomeDescription',
      desc: '',
      args: [],
    );
  }

  /// `시작하기`
  String get welcomeStart {
    return Intl.message(
      '시작하기',
      name: 'welcomeStart',
      desc: '',
      args: [],
    );
  }

  /// `이미 계정이 있나요?`
  String get welcomeAlreadyAccount {
    return Intl.message(
      '이미 계정이 있나요?',
      name: 'welcomeAlreadyAccount',
      desc: '',
      args: [],
    );
  }

  /// `계정을 만들기 위해\n휴대폰 번호를 입력해주세요`
  String get phoneNumberTitle {
    return Intl.message(
      '계정을 만들기 위해\n휴대폰 번호를 입력해주세요',
      name: 'phoneNumberTitle',
      desc: '',
      args: [],
    );
  }

  /// `🇰🇷 +82`
  String get phoneNumberFlagCode {
    return Intl.message(
      '🇰🇷 +82',
      name: 'phoneNumberFlagCode',
      desc: '',
      args: [],
    );
  }

  /// `- 없이 숫자만 입력`
  String get phoneNumberInputHint {
    return Intl.message(
      '- 없이 숫자만 입력',
      name: 'phoneNumberInputHint',
      desc: '',
      args: [],
    );
  }

  /// `아래 버튼을 누르면 위에 입력한 휴대폰 번호로 인증문자가 전송될 예정입니다.`
  String get phoneNumberGuideText {
    return Intl.message(
      '아래 버튼을 누르면 위에 입력한 휴대폰 번호로 인증문자가 전송될 예정입니다.',
      name: 'phoneNumberGuideText',
      desc: '',
      args: [],
    );
  }

  /// `인증문자 받기`
  String get phoneNumberButton {
    return Intl.message(
      '인증문자 받기',
      name: 'phoneNumberButton',
      desc: '',
      args: [],
    );
  }

  /// `올바른 휴대폰 번호를 입력해주세요`
  String get phoneNumberErrorTitle {
    return Intl.message(
      '올바른 휴대폰 번호를 입력해주세요',
      name: 'phoneNumberErrorTitle',
      desc: '',
      args: [],
    );
  }

  /// `입력하신 휴대폰 번호가 올바른 형식이 아닙니다. 입력하신 정보를 다시 한 번 확인해주세요.`
  String get phoneNumberErrorSubtitle {
    return Intl.message(
      '입력하신 휴대폰 번호가 올바른 형식이 아닙니다. 입력하신 정보를 다시 한 번 확인해주세요.',
      name: 'phoneNumberErrorSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `6자리 숫자`
  String get verificationHint {
    return Intl.message(
      '6자리 숫자',
      name: 'verificationHint',
      desc: '',
      args: [],
    );
  }

  /// `문자로 받은\n인증번호 6자리를 입력해주세요`
  String get verificationTitle {
    return Intl.message(
      '문자로 받은\n인증번호 6자리를 입력해주세요',
      name: 'verificationTitle',
      desc: '',
      args: [],
    );
  }

  /// `인증문자 다시 받기`
  String get verificationResend {
    return Intl.message(
      '인증문자 다시 받기',
      name: 'verificationResend',
      desc: '',
      args: [],
    );
  }

  /// `인증번호가 틀렸습니다.`
  String get verificationWrongCode {
    return Intl.message(
      '인증번호가 틀렸습니다.',
      name: 'verificationWrongCode',
      desc: '',
      args: [],
    );
  }

  /// `회원등록을 시작할게요!\n어떤 닉네임을 사용하시겠어요?`
  String get nicknameTitle {
    return Intl.message(
      '회원등록을 시작할게요!\n어떤 닉네임을 사용하시겠어요?',
      name: 'nicknameTitle',
      desc: '',
      args: [],
    );
  }

  /// `닉네임 최소 2글자 최대 8글자`
  String get nicknameHint {
    return Intl.message(
      '닉네임 최소 2글자 최대 8글자',
      name: 'nicknameHint',
      desc: '',
      args: [],
    );
  }

  /// `닉네임은 프로필에 표시되는 이름입니다. 나중에 다시 변경할 수 있습니다.`
  String get nicknameGuideText {
    return Intl.message(
      '닉네임은 프로필에 표시되는 이름입니다. 나중에 다시 변경할 수 있습니다.',
      name: 'nicknameGuideText',
      desc: '',
      args: [],
    );
  }

  /// `{nickname}님의\n생년월일은 언제신가요?`
  String birthdateTitle(Object nickname) {
    return Intl.message(
      '$nickname님의\n생년월일은 언제신가요?',
      name: 'birthdateTitle',
      desc: '',
      args: [nickname],
    );
  }

  /// `회원님의 나이 정보가 프로필에 표시됩니다. 생년월일은 공개되지 않습니다.`
  String get birthdateGuideText {
    return Intl.message(
      '회원님의 나이 정보가 프로필에 표시됩니다. 생년월일은 공개되지 않습니다.',
      name: 'birthdateGuideText',
      desc: '',
      args: [],
    );
  }

  /// `올바른 날짜를 입력해주세요`
  String get birthdateInvalidDateTitle {
    return Intl.message(
      '올바른 날짜를 입력해주세요',
      name: 'birthdateInvalidDateTitle',
      desc: '',
      args: [],
    );
  }

  /// `입력하신 생년월일이 올바른 날짜가 아닙니다. 입력하신 정보를 다시 한 번 확인해주세요.`
  String get birthdateInvalidDateSubtitle {
    return Intl.message(
      '입력하신 생년월일이 올바른 날짜가 아닙니다. 입력하신 정보를 다시 한 번 확인해주세요.',
      name: 'birthdateInvalidDateSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `서비스 이용가능 연령이 아니에요`
  String get birthdateInvalidAgeTitle {
    return Intl.message(
      '서비스 이용가능 연령이 아니에요',
      name: 'birthdateInvalidAgeTitle',
      desc: '',
      args: [],
    );
  }

  /// `만 18세 미만은 썬더를 이용하실 수 없어요. 나중에 다시 만나요.`
  String get birthdateInvalidAgeSubtitle {
    return Intl.message(
      '만 18세 미만은 썬더를 이용하실 수 없어요. 나중에 다시 만나요.',
      name: 'birthdateInvalidAgeSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `{nickname}님의\n성별을선택해주세요`
  String genderTitle(Object nickname) {
    return Intl.message(
      '$nickname님의\n성별을선택해주세요',
      name: 'genderTitle',
      desc: '',
      args: [nickname],
    );
  }

  /// `동의하고 시작하기`
  String get termsConfirm {
    return Intl.message(
      '동의하고 시작하기',
      name: 'termsConfirm',
      desc: '',
      args: [],
    );
  }

  /// `썬더를 이용하려면 동의가 필요해요`
  String get termsTitle {
    return Intl.message(
      '썬더를 이용하려면 동의가 필요해요',
      name: 'termsTitle',
      desc: '',
      args: [],
    );
  }

  /// `모두 동의`
  String get termsAllAgree {
    return Intl.message(
      '모두 동의',
      name: 'termsAllAgree',
      desc: '',
      args: [],
    );
  }

  /// `필수`
  String get termsRequired {
    return Intl.message(
      '필수',
      name: 'termsRequired',
      desc: '',
      args: [],
    );
  }

  /// `선택`
  String get termsOptional {
    return Intl.message(
      '선택',
      name: 'termsOptional',
      desc: '',
      args: [],
    );
  }

  /// `서비스 이용약관`
  String get termsService {
    return Intl.message(
      '서비스 이용약관',
      name: 'termsService',
      desc: '',
      args: [],
    );
  }

  /// `개인정보 수집 및 이용`
  String get termsPrivacy {
    return Intl.message(
      '개인정보 수집 및 이용',
      name: 'termsPrivacy',
      desc: '',
      args: [],
    );
  }

  /// `마케팅 정보 수신 동의`
  String get termsMarketing {
    return Intl.message(
      '마케팅 정보 수신 동의',
      name: 'termsMarketing',
      desc: '',
      args: [],
    );
  }

  /// `계정 생성 중 오류가 발생했습니다.`
  String get termsErrorTitle {
    return Intl.message(
      '계정 생성 중 오류가 발생했습니다.',
      name: 'termsErrorTitle',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ko'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
