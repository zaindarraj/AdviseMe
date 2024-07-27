import 'package:advise_me/logic/BloCs/User%20BloC/user_bloc.dart';
import 'package:advise_me/presentation/verification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/BloCs/Profile BloC/profile_bloc.dart';
import 'Admin Screens/admin.dart';
import 'Con Screens/home_con.dart';
import 'User Screens/home_user.dart';
import 'main_screen.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        print(state);
        if (state is Failed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.error),
          ));
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const MainScreen()),
              (Route<dynamic> route) => false);
        } else if (state is User) {
          if (state.verifiedByCode == "1") {
            BlocProvider.of<ProfileBloc>(context).add(GetProfile(id: state.id));
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const HomeUser()),
                (Route<dynamic> route) => false);
          } else {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const VerificationScreen()));
          }
        } else if (state is Admin) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const AdminScreen()),
              (Route<dynamic> route) => false);
        } else if (state is Consultant) {
          if (state.verifiedByCode == "1") {
            if (state.verifiedByAdmin == "1") {
              BlocProvider.of<ProfileBloc>(context)
                  .add(GetProfile(id: state.id));
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const HomeCon()),
                  (Route<dynamic> route) => false);
            } else {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const MainScreen()),
                  (Route<dynamic> route) => false);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Pending Admin's Approval")));
            }
          } else {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const VerificationScreen()));
          }
        }
      },
      child: Center(child: Image.asset("assets/icon.png")),
    ));
  }
}
