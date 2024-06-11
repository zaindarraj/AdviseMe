import 'dart:async';
import 'dart:io';

import 'package:advise_me/logic/BloCs/User%20BloC/user_bloc.dart';
import 'package:advise_me/logic/BloCs/languageBloc/language_bloc.dart';
import 'package:advise_me/logic/Repos/userRepo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../logic/classes/image.dart';
import '../strings.dart';

class ChatScreen extends StatefulWidget {
  String session_id;
  String name;
  String remoteId;
  ChatScreen({
    required this.remoteId,
    super.key,
    required this.session_id,
    required this.name,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //rating stars
  List<IconButton> stars = [];
  List<Color> starColor = List.generate(5, (index) => Colors.grey);
  TextEditingController message = TextEditingController();
  ScrollController scrollController = ScrollController();
  Timer? timer;
  Future? chats;
  List savedChats = [];
  GlobalKey<AnimatedListState> list = GlobalKey<AnimatedListState>();
  List newMessages = [];
  int rate = 0;
  String? path;

  TextEditingController feed = TextEditingController();
  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) async {
      newMessages = await UserRepo.newMessages({
        "current_user": BlocProvider.of<UserBloc>(context).user.id,
        "session_id": super.widget.session_id
      });
      for (var element in newMessages) {
        if (element["msg_id"] > savedChats.last["msg_id"] &&
            element["sender_id"].toString() !=
                BlocProvider.of<UserBloc>(context).user.id) {
          savedChats.add(element);
          list.currentState!.insertItem(savedChats.length - 1);
        }
      }
      if (scrollController.hasClients) {}
    });

