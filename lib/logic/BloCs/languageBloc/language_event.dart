part of 'language_bloc.dart';

abstract class LanguageEvent extends Equatable {
  const LanguageEvent();
}

class StartUp extends LanguageEvent {
  @override
  List<Object> get props => [];
}

class Select extends LanguageEvent {
  bool english;
  Select({required this.english});
  @override
  List<Object> get props => [english];
}
