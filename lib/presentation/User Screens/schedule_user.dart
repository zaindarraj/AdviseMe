import 'dart:async';

import 'package:advise_me/logic/BloCs/Profile%20BloC/profile_bloc.dart';
import 'package:advise_me/logic/BloCs/User%20BloC/user_bloc.dart';
import 'package:advise_me/logic/BloCs/languageBloc/language_bloc.dart';
import 'package:advise_me/logic/Repos/userRepo.dart';
import 'package:advise_me/presentation/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../strings.dart';

class ScheduleUser extends StatefulWidget {
  const ScheduleUser({super.key});

  @override
  State<ScheduleUser> createState() => _ScheduleUserState();
}

class _ScheduleUserState extends State<ScheduleUser> {
  GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  Future<List>? sessions;
  List newSchedules = [];
  List savedSession = [];
  Timer? timer;
  @override
  void initState() {
    sessions = UserRepo.getUpComingSessions(
        {"user_id": BlocProvider.of<UserBloc>(context).user.id.toString()});
    timer = Timer.periodic(const Duration(seconds: 4), (Timer t) async {
      newSchedules = await UserRepo.getUpComingSessions(
          {"user_id": BlocProvider.of<UserBloc>(context).user.id.toString()});
      if (newSchedules.isNotEmpty) {
        for (var element in newSchedules) {
          if (savedSession.isNotEmpty) {
            if (element["session_id"] > savedSession.last["session_id"]) {
              savedSession.add(element);
              listKey.currentState!.insertItem(savedSession.length - 1);
            }
          } else {
            savedSession.add(element);
            listKey.currentState!.insertItem(0);
          }
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is UserProfile) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  flex: 2,
                  child: SafeArea(
                    child: SizedBox(
                        height: size.height * 0.2,
                        width: size.width * 0.4,
                        child: ClipOval(
                            child: (state.userImage! != "null"
                                ? Image.network(
                                    url + state.userImage.toString(),
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    "assets/default.jpg",
                                    fit: BoxFit.cover,
                                  )))),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${state.fname} ${state.lname}",
                        style: GoogleFonts.arvo(fontSize: 32),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: BlocBuilder<LanguageBloc, LanguageState>(
                    builder: (context, state) {
                      return state is English
                          ? Text(
                              "Up Comming Sessions",
                              style: GoogleFonts.arvo(fontSize: 26),
                            )
                          : Text(
                              "الجلسات القادمة",
                              style: GoogleFonts.arvo(fontSize: 26),
                            );
                    },
                  ),
                ),
                Flexible(
                    flex: 4,
                    child: FutureBuilder<List>(
                      future: sessions,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            savedSession = snapshot.data!;
                            return AnimatedList(
                                key: listKey,
                                initialItemCount: savedSession.length,
                                itemBuilder: (context, index, animation) {
                                  return Container(
                                    margin: const EdgeInsets.all(5),
                                    width: size.width * 0.8,
                                    height: size.height * 0.3,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(width: 2)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                                height: size.height * 0.1,
                                                width: size.width * 0.2,
                                                child: ClipOval(
                                                    child: (state.userImage! !=
                                                            "null"
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
                                            const VerticalDivider(),
                                            Text(
                                                snapshot.data![index]
                                                    ["consultant_name"],
                                                style: GoogleFonts.arvo(
                                                    fontSize: 18))
                                          ],
                                        ),
                                        BlocBuilder<LanguageBloc,
                                            LanguageState>(
                                          builder: (context, state) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                    (state is English
                                                        ? ("Time " +
                                                            snapshot.data![
                                                                    index]
                                                                ["from_time"])
                                                        // ignore: prefer_interpolation_to_compose_strings
                                                        : ("${" الوقت" + snapshot.data![index]["from_time"]}")),
                                                    style: GoogleFonts.arvo(
                                                        fontSize: 18)),
                                                const Icon(
                                                    Icons.calendar_month),
                                                Text(
                                                    (state is English
                                                        ? "Date " +
                                                            snapshot.data![
                                                                index]["date"]
                                                        // ignore: prefer_interpolation_to_compose_strings
                                                        : "التاريخ " +
                                                            snapshot.data![
                                                                index]["date"]),
                                                    style: GoogleFonts.arvo(
                                                        fontSize: 18)),
                                              ],
                                            );
                                          },
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                Map<String, dynamic> res =
                                                    await UserRepo
                                                        .cancelSession({
                                                  "sender_id":
                                                      BlocProvider.of<UserBloc>(
                                                              context)
                                                          .user
                                                          .id,
                                                  "session_id": snapshot
                                                      .data![index]
                                                          ["session_id"]
                                                      .toString()
                                                });
                                                if (res["code"].toString() ==
                                                    "1") {
                                                  savedSession.removeAt(index);
                                                  listKey.currentState!
                                                      .removeItem(index,
                                                          (context, animation) {
                                                    return SlideTransition(
                                                      position: Tween<Offset>(
                                                              begin:
                                                                  const Offset(
                                                                      -1, 0),
                                                              end: const Offset(
                                                                  0, 0))
                                                          .animate(animation),
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                            .all(5),
                                                        width: size.width * 0.8,
                                                        height:
                                                            size.height * 0.3,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            border: Border.all(
                                                                width: 2)),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text("REMOVING"),
                                                      ),
                                                    );
                                                  });
                                                }
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(18),
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: BlocBuilder<LanguageBloc,
                                                        LanguageState>(
                                                    builder: (context, state) {
                                                  return Text(state is English
                                                      ? "Cancel Session"
                                                      : "الغاء الجلسة");
                                                }),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                dynamic res =
                                                    await UserRepo.joinSession({
                                                  "sender_id":
                                                      BlocProvider.of<UserBloc>(
                                                              context)
                                                          .user
                                                          .id,
                                                  "session_id": snapshot
                                                      .data![index]
                                                          ["session_id"]
                                                      .toString()
                                                });
                                                print(res);
                                                if (res is! List) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              res)));
                                                } else {
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ChatScreen(
                                                                remoteId: snapshot
                                                                    .data![
                                                                        index][
                                                                        "consultant_id"]
                                                                    .toString(),
                                                                session_id: snapshot
                                                                    .data![
                                                                        index][
                                                                        "session_id"]
                                                                    .toString(),
                                                                name: snapshot
                                                                            .data![
                                                                        index][
                                                                    "consultant_name"],
                                                              ))).then((value) {
                                                    setState(() {
                                                      sessions = UserRepo
                                                          .getUpComingSessions({
                                                        "user_id": BlocProvider
                                                                .of<UserBloc>(
                                                                    context)
                                                            .user
                                                            .id
                                                            .toString()
                                                      });
                                                      savedSession = [];
                                                    });
                                                  });
                                                }
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(18),
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: BlocBuilder<LanguageBloc,
                                                        LanguageState>(
                                                    builder: (context, state) {
                                                  return Text(state is English
                                                      ? "Join Session"
                                                      : "بدأ الجلسة");
                                                }),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                });
                          }
                        }
                        return Container();
                      },
                    )),
              ],
            );
          } else {
            return Text("");
          }
        },
      ),
    );
  }
}
