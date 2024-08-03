import 'package:advise_me/logic/classes/user.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../strings.dart';
import '../../Repos/userRepo.dart';
import '../../local database/flutter_secure_storage.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  late UserModel user;

  UserBloc() : super(UserInitial()) {
    on<UserEvent>((event, emit) async {
      print(event);
      if (event is Signin) {
        emit(Loading());
        print(event.email);
        if (event.email == adminEmail && event.password == adminPassword) {
          await insert("email", adminEmail);
          await insert("password", adminPassword);
          await insert("state", "1");
          emit(Admin());
        } else {
          try {
            final credential = await FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: event.email, password: event.password);
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
          } on FirebaseAuthException catch (e) {
            emit(Failed(error: 'No user found for that email.'));

            if (e.code == 'user-not-found') {
              emit(Failed(error: 'No user found for that email.'));

              print('No user found for that email.');
            } else if (e.code == 'wrong-password') {
              emit(Failed(error: 'Wrong password provided for that user.'));

              print('Wrong password provided for that user.');
            }
          }
        }
      } else if (event is CheckStorage) {
        try {
          if (await read("state") == "1") {
            final credential = await FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: await read("email") as String,
                    password: await read("password") as String);
            add(Signin(
                email: await read("email") as String,
                password: await read("password") as String));
          } else {
            emit(UserInitial());
          }
        } on Exception catch (e) {
          emit(UserInitial());
        }
      } else if (event is Signup) {
        emit(Loading());

        try {
          final credential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: event.args["email"],
            password: event.args["password"],
          );
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
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            print('The password provided is too weak.');
            emit(Failed(error: "The password provided is too weak."));
          } else if (e.code == 'email-already-in-use') {
            emit(Failed(error: "Email already used"));
          }
        } catch (e) {
          print(e);
        }
      } else if (event is SignOut) {
        await insert("state", "0");
        emit(UserInitial());
      } else if (event is Verify) {
        emit(Loading());

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
