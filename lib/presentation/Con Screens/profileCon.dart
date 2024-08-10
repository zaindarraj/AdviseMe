import 'dart:io';

import 'package:advise_me/logic/BloCs/Profile%20BloC/profile_bloc.dart';
import 'package:advise_me/logic/BloCs/User%20BloC/user_bloc.dart';
import 'package:advise_me/logic/Repos/userRepo.dart';
import 'package:advise_me/logic/classes/consts.dart';
import 'package:advise_me/logic/classes/image.dart';
import 'package:advise_me/presentation/Con%20Screens/browse_schedules.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

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
  TextEditingController price = TextEditingController();

  FilePickerResult? cer;
  FilePickerResult? cv;
  String? path;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          print(state);
          if (state is ConsultantProfile) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Waiting Admin's Approval")));
          }
        },
        builder: (context, state) {
          if (state is ConsultantProfile) {
            if (price.text.isEmpty) {
              price.text = state.price.toString();
            }
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
                                            : (state.userImage is String
                                                ? CachedNetworkImage(
                                                    imageUrl: mainUrl +
                                                        state.userImage
                                                            .toString(),
                                                    fit: BoxFit.cover,
                                                    errorWidget: (c, a, v) {
                                                      return Image.asset(
                                                        "assets/default.jpg",
                                                        fit: BoxFit.cover,
                                                      );
                                                    },
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
                                      AppLocalizations.of(context)!
                                          .give_new_look,
                                      style: GoogleFonts.arvo(fontSize: 14),
                                    ))
                              ],
                            ),
                          );
                        })),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 3,
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: Text(
                                  "${state.fname} ${state.lname}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                " *${state.spec != null ? state.spec! : AppLocalizations.of(context)!.not_spec}",
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
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
                            ),
                            Expanded(
                                child: TextField(
                              controller: price,
                              decoration: InputDecoration(
                                  label: Text(AppLocalizations.of(context)!
                                      .price_dotted)),
                            ))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                Text(AppLocalizations.of(context)!.certificate),
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
                                Text(
                                  AppLocalizations.of(context)!.cv,
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
                                Text(
                                    AppLocalizations.of(context)!.set_schedule),
                                IconButton(
                                    onPressed: () async {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  BrowseSchedulesCon(
                                                    conID: state.id,
                                                  )));
                                    },
                                    icon: const Icon(Icons.calendar_month))
                              ],
                            ),
                          ],
                        ),
                        TextField(
                          controller: bio,
                          maxLines: 1,
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
                              label: Text(
                                AppLocalizations.of(context)!.bio,
                                style: GoogleFonts.arvo(fontSize: 18),
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
                              label: Text(
                                AppLocalizations.of(context)!.your_first_name,
                                style: GoogleFonts.arvo(fontSize: 18),
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
                                child:
                                    Text(AppLocalizations.of(context)!.sign_out,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
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
                                child:
                                    Text(AppLocalizations.of(context)!.delete,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (price.text != "0") {
                                  changes["price"] = price.text;
                                }
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
                                if (cer is FilePickerResult) {
                                  changes["certificate"] =
                                      cer!.files.first.path;
                                }
                                if (cv is FilePickerResult) {
                                  changes["cv"] = cv!.files.first.path;
                                }
                                if (changes.isNotEmpty) {
                                  changes["id"] = state.id;
                                  BlocProvider.of<ProfileBloc>(context)
                                      .add(EditProfile(changes: changes));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Waiting Admin's Approval!")));
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
                                child: Text(
                                  AppLocalizations.of(context)!.update,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
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
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: const LinearProgressIndicator()),
          );
        },
      ),
    );
  }
}
