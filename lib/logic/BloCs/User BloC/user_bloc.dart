import 'dart:async';

import 'package:advise_me/logic/classes/user.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../strings.dart';
import '../../Repos/userRepo.dart';
import '../../local database/flutter_secure_storage.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  late UserModel user;

  UserBloc() : super(UserInitial()) {
    on<UserEvent>((event, emit) async {
      if (event is Signin) {
        if (event.email == adminEmail && event.password == adminPassword) {
          await insert("email", adminEmail);
          await insert("password", adminPassword);
          await insert("state", "1");
          emit(Admin());
        } else {
          dynamic res = await UserRepo.signIn(event.email, event.password);
          if (res is UserModel) {
            user = res;
            switch (user.accountType.toString()) {
              case "1":
                emit(User(
                  verifiedByCode: user.verifiedByCode,
                  id: user.id,
                  email: user.email,
                  password: user.password,
                ));
                break;
              case "2":
                emit(Consultant(
                  verifiedByAdmin: user.verifiedByAdmin,
                  verifiedByCode: user.verifiedByCode,
                  id: user.id,
                  email: user.email,
                  password: user.password,
                ));
                break;
            }
            if (user.verifiedByCode == "1" && user.verifiedByAdmin == "1") {
              await insert("email", user.email);
              await insert("password", user.password);
              await insert("state", "1");
            }
          } else {
            emit(Failed(error: res.toString()));
          }
        }
      } else if (event is CheckStorage) {
        if (await read("state") == "1") {
          add(Signin(
              email: await read("email") as String,
              password: await read("password") as String));
        }
      } else if (event is Signup) {
        dynamic res = await UserRepo.signUp(event.args);
        if (res is UserModel) {
          user = res;
          switch (user.accountType.toString()) {
            case "1":
              emit(User(
                verifiedByCode: user.verifiedByCode,
                id: user.id,
                email: user.email,
                password: user.password,
              ));
              break;
            case "2":
              emit(Consultant(
                verifiedByAdmin: user.verifiedByAdmin,
                verifiedByCode: user.verifiedByCode,
                id: user.id,
                email: user.email,
                password: user.password,
              ));
              break;
          }
        } else {
          emit(Failed(error: res.toString()));
        }
      } else if (event is SignOut) {
        await insert("state", "0");
        emit(UserInitial());
      } else if (event is Verify) {
        dynamic res = await UserRepo.verify(event.id, event.pin);
        if (res is UserModel) {
          user = res;
          switch (user.accountType.toString()) {
            case "1":
              emit(User(
                verifiedByCode: user.verifiedByCode,
                id: user.id,
                email: user.email,
                password: user.password,
              ));
              break;
            case "2":
              emit(Consultant(
                verifiedByAdmin: user.verifiedByAdmin,
                verifiedByCode: user.verifiedByCode,
                id: user.id,
                email: user.email,
                password: user.password,
              ));
              break;
          }
          await insert("email", user.email);
          await insert("password", user.password);
          await insert("state", "1");
        } else {
          emit(Failed(error: res.toString()));
        }
      }
    });
  }
}
