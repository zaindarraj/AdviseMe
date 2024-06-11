import 'dart:io';

import 'package:advise_me/logic/BloCs/Profile%20BloC/profile_bloc.dart';
import 'package:advise_me/logic/BloCs/User%20BloC/user_bloc.dart';
import 'package:advise_me/logic/Repos/adminRepo.dart';
import 'package:advise_me/logic/Repos/userRepo.dart';
import 'package:advise_me/logic/classes/image.dart';
import 'package:advise_me/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../logic/BloCs/languageBloc/language_bloc.dart';


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
                child: SingleChildScrollView(
                  child: Container(
                    alignment: Alignment.center,
                    width: size.width * 0.95,
                    height: size.height * 0.9,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StatefulBuilder(builder: ((context, setImageState) {
                          return SizedBox(
                            height: size.height * 0.3,
                            width: size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                    height: size.height * 0.2,
                                    width: size.width * 0.4,
                                    child: ClipOval(
                                        child: path is String
                                            ? Image.file(
                                                File.fromUri(
                                                  Uri.parse(path!),
                                                ),
                                                fit: BoxFit.cover,
                                              )
                                            : (state.userImage! !="null"
                                                ? Image.network(
                                                    url +
                                                        state.userImage
                                                            .toString(),
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.asset(
                                                    "assets/default.jpg",
                                                    fit: BoxFit.cover,
                                                  )))),
                                TextButton(onPressed: () async {
                                  path = await ImageModel.getImage();
                                  setImageState(
                                    () {},
                                  );
                                }, child:
                                    BlocBuilder<LanguageBloc, LanguageState>(
                                  builder: (context, state) {
                                    if (state is English) {
                                      return Text(
                                        "Give your self a new look !",
                                        style: GoogleFonts.arvo(fontSize: 14),
                                      );
                                    } else {
                                      return Text(
                                        "اختر صورة شخصية جديدة لك",
                                        textAlign: TextAlign.end,
                                        style: GoogleFonts.arvo(fontSize: 18),
                                      );
                                    }
                                  },
                                ))
                              ],
                            ),
                          );
                        })),
                        Text(
                          state.fname + " " + state.lname,
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
                              label: BlocBuilder<LanguageBloc, LanguageState>(
                                builder: (context, state) {
                                  if (state is English) {
                                    return Text(
                                      "Your First Name",
                                      style: GoogleFonts.arvo(fontSize: 18),
                                    );
                                  } else {
                                    return Text(
                                      "اسمك الأول",
                                      style: GoogleFonts.arvo(fontSize: 18),
                                    );
                                  }
                                },
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
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
                              label: BlocBuilder<LanguageBloc, LanguageState>(
                                builder: (context, state) {
                                  if (state is English) {
                                    return Text(
                                      "Your Last Name",
                                      style: GoogleFonts.arvo(fontSize: 18),
                                    );
                                  } else {
                                    return Text(
                                      "اسمك الأخير",
                                      style: GoogleFonts.arvo(fontSize: 18),
                                    );
                                  }
                                },
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
                                BlocProvider.of<UserBloc>(context)
                                    .add(SignOut());
                              },
                              child: Container(
                                padding: EdgeInsets.all(5),
                                alignment: Alignment.center,
                                height: size.height * 0.08,
                                width: size.width * 0.4,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: BlocBuilder<LanguageBloc, LanguageState>(
                                  builder: (context, state) {
                                    return Text(
                                      state is English
                                          ? "Sign out"
                                          : "تسجيل الخروج",
                                      style: GoogleFonts.arvo(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    );
                                  },
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await UserRepo.deletAccount(state.id);
                                 BlocProvider.of<UserBloc>(context)
                                    .add(SignOut());
                              },
                              child: Container(
                                width: size.width * 0.4,
                                padding: EdgeInsets.all(5),
                                alignment: Alignment.center,
                                height: size.height * 0.08,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: BlocBuilder<LanguageBloc, LanguageState>(
                                  builder: (context, state) {
                                    return Text(
                                      state is English
                                          ? "Delete"
                                          : "حذف الحساب",
                                      style: GoogleFonts.arvo(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    );
                                  },
                                ),
                              ),
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
                                  SnackBar(
                                      content: Text("Do some changes first!")));
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: size.height * 0.08,
                            width: size.width * 0.7,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: BlocBuilder<LanguageBloc, LanguageState>(
                              builder: (context, state) {
                                return Text(
                                  state is English ? "Modify" : "قم بالتغيير",
                                  style: GoogleFonts.arvo(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
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
