part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}


class GetProfile extends ProfileEvent{
  String id;
  GetProfile({required this.id});
  @override

  List<Object?> get props => [];

}

class EditProfile extends ProfileEvent{
  Map<String,dynamic> changes;
  EditProfile({required this.changes});
  @override

  List<Object?> get props => [];

}