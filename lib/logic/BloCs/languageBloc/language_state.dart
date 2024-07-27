part of 'language_bloc.dart';

abstract class LanguageState extends Equatable {
  Locale locale = Locale("en");

  LanguageState();
}

class Arabic extends LanguageState {
  Arabic() {
    locale = Locale("ar");
  }
  @override
  List<Object> get props => [];
}

class English extends LanguageState {
  English() {
    locale = Locale("en");
  }
  @override
  List<Object> get props => [];
}
