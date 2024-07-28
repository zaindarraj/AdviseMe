part of 'profile_bloc.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {}

class UserProfile extends ProfileState {
  String id;
  String message;
  String? userImage;
  String fname;
  String lname;
  String email;
  String? invoiceNum;
  UserProfile({
    required this.message,
    required this.email,
    required this.id,
    required this.fname,
    required this.lname,
    this.userImage,
    this.invoiceNum,
  });
}

class ConsultantProfile extends ProfileState {
  String? image;
  String id;
  String message;
  String cv;
  String cer;
  String? userImage;
  String? spec;
  String fname;
  String lname;
  String? bio;
  String email;
  String rate;
  int price = 0;
  ConsultantProfile(
      {required this.message,
      required this.rate,
      required this.price,
      required this.cv,
      required this.cer,
      this.bio,
      required this.spec,
      required this.email,
      required this.id,
      required this.fname,
      required this.lname,
      this.userImage,
      this.image});
}

class WaitAdmin extends ProfileState {}
