import 'dart:async';

import 'package:advise_me/logic/BloCs/User%20BloC/user_bloc.dart';
import 'package:advise_me/logic/BloCs/languageBloc/language_bloc.dart';
import 'package:advise_me/logic/Repos/userRepo.dart';
import 'package:advise_me/logic/classes/consts.dart';
import 'package:advise_me/presentation/firebase_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

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
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

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
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SafeArea(
                  child: Text(
                AppLocalizations.of(context)!.coming_sessions,
                style: GoogleFonts.arvo(fontSize: 18),
              )),
            ),
          ),
        ),
        Flexible(
            flex: 5,
            child: FutureBuilder<List>(
              future: sessions,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    savedSession = snapshot.data!;
                    return savedSession.isEmpty
                        ? Center(
                            child: Text(
                              AppLocalizations.of(context)!.no_sessions,
                              style: const TextStyle(fontSize: 21),
                            ),
                          )
                        : AnimatedList(
                            key: listKey,
                            initialItemCount: savedSession.length,
                            itemBuilder: (context, index, animation) {
                              return Container(
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.all(5),
                                width: size.width * 0.8,
                                height: size.height * 0.3,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(width: 1)),
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
                                                            ["image_url"] ==
                                                        "null"
                                                    ? Image.network(
                                                        mainUrl +
                                                            savedSession[index]
                                                                ["image_url"],
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context,
                                                            ob, stack) {
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
                                        const VerticalDivider(),
                                        Text(
                                            savedSession[index]
                                                ["consultant_name"],
                                            style:
                                                GoogleFonts.arvo(fontSize: 18))
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
                                                        .time +
                                                    savedSession[index]
                                                        ["from_time"],
                                                style: GoogleFonts.arvo(
                                                    fontSize: 18)),
                                            const Icon(Icons.calendar_month),
                                            Text(
                                                AppLocalizations.of(context)!
                                                        .to +
                                                    savedSession[index]
                                                        ["to_time"],
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
                                                          begin: const Offset(
                                                              -1, 0),
                                                          end: const Offset(
                                                              0, 0))
                                                      .animate(animation),
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.all(5),
                                                    width: size.width * 0.8,
                                                    height: size.height * 0.3,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                            width: 2)),
                                                    alignment: Alignment.center,
                                                    child:
                                                        const Text("REMOVING"),
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
                                                    .cancel),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        FirebaseChat(
                                                          remoteId: savedSession[
                                                                      index][
                                                                  "consultant_id"]
                                                              .toString(),
                                                          reciever_name:
                                                              savedSession[
                                                                      index][
                                                                  "consultant_name"],
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
                  return Center(
                    child: Text(AppLocalizations.of(context)!.no_sessions),
                  );
                }
                return const Center(child: LinearProgressIndicator());
              },
            )),
      ],
    ));
  }
}
