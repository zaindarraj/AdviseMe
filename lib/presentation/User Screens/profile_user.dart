import 'dart:io';

import 'package:advise_me/logic/BloCs/Profile%20BloC/profile_bloc.dart';
import 'package:advise_me/logic/BloCs/User%20BloC/user_bloc.dart';
import 'package:advise_me/logic/Repos/userRepo.dart';
import 'package:advise_me/logic/classes/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../logic/classes/consts.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Map<String, dynamic> changes = {};
  TextEditingController lname = TextEditingController();
  TextEditingController fname = TextEditingController();

  String? path;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is UserProfile) {
            return SafeArea(
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  width: size.width * 0.95,
                  height: size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StatefulBuilder(builder: ((context, setImageState) {
                        return SizedBox(
                          width: size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                  height: 120,
                                  width: 120,
                                  child: ClipOval(
                                      child: path is String
                                          ? Image.file(
                                              File.fromUri(
                                                Uri.parse(path!),
                                              ),
                                              fit: BoxFit.cover,
                                            )
                                          : (state.userImage != null
                                              ? Image.network(
                                                  mainUrl +
                                                      state.userImage
                                                          .toString(),
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.asset(
                                                  "assets/default.jpg",
                                                  fit: BoxFit.cover,
                                                )))),
                              TextButton(
                                  onPressed: () async {
                                    path = await ImageModel.getImage();
                                    setImageState(
                                      () {},
                                    );
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.give_new_look,
                                    style: GoogleFonts.arvo(fontSize: 14),
                                  ))
                            ],
                          ),
                        );
                      })),
                      Text(
                        "${state.fname} ${state.lname}",
                        style: GoogleFonts.arvo(fontSize: 32),
                      ),
                      TextField(
                        controller: fname,
                        decoration: InputDecoration(
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1,
                                  color:
                                      Theme.of(context).secondaryHeaderColor),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1,
                                  color:
                                      Theme.of(context).secondaryHeaderColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1,
                                  color:
                                      Theme.of(context).secondaryHeaderColor),
                            ),
                            label: Text(
                              AppLocalizations.of(context)!.your_first_name,
                              style: GoogleFonts.arvo(fontSize: 14),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: state.fname),
                      ),
                      TextField(
                        controller: lname,
                        decoration: InputDecoration(
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1,
                                  color:
                                      Theme.of(context).secondaryHeaderColor),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1,
                                  color:
                                      Theme.of(context).secondaryHeaderColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1,
                                  color:
                                      Theme.of(context).secondaryHeaderColor),
                            ),
                            label: Text(
                              AppLocalizations.of(context)!.your_last_name,
                              style: GoogleFonts.arvo(fontSize: 18),
                            ),
                            hintText: state.lname,
                            floatingLabelBehavior:
                                FloatingLabelBehavior.always),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              BlocProvider.of<UserBloc>(context).add(SignOut());
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              alignment: Alignment.center,
                              height: size.height * 0.07,
                              width: size.width * 0.4,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                AppLocalizations.of(context)!.sign_out,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context)
                                        .textScaler
                                        .scale(18)),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await UserRepo.deletAccount(state.id);
                              BlocProvider.of<UserBloc>(context).add(SignOut());
                            },
                            child: Container(
                                width: size.width * 0.4,
                                padding: const EdgeInsets.all(5),
                                alignment: Alignment.center,
                                height: size.height * 0.07,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  AppLocalizations.of(context)!.delete,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: MediaQuery.of(context)
                                          .textScaler
                                          .scale(18)),
                                )),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          if (fname.text.isNotEmpty) {
                            changes["fname"] = fname.text;
                          }
                          if (lname.text.isNotEmpty) {
                            changes["lname"] = lname.text;
                          }
                          if (path is String) {
                            if (path!.isNotEmpty) {
                              changes["img"] = path;
                            }
                          }
                          if (changes.isNotEmpty) {
                            changes["id"] = state.id;
                            BlocProvider.of<ProfileBloc>(context)
                                .add(EditProfile(changes: changes));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Do some changes first!")));
                          }
                        },
                        child: Container(
                            alignment: Alignment.center,
                            height: size.height * 0.07,
                            width: size.width * 0.7,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              AppLocalizations.of(context)!.update,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context)
                                      .textScaler
                                      .scale(18)),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const Text("");
        },
      ),
    );
  }
}
