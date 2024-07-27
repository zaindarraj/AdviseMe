import 'dart:ui';

import 'package:advise_me/logic/local%20database/flutter_secure_storage.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(English()) {
    on<LanguageEvent>((event, emit) async {
      if (event is StartUp) {
        if (await read("lan") == "ar") {
          emit(Arabic());
        } else {
          emit(English());
        }
      } else if (event is Select) {
        if (event.english) {
          await insert("lan", "en");
          emit(English());
        } else {
          await insert("lan", "ar");

          emit(Arabic());
        }
      }
    });
  }
}
