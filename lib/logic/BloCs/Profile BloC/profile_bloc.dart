import 'package:advise_me/logic/Repos/profileRepo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../classes/porfile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  late ProfileModel profileModel;
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) async {
      if (event is GetProfile) {
        dynamic res = await ProfileRepo.getProfile(event.id);
        if (res is ProfileModel) {
          profileModel = res;
          switch (profileModel.accountType) {
            case "1":
              emit(UserProfile(
                  userImage: profileModel.userImage,
                  message: profileModel.message!,
                  email: profileModel.email,
                  id: profileModel.id,
                  fname: profileModel.fname,
                  lname: profileModel.lname));
              break;
            case "2":
              emit(ConsultantProfile(
                  price: profileModel.price,
                  bio: profileModel.bio,
                  cer: profileModel.cer!,
                  cv: profileModel.cv!,
                  rate: profileModel.rate,
                  userImage: profileModel.userImage,
                  message: profileModel.message!,
                  spec: profileModel.spec,
                  email: profileModel.email,
                  id: event.id,
                  fname: profileModel.fname,
                  lname: profileModel.lname));
          }
        } else {
          add(GetProfile(id: event.id));
        }
      } else if (event is EditProfile) {
        dynamic res = await ProfileRepo.editProfile(event.changes);
        print(res);
        print("hey");

        if (res is ProfileModel) {
          profileModel = res;

          switch (profileModel.accountType) {
            case "1":
              emit(UserProfile(
                  userImage: profileModel.userImage,
                  email: profileModel.email,
                  id: profileModel.id,
                  fname: profileModel.fname,
                  lname: profileModel.lname,
                  message: profileModel.message!));
              break;
            case "2":
              emit(ConsultantProfile(
                  price: profileModel.price,
                  cer: profileModel.cer!,
                  cv: profileModel.cv!,
                  rate: profileModel.rate,
                  bio: profileModel.bio,
                  userImage: profileModel.userImage,
                  message: profileModel.message!,
                  spec: profileModel.spec,
                  email: profileModel.email,
                  id: res.id,
                  fname: profileModel.fname,
                  lname: profileModel.lname));
          }
        } else {}
      }
    });
  }
}
