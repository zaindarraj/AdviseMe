import 'dart:async';

import 'package:advise_me/logic/BloCs/User%20BloC/user_bloc.dart';
import 'package:advise_me/logic/BloCs/languageBloc/language_bloc.dart';
import 'package:advise_me/logic/Repos/userRepo.dart';
import 'package:advise_me/logic/classes/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import '../firebase_chat.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  Future<List>? sessions;
  List newSchedules = [];
  Timer? timer;
  List savedSession = [];
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
              flex: 1,
              child: Text(
                AppLocalizations.of(context)!.coming_sessions,
                style: GoogleFonts.arvo(fontSize: 26),
              )),
          Flexible(
              flex: 4,
              child: FutureBuilder<List>(
                future: sessions,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      savedSession = snapshot.data!;
                      if (savedSession.isEmpty) {
                        return Center(
                          child: Text(
                            AppLocalizations.of(context)!.no_sessions,
                            style: const TextStyle(fontSize: 21),
                          ),
                        );
                      }
                      return AnimatedList(
                          key: listKey,
                          initialItemCount: savedSession.length,
                          itemBuilder: (context, index, animation) {
                            return Container(
                              padding: const EdgeInsets.all(8),
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
                                          height: 70,
                                          width: 70,
                                          child: ClipOval(
                                              child: (savedSession[index]
                                                          ["userImage"] !=
                                                      null
                                                  ? Image.network(
                                                      mainUrl +
                                                          savedSession[index]
                                                              ["userImage"],
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.asset(
                                                      "assets/default.jpg",
                                                      fit: BoxFit.cover,
                                                    )))),
                                      const VerticalDivider(),
                                      Text(snapshot.data![index]["user_name"],
                                          style: GoogleFonts.arvo(fontSize: 18))
                                    ],
                                  ),
                                  BlocBuilder<LanguageBloc, LanguageState>(
                                    builder: (context, state) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              AppLocalizations.of(context)!
                                                      .from +
                                                  savedSession[index]
                                                      ["from_time"],
                                              style: GoogleFonts.arvo(
                                                  fontSize: 18)),
                                          const Icon(Icons.calendar_month),
                                          Text(
                                              AppLocalizations.of(context)!
                                                      .date +
                                                  savedSession[index]["date"],
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
                                              await UserRepo.cancelSession({
                                            "sender_id":
                                                BlocProvider.of<UserBloc>(
                                                        context)
                                                    .user
                                                    .id,
                                            "session_id": savedSession[index]
                                                    ["session_id"]
                                                .toString()
                                          });
                                          if (res["code"].toString() == "1") {
                                            savedSession.removeAt(index);
                                            listKey.currentState!.removeItem(
                                                index, (context, animation) {
                                              return SlideTransition(
                                                position: Tween<Offset>(
                                                        begin:
                                                            const Offset(-1, 0),
                                                        end: const Offset(0, 0))
                                                    .animate(animation),
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.all(5),
                                                  width: size.width * 0.8,
                                                  height: size.height * 0.3,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border:
                                                          Border.all(width: 2)),
                                                  alignment: Alignment.center,
                                                  child: const Text("REMOVING"),
                                                ),
                                              );
                                            });
                                          }
                                        },
                                        child: Container(
                                            padding: const EdgeInsets.all(18),
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .cancel)),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => FirebaseChat(
                                                        remoteId:
                                                            savedSession[index]
                                                                    ["user_id"]
                                                                .toString(),
                                                        reciever_name:
                                                            savedSession[index]
                                                                ["user_name"],
                                                        session_id: savedSession[
                                                                    index]
                                                                ["session_id"]
                                                            .toString(),
                                                      )));
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(18),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .join),
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
                  return const Center(child: LinearProgressIndicator());
                },
              )),
        ],
      ),
    );
  }
}