    chats = UserRepo.joinSession({"session_id": super.widget.session_id});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
            future: chats,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  if (snapshot.data.runtimeType == List<dynamic>) {
                    savedChats = snapshot.data;
                    return Column(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(Icons.arrow_back)),
                                  Text(
                                    super.widget.name,
                                    style: GoogleFonts.arvo(fontSize: 24),
                                  ),
                                ],
                              ),
                              IconButton(
                                  onPressed: () async {
                                    Map<String, dynamic> res =
                                        await UserRepo.cancelSession({
                                      "sender_id":
                                          BlocProvider.of<UserBloc>(context)
                                              .user
                                              .id,
                                      "session_id":
                                          super.widget.session_id.toString()
                                    });
                                    if (res["code"].toString() == "1") {
                                      //show rate dialog
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Dialog(
                                              child: SizedBox(
                                                width: size.width * 0.8,
                                                height: size.height * 0.4,
                                                child: BlocBuilder<LanguageBloc,
                                                    LanguageState>(
                                                  builder: (context, state) {
                                                    if (state is English) {
                                                      return Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Text(
                                                            "Please leave a rating and a feedback!",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: GoogleFonts
                                                                .arvo(
                                                                    fontSize:
                                                                        23),
                                                          ),
                                                          StatefulBuilder(
                                                              builder: (context,
                                                                  setRating) {
                                                            stars = [];
                                                            for (int i = 0;
                                                                i < 4;
                                                                i++) {
                                                              stars.add(
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        setRating(
                                                                            () {
                                                                          for (int j = 0;
                                                                              j < 4;
                                                                              j++) {
                                                                            if (j <=
                                                                                i) {
                                                                              starColor[j] = Colors.yellow;
                                                                              rate = j + 1;
                                                                            } else {
                                                                              starColor[j] = Colors.grey;
                                                                            }
                                                                          }
                                                                        });
                                                                      },
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .star_rate,
                                                                        color:
                                                                            starColor[i],
                                                                      )));
                                                            }
                                                            return Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children:
                                                                    stars);
                                                          }),
                                                          TextField(
                                                            controller: feed,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              Map<String,
                                                                      dynamic>
                                                                  res =
                                                                  await UserRepo
                                                                      .setRate({
                                                                "user_id": BlocProvider.of<
                                                                            UserBloc>(
                                                                        context)
                                                                    .user
                                                                    .id,
                                                                "ratedUserID":
                                                                    super
                                                                        .widget
                                                                        .remoteId,
                                                                "message": feed
                                                                        .text
                                                                        .isEmpty
                                                                    ? ""
                                                                    : feed.text,
                                                                "rate": rate
                                                                    .toString()
                                                              });
                                                              if (res["code"]
                                                                      .toString() ==
                                                                  "1") {
                                                                Navigator.pop(
                                                                    context);
                                                              }
                                                            },
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height:
                                                                  size.height *
                                                                      0.08,
                                                              width:
                                                                  size.width *
                                                                      0.7,
                                                              decoration: BoxDecoration(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              child: BlocBuilder<
                                                                  LanguageBloc,
                                                                  LanguageState>(
                                                                builder:
                                                                    (context,
                                                                        state) {
                                                                  return Text(
                                                                    state is English
                                                                        ? "Rate"
                                                                        : "قيم",
                                                                    style: GoogleFonts.arvo(
                                                                        fontSize:
                                                                            22,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    } else {
                                                      return Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Text(
                                                            "اترك تقييما",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: GoogleFonts
                                                                .arvo(
                                                                    fontSize:
                                                                        23),
                                                          ),
                                                          StatefulBuilder(
                                                              builder: (context,
                                                                  setRating) {
                                                            stars = [];
                                                            for (int i = 0;
                                                                i < 4;
                                                                i++) {
                                                              stars.add(
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        setRating(
                                                                            () {
                                                                          for (int j = 0;
                                                                              j < 4;
                                                                              j++) {
                                                                            if (j <=
                                                                                i) {
                                                                              starColor[j] = Colors.yellow;
                                                                              rate = j + 1;
                                                                            } else {
                                                                              starColor[j] = Colors.grey;
                                                                            }
                                                                          }
                                                                        });
                                                                      },
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .star_rate,
                                                                        color:
                                                                            starColor[i],
                                                                      )));
                                                            }
                                                            return Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children:
                                                                    stars);
                                                          }),
                                                          TextField(
                                                            controller: feed,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              Map<String,
                                                                      dynamic>
                                                                  res =
                                                                  await UserRepo
                                                                      .setRate({
                                                                "user_id": BlocProvider.of<
                                                                            UserBloc>(
                                                                        context)
                                                                    .user
                                                                    .id,
                                                                "ratedUserID":
                                                                    super
                                                                        .widget
                                                                        .remoteId,
                                                                "message": feed
                                                                        .text
                                                                        .isEmpty
                                                                    ? ""
                                                                    : feed.text,
                                                                "rate": rate
                                                                    .toString()
                                                              });
                                                              if (res["code"]
                                                                      .toString() ==
                                                                  "1") {
                                                                Navigator.pop(
                                                                    context);
                                                              }
                                                            },
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height:
                                                                  size.height *
                                                                      0.08,
                                                              width:
                                                                  size.width *
                                                                      0.7,
                                                              decoration: BoxDecoration(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              child: BlocBuilder<
                                                                  LanguageBloc,
                                                                  LanguageState>(
                                                                builder:
                                                                    (context,
                                                                        state) {
                                                                  return Text(
                                                                    state is English
                                                                        ? "Rate"
                                                                        : "قيم",
                                                                    style: GoogleFonts.arvo(
                                                                        fontSize:
                                                                            22,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }
                                                  },
                                                ),
                                              ),
                                            );
                                          }).then((value) {
                                        Navigator.pop(context);
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.logout))
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 9,
                          child: AnimatedList(
                              key: list,
                              controller: scrollController,
                              initialItemCount: savedChats.length,
                              reverse: true,
                              itemBuilder: (context, index, animation) {
                                int reveresedIndex =
                                    savedChats.length - index - 1;
                                if (BlocProvider.of<UserBloc>(context)
                                        .user
                                        .id ==
                                    savedChats[reveresedIndex]["sender_id"]
                                        .toString()) {
                                  return curUser(
                                      size, context, animation, reveresedIndex);
                                } else {
                                  return remoteUser(
                                      size, animation, reveresedIndex);
                                }
                              }),
                        ),
                        Flexible(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    width: size.width * 0.7,
                                    child: TextField(
                                      controller: message,
                                    )),
                                IconButton(
                                    onPressed: () async {
                                      if (message.text.isNotEmpty) {
                                        Map<String, dynamic> res =
                                            await UserRepo.sendMessage({
                                          "sender_id":
                                              BlocProvider.of<UserBloc>(context)
                                                  .user
                                                  .id,
                                          "session_id": super.widget.session_id,
                                          "message": message.text
                                        });
                                        if (res["code"] == 1) {
                                          savedChats.add({
                                            "message": message.text,
                                            "sender_id":
                                                BlocProvider.of<UserBloc>(
                                                        context)
                                                    .user
                                                    .id,
                                            "time":
                                                "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}",
                                            "msg_id": savedChats.isNotEmpty
                                                ? savedChats.last["msg_id"]
                                                : 0
                                          });
                                          list.currentState!.insertItem(
                                              savedChats.length - 1);
                                          message.clear();
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                  child: SizedBox(
                                                    width: size.width * 0.8,
                                                    height: size.height * 0.4,
                                                    child: BlocBuilder<
                                                        LanguageBloc,
                                                        LanguageState>(
                                                      builder:
                                                          (context, state) {
                                                        if (state is English) {
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Text(
                                                                "Please leave a rating and a feedback!",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: GoogleFonts
                                                                    .arvo(
                                                                        fontSize:
                                                                            23),
                                                              ),
                                                              StatefulBuilder(
                                                                  builder: (context,
                                                                      setRating) {
                                                                stars = [];
                                                                for (int i = 0;
                                                                    i < 4;
                                                                    i++) {
                                                                  stars.add(
                                                                      IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            setRating(() {
                                                                              for (int j = 0; j < 4; j++) {
                                                                                if (j <= i) {
                                                                                  starColor[j] = Colors.yellow;
                                                                                  rate = j + 1;
                                                                                } else {
                                                                                  starColor[j] = Colors.grey;
                                                                                }
                                                                              }
                                                                            });
                                                                          },
                                                                          icon:
                                                                              Icon(
                                                                            Icons.star_rate,
                                                                            color:
                                                                                starColor[i],
                                                                          )));
                                                                }
                                                                return Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children:
                                                                        stars);
                                                              }),
                                                              TextField(
                                                                controller:
                                                                    feed,
                                                              ),
                                                              GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  Map<String,
                                                                          dynamic>
                                                                      res =
                                                                      await UserRepo
                                                                          .setRate({
                                                                    "user_id":
                                                                        BlocProvider.of<UserBloc>(context)
                                                                            .user
                                                                            .id,
                                                                    "ratedUserID": super
                                                                        .widget
                                                                        .remoteId,
                                                                    "message": feed
                                                                            .text
                                                                            .isEmpty
                                                                        ? ""
                                                                        : feed
                                                                            .text,
                                                                    "rate": rate
                                                                        .toString()
                                                                  });
                                                                  if (res["code"]
                                                                          .toString() ==
                                                                      "1") {
                                                                    Navigator.pop(
                                                                        context);
                                                                  }
                                                                },
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  height:
                                                                      size.height *
                                                                          0.08,
                                                                  width:
                                                                      size.width *
                                                                          0.7,
                                                                  decoration: BoxDecoration(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                                  child: BlocBuilder<
                                                                      LanguageBloc,
                                                                      LanguageState>(
                                                                    builder:
                                                                        (context,
                                                                            state) {
                                                                      return Text(
                                                                        state is English
                                                                            ? "Rate"
                                                                            : "قيم",
                                                                        style: GoogleFonts.arvo(
                                                                            fontSize:
                                                                                22,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        } else {
                                                          return Column(
                                                            children: [
                                                              const Text(
                                                                  "الرجاء ترك تقييم للمستخدم"),
                                                              StatefulBuilder(
                                                                  builder: (context,
                                                                      setRating) {
                                                                return Row(
                                                                    children:
                                                                        stars);
                                                              })
                                                            ],
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                );
                                              }).then((value) {
                                            Navigator.pop(context);
                                          });
                                        }
                                      }
                                    },
                                    icon: const Icon(Icons.send)),
                                IconButton(
                                    onPressed: () async {
                                      path = null;

                                      path = await ImageModel.getImage();
                                      if (path is String) {
                                        Map<String, dynamic> res =
                                            await UserRepo.sendMessage({
                                          "sender_id":
                                              BlocProvider.of<UserBloc>(context)
                                                  .user
                                                  .id,
                                          "session_id": super.widget.session_id,
                                          "img": path
                                        });
                                        if (res["code"].toString() == "1") {
                                          savedChats.add({
                                            "localImage": path,
                                            "sender_id":
                                                BlocProvider.of<UserBloc>(
                                                        context)
                                                    .user
                                                    .id,
                                            "time":
                                                "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}",
                                            "msg_id": savedChats.isNotEmpty
                                                ? savedChats.last["msg_id"]
                                                : 0
                                          });

                                          list.currentState!.insertItem(
                                              savedChats.length - 1);
                                        }
                                      }
                                    },
                                    icon: const Icon(Icons.image))
                              ],
                            ))
                      ],
                    );
                  }
                }
              }
              return Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back)),
                    ],
                  )
                ],
              );
            }),
      ),
    );
  }

  Container remoteUser(Size size, Animation<double> animation, int index) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 18, right: 18, bottom: 18),
      width: size.width * 0.6,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10), topRight: Radius.circular(10)),
          color: Colors.grey),
      child: SlideTransition(
        position:
            Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0))
                .animate(animation),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Map.from(savedChats[index]).containsKey("message")
                ? Text(
                    savedChats[index]["message"],
                    maxLines: null,
                    style: const TextStyle(fontSize: 24),
                  )
                : SizedBox(
                    width: size.width * 0.6,
                    height: size.height * 0.2,
                    child: Image.network(url + savedChats[index]["imgurl"]),
                  ),
            Text(
              savedChats[index]["time"],
            )
          ],
        ),
      ),
    );
  }

  Container curUser(
      Size size, BuildContext context, Animation<double> animation, int index) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 18, left: 18, bottom: 18),
      width: size.width * 0.6,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
          color: Theme.of(context).primaryColor),
      child: SlideTransition(
        position:
            Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0))
                .animate(animation),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Map.from(savedChats[index]).containsKey("message")
                ? Text(
                    savedChats[index]["message"],
                    maxLines: null,
                    style: const TextStyle(fontSize: 24),
                  )
                : SizedBox(
                    width: size.width * 0.6,
                    height: size.height * 0.2,
                    child: path is String
                        ? Image.file(
                            File.fromUri(
                              Uri.parse(path!),
                            ),
                          )
                        : Image.network(url + savedChats[index]["imgurl"]),
                  ),
            Text(
              savedChats[index]["time"],
            )
          ],
        ),
      ),
    );
  }
}
