import 'dart:io';

import 'package:advise_me/logic/BloCs/Profile%20BloC/profile_bloc.dart';
import 'package:advise_me/logic/BloCs/User%20BloC/user_bloc.dart';
import 'package:advise_me/logic/Repos/userRepo.dart';
import 'package:advise_me/logic/classes/image.dart';
import 'package:advise_me/presentation/Con%20Screens/browse_schedules.dart';
import 'package:advise_me/presentation/Con%20Screens/calendar.dart';
import 'package:advise_me/strings.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../logic/BloCs/languageBloc/language_bloc.dart';

class ConProfileScreen extends StatefulWidget {
  const ConProfileScreen({super.key});

  @override
  State<ConProfileScreen> createState() => _ConProfileScreenState();
}

class _ConProfileScreenState extends State<ConProfileScreen> {
  Map<String, dynamic> changes = {};
  TextEditingController lname = TextEditingController();
  TextEditingController fname = TextEditingController();
  TextEditingController bio = TextEditingController();
  FilePickerResult? cer;
  FilePickerResult? cv;
  String? path;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ConsultantProfile) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is ConsultantProfile) {
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
                            height: size.height * 0.25,
                            width: size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                    height: size.height * 0.15,
                                    width: size.width * 0.35,
                                    child: ClipOval(
                                        child: path is String
                                            ? Image.file(
                                                File.fromUri(
                                                  Uri.parse(path!),
                                                ),
                                                fit: BoxFit.cover,
                                              )
                                            : (state.userImage! != "null"
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${state.fname} ${state.lname}",
                              style: GoogleFonts.arvo(fontSize: 30),
                            ),
                            Text(
                              " *${state.spec!}",
                              style: GoogleFonts.arvo(fontSize: 30),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rate_sharp,
                              color: Colors.yellow,
                            ),
                            Text(
                              state.rate,
                              style: const TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                BlocBuilder<LanguageBloc, LanguageState>(
                                  builder: (context, lan) {
                                    if (lan is English) {
                                      return const Text("Certificate : ");
                                    } else {
                                      return const Text("الشهادة : ");
                                    }
                                  },
                                ),
                                IconButton(
                                    onPressed: () async {
                                      cer = await FilePicker.platform.pickFiles(
                                          type: FileType.custom,
                                          allowedExtensions: ['pdf']);
                                    },
                                    icon: const Icon(Icons.attach_file))
                              ],
                            ),
                            Row(
                              children: [
                                BlocBuilder<LanguageBloc, LanguageState>(
                                  builder: (context, lan) {
                                    if (lan is English) {
                                      return const Text(
                                        "CV : ",
                                      );
                                    } else {
                                      return const Text(
                                        "السيرة الذاتية : ",
                                      );
                                    }
                                  },
                                ),
                                IconButton(
                                    onPressed: () async {
                                      cv = await FilePicker.platform.pickFiles(
                                          type: FileType.custom,
                                          allowedExtensions: ['pdf']);
                                    },
                                    icon: const Icon(Icons.attach_file))
                              ],
                            ),
                            Row(
                              children: [
                                BlocBuilder<LanguageBloc, LanguageState>(
                                  builder: (context, lan) {
                                    if (lan is English) {
                                      return const Text("Schedule : ");
                                    } else {
                                      return const Text("الجدول : ");
                                    }
                                  },
                                ),
                                IconButton(
                                    onPressed: () async {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                   BrowseSchedulesCon(conID: state.id,)));
                                    },
                                    icon: const Icon(Icons.calendar_month))
                              ],
                            ),
                          ],
                        ),
                        TextField(
                          controller: bio,
                          maxLines: 2,
                          maxLength: 50,
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
                                      "Your Bio",
                                      style: GoogleFonts.arvo(fontSize: 18),
                                    );
                                  } else {
                                    return Text(
                                      "نبذة عنك",
                                      style: GoogleFonts.arvo(fontSize: 18),
                                    );
                                  }
                                },
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              hintText: state.bio),
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
                                padding: const EdgeInsets.all(5),
                                alignment: Alignment.center,
                                height: size.height * 0.08,
                                width: size.width * 0.25,
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
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
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
                                width: size.width * 0.3,
                                padding: const EdgeInsets.all(5),
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
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    );
                                  },
                                ),
                              ),
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
                                if (bio.text.isNotEmpty) {
                                  changes["bio"] = bio.text;
                                }
                                if(cer is FilePickerResult){
                              changes["certificate"] = cer!.files.first.path;
                                }
                                if(cv is FilePickerResult){
                                  
                              changes["cv"] = cv!.files.first.path;
                                }
                                if (changes.isNotEmpty) {
                                  changes["id"] = state.id;
                                  BlocProvider.of<ProfileBloc>(context)
                                      .add(EditProfile(changes: changes));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text("Do some changes first!")));
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: size.height * 0.08,
                                width: size.width * 0.25,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: BlocBuilder<LanguageBloc, LanguageState>(
                                  builder: (context, state) {
                                    return Text(
                                      state is English
                                          ? "Modify"
                                          : "قم بالتغيير",
                                      style: GoogleFonts.arvo(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
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
