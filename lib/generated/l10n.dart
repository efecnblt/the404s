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

  /// `Onboarding and Auth Example`
  String get appTitle {
    return Intl.message(
      'Onboarding and Auth Example',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `Learn Anything Anytime`
  String get learnAnytimeTitle {
    return Intl.message(
      'Learn Anything Anytime',
      name: 'learnAnytimeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Get a learning boost with thousands of worksheets, lesson plans, and more from our library.`
  String get learnAnytimeDescription {
    return Intl.message(
      'Get a learning boost with thousands of worksheets, lesson plans, and more from our library.',
      name: 'learnAnytimeDescription',
      desc: '',
      args: [],
    );
  }

  /// `Track Your Progress`
  String get trackProgressTitle {
    return Intl.message(
      'Track Your Progress',
      name: 'trackProgressTitle',
      desc: '',
      args: [],
    );
  }

  /// `Follow your learning journey with our progress tracking tools and see how far you’ve come.`
  String get trackProgressDescription {
    return Intl.message(
      'Follow your learning journey with our progress tracking tools and see how far you’ve come.',
      name: 'trackProgressDescription',
      desc: '',
      args: [],
    );
  }

  /// `Join the Community`
  String get joinCommunityTitle {
    return Intl.message(
      'Join the Community',
      name: 'joinCommunityTitle',
      desc: '',
      args: [],
    );
  }

  /// `Connect with learners worldwide and participate in discussions, challenges, and much more!`
  String get joinCommunityDescription {
    return Intl.message(
      'Connect with learners worldwide and participate in discussions, challenges, and much more!',
      name: 'joinCommunityDescription',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signup {
    return Intl.message(
      'Sign Up',
      name: 'signup',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Create a account`
  String get createAccount {
    return Intl.message(
      'Create a account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email`
  String get enterEmail {
    return Intl.message(
      'Enter your email',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get enterPassword {
    return Intl.message(
      'Enter your password',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Forgot?`
  String get forgot {
    return Intl.message(
      'Forgot?',
      name: 'forgot',
      desc: '',
      args: [],
    );
  }

  /// `Confirm your password`
  String get confirmPassword {
    return Intl.message(
      'Confirm your password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `Select Your Language`
  String get languageSelection {
    return Intl.message(
      'Select Your Language',
      name: 'languageSelection',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Turkish`
  String get turkish {
    return Intl.message(
      'Turkish',
      name: 'turkish',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signupScreenTitle {
    return Intl.message(
      'Sign Up',
      name: 'signupScreenTitle',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginScreenTitle {
    return Intl.message(
      'Login',
      name: 'loginScreenTitle',
      desc: '',
      args: [],
    );
  }

  /// `Signup Successful!`
  String get signupSuccess {
    return Intl.message(
      'Signup Successful!',
      name: 'signupSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Login Successful!`
  String get loginSuccess {
    return Intl.message(
      'Login Successful!',
      name: 'loginSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Start Learning today`
  String get startLearning {
    return Intl.message(
      'Start Learning today',
      name: 'startLearning',
      desc: '',
      args: [],
    );
  }

  /// `Keep Learning`
  String get keepLearning {
    return Intl.message(
      'Keep Learning',
      name: 'keepLearning',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get haveAccount {
    return Intl.message(
      'Already have an account?',
      name: 'haveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Are you new here?`
  String get noAccount {
    return Intl.message(
      'Are you new here?',
      name: 'noAccount',
      desc: '',
      args: [],
    );
  }

  /// `Log in to`
  String get loginTo {
    return Intl.message(
      'Log in to',
      name: 'loginTo',
      desc: '',
      args: [],
    );
  }

  /// `Or log in with Email`
  String get orLoginWithEmail {
    return Intl.message(
      'Or log in with Email',
      name: 'orLoginWithEmail',
      desc: '',
      args: [],
    );
  }

  /// `Log in with Google`
  String get loginWithGoogle {
    return Intl.message(
      'Log in with Google',
      name: 'loginWithGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get welcome {
    return Intl.message(
      'Welcome',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Recommended courses`
  String get recommended {
    return Intl.message(
      'Recommended courses',
      name: 'recommended',
      desc: '',
      args: [],
    );
  }

  /// `{count} votes`
  String votesCount(Object count) {
    return Intl.message(
      '$count votes',
      name: 'votesCount',
      desc: '',
      args: [count],
    );
  }

  /// `Your progress in Courses`
  String get yourProgressInCourses {
    return Intl.message(
      'Your progress in Courses',
      name: 'yourProgressInCourses',
      desc: '',
      args: [],
    );
  }

  /// `All level`
  String get allLevel {
    return Intl.message(
      'All level',
      name: 'allLevel',
      desc: '',
      args: [],
    );
  }

  /// `Beginner`
  String get beginner {
    return Intl.message(
      'Beginner',
      name: 'beginner',
      desc: '',
      args: [],
    );
  }

  /// `Math 101`
  String get mathCourseName101 {
    return Intl.message(
      'Math 101',
      name: 'mathCourseName101',
      desc: '',
      args: [],
    );
  }

  /// `All can be perfect in math...`
  String get mathDescription101 {
    return Intl.message(
      'All can be perfect in math...',
      name: 'mathDescription101',
      desc: '',
      args: [],
    );
  }

  /// `Math 102`
  String get mathCourseName102 {
    return Intl.message(
      'Math 102',
      name: 'mathCourseName102',
      desc: '',
      args: [],
    );
  }

  /// `All can be perfect in math...`
  String get mathDescription102 {
    return Intl.message(
      'All can be perfect in math...',
      name: 'mathDescription102',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
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
      Locale.fromSubtags(languageCode: 'tr'),
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
