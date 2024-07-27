part of 'user_bloc.dart';

abstract class UserState {
  const UserState();
}

class UserInitial extends UserState {}

class Loading extends UserState {}

class User extends UserState {
  String verifiedByCode;

  String id;
  String email;
  String password;
  User(
      {required this.verifiedByCode,
      required this.password,
      required this.email,
      required this.id});
}

class Consultant extends UserState {
  String verifiedByCode;
  String verifiedByAdmin;
  String id;
  String email;
  String password;

  Consultant({
    required this.verifiedByAdmin,
    required this.verifiedByCode,
    required this.id,
    required this.password,
    required this.email,
  });
}

class Admin extends UserState {}

class Failed extends UserState {
  String error;
  Failed({required this.error});
}
