part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

class Signin extends UserEvent {
  String email;
  String password;
  Signin({required this.email, required this.password});
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class Verify extends UserEvent {
  String pin;
  String id;
  Verify({required this.id, required this.pin});
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class Signup extends UserEvent {
  Map<String, dynamic> args;
  Signup(
      {required this.args});
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SignOut extends UserEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CheckStorage extends UserEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
