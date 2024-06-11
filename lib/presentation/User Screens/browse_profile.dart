import 'package:advise_me/logic/BloCs/languageBloc/language_bloc.dart';
import 'package:advise_me/logic/Repos/profileRepo.dart';
import 'package:advise_me/logic/Repos/userRepo.dart';
import 'package:advise_me/logic/classes/porfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'browse_schedules.dart';
import '../../logic/BloCs/Profile BloC/profile_bloc.dart';
import '../../strings.dart';

class BrowseConProfile extends StatefulWidget {
  String id;
  BrowseConProfile({super.key, required this.id});

  @override
  State<BrowseConProfile> createState() => _BrowseConProfileState();
}

class _BrowseConProfileState extends State<BrowseConProfile> {
  Map<String, dynamic> changes = {};
  TextEditingController lname = TextEditingController();
  TextEditingController fname = TextEditingController();
  Future<dynamic>? profile;

  @override
  void initState() {
    profile = ProfileRepo.getProfile(super.widget.id);
    super.initState();
  }

  String? path;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Center(
      child: SizedBox(
        width: size.width * 0.9,
        height: size.height,
        child: FutureBuilder<dynamic>(
          future: profile,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                if (snapshot.data is ProfileModel) {
                  ProfileModel profileModel = snapshot.data;
                  return SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.arrow_back_ios_new_rounded))
                          ],
                        ),
                        Container(
                            height: size.height * 0.2,
                            width: size.width * 0.4,
                            child: ClipOval(
                                child: (profileModel.userImage != "null"
                                    ? Image.network(
                                        url + profileModel.userImage!,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        "assets/default.jpg",
                                        fit: BoxFit.cover,
                                      )))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              profileModel.fname + " " + profileModel.lname,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24),
                            ),
                            Text(
                              profileModel.spec is String
                                  ? "* " + profileModel.spec!
                                  : "* Not Specified",
                              overflow: TextOverflow.fade,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 18),
                            )
                          ],
                        ),
                        VerticalDivider(
                          thickness: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.star_rate,
                                      color: Colors.yellow,
                                      size: 40,
                                    ),
                                    Text(
                                      profileModel.rate,
                                      style: TextStyle(fontSize: 18),
                                    )
                                  ],
                                ),
                                BlocBuilder<LanguageBloc, LanguageState>(
                                  builder: (context, lang) {
                                    return Text(
                                      lang is English ? "Feedbacks" : "الاراء",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    );
                                  },
                                )
                              ],
                            ),
                            SizedBox(
                              width: size.width * 0.7,
                              child: BlocBuilder<LanguageBloc, LanguageState>(
                                builder: (context, lang) {
                                  return Text(
                                    profileModel.bio is String
                                        ? profileModel.bio!
                                        : (lang is English
                                            ? "Not Specified"
                                            : "غير مخصص"),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 20),
                                    maxLines: 3,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.5,
                          child: ListView.builder(
                              itemCount: profileModel.feedbacks!.length,
                              itemBuilder: (context, index) {
                                return Container(
                                    margin: const EdgeInsets.all(7),
                                    padding: const EdgeInsets.all(10),
                                    width: size.width * 0.85,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 10,
                                            offset: Offset(2, 2))
                                      ],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: size.width * 0.2,
                                              height: size.height * 0.1,
                                              child: ClipOval(
                                                  child:
                                                      (profileModel.feedbacks![
                                                                      index][
                                                                  "user_img"] is String
                                                          ? Image.network(
                                                              url +
                                                                  profileModel
                                                                      .feedbacks![
                                                                          index]
                                                                          [
                                                                          "user_img"]
                                                                      .toString(),
                                                              fit: BoxFit.cover,
                                                            )
                                                          : Image.asset(
                                                              "assets/default.jpg",
                                                              fit: BoxFit.cover,
                                                            ))),
                                            ),
                                            Text(
                                              profileModel.feedbacks![index]
                                                      ["fname"] +
                                                  " " +
                                                  profileModel.feedbacks![index]
                                                      ["lname"],
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.arvo(
                                                  fontSize: 23,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              profileModel.feedbacks![index]
                                                  ["message"],
                                              maxLines: 6,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.arvo(
                                                  fontSize: 16),
                                            ),
                                          ),
                                        )
                                      ],
                                    ));
                              }),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (contex)=>BrowseSchedules(conID: super.widget.id)
                              ));
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Theme.of(context).primaryColor,
                                ),
                                alignment: Alignment.center,
                                width: size.width,
                                height: size.height * 0.05,
                                child: BlocBuilder<LanguageBloc, LanguageState>(
                                  builder: (context, lang) {
                                    return Text(
                                      lang is English
                                          ? "Book Session"
                                          : "احجذ لي",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    );
                                  },
                                )))
                      ],
                    ),
                  );
                }
              }
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    ));
  }
}
