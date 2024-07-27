import 'dart:io';

import 'package:advise_me/logic/BloCs/Notification%20BloC/cubit/notification_cubit.dart';
import 'package:advise_me/logic/BloCs/User%20BloC/user_bloc.dart';
import 'package:advise_me/logic/BloCs/languageBloc/language_bloc.dart';
import 'package:advise_me/logic/Repos/adminRepo.dart';
import 'package:advise_me/logic/Repos/cateRepo.dart';
import 'package:advise_me/logic/Repos/userRepo.dart';
import 'package:advise_me/logic/classes/category.dart';
import 'package:advise_me/logic/classes/consts.dart';
import 'package:advise_me/logic/classes/image.dart';
import 'package:advise_me/presentation/Admin%20Screens/pending_con.dart';
import 'package:advise_me/presentation/main_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Con Screens/consByCat.dart';
import 'browseProfileByAdmin.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  GlobalKey<AnimatedListState> catKey = GlobalKey();
  GlobalKey<AnimatedListState> conKey = GlobalKey();
  TextEditingController name = TextEditingController();
  TextEditingController desc = TextEditingController();
  Future<List<Category>>? categories;
  String? carImage;
  List<Category>? savedCategories = [];
  Future<List<Map<String, dynamic>>>? consultants;
  List<Map<String, dynamic>>? savedConsultants = [];
  int numOfAddedCats = 0;
  @override
  void initState() {
    categories = CateRepo.getCats();
    consultants = UserRepo.getAllConsultants();
    BlocProvider.of<NotificationCubit>(context).getNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () async {
            BlocProvider.of<UserBloc>(context).add(SignOut());
          },
          child: Icon(
            Icons.logout_sharp,
            color: Theme.of(context).primaryColor,
          )),
      resizeToAvoidBottomInset: true,
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserInitial) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MainScreen()),
                (Route<dynamic> route) => false);
          }
        },
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 20, left: 5),
                width: size.width * 0.9,
                height: size.height * 0.1,
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BlocBuilder<LanguageBloc, LanguageState>(
                      builder: (context, lanstate) {
                        if (lanstate is English) {
                          return Text(
                            "Hi Admin !",
                            style: GoogleFonts.arvo(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          );
                        } else {
                          return Text(
                            "أهلا بالمدير",
                            style: GoogleFonts.arvo(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          );
                        }
                      },
                    ),
                    Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                      builder: (context) => PendingConScreen(
                                            listKey: catKey,
                                            index: 1,
                                            savedCategories: savedCategories,
                                          )))
                                  .then((value) {
                                BlocProvider.of<NotificationCubit>(context)
                                    .getNotification();
                                setState(() {
                                  consultants = UserRepo.getAllConsultants();
                                });
                              });
                            },
                            icon: const Icon(Icons.notification_add_rounded)),
                        BlocBuilder<NotificationCubit, NotificationState>(
                            builder: (context, state) {
                          return Text(
                            BlocProvider.of<NotificationCubit>(context).num,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 18),
                          );
                        })
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                height: size.height * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Row(
                        children: [
                          BlocBuilder<LanguageBloc, LanguageState>(
                            builder: (context, state) {
                              if (state is English) {
                                return Text(
                                  "Categories : ",
                                  maxLines: 2,
                                  overflow: TextOverflow.fade,
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.arvo(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                );
                              } else {
                                return Text("الاختصاصات",
                                    overflow: TextOverflow.fade,
                                    textAlign: TextAlign.end,
                                    style: GoogleFonts.arvo(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold));
                              }
                            },
                          ),
                          IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          width: size.width * 0.8,
                                          height: size.height * 0.5,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              StatefulBuilder(
                                                  builder: (context, setImage) {
                                                return GestureDetector(
                                                  onTap: () async {
                                                    carImage = await ImageModel
                                                        .getImage();
                                                    setImage(() {});
                                                  },
                                                  child: SizedBox(
                                                    width: size.width * 0.7,
                                                    height: size.height * 0.14,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        SizedBox(
                                                          width:
                                                              size.width * 0.3,
                                                          height: size.height *
                                                              0.14,
                                                          child: ClipOval(
                                                              child: (carImage
                                                                      is String
                                                                  ? Image.file(
                                                                      File.fromUri(
                                                                          Uri.parse(
                                                                              carImage!)),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    )
                                                                  : Image.asset(
                                                                      "assets/default.jpg",
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ))),
                                                        ),
                                                        BlocBuilder<
                                                            LanguageBloc,
                                                            LanguageState>(
                                                          builder:
                                                              (context, lang) {
                                                            return Text(lang
                                                                    is English
                                                                ? "Click to pick an image"
                                                                : "اختر صورة");
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                              TextField(
                                                controller: name,
                                                decoration: InputDecoration(
                                                    label: BlocBuilder<
                                                        LanguageBloc,
                                                        LanguageState>(
                                                  builder: (context, lang) {
                                                    return Text(lang is English
                                                        ? "Name"
                                                        : "الاسم");
                                                  },
                                                )),
                                              ),
                                              TextField(
                                                controller: desc,
                                                minLines: 2,
                                                maxLines: 3,
                                                decoration: InputDecoration(
                                                    label: BlocBuilder<
                                                        LanguageBloc,
                                                        LanguageState>(
                                                  builder: (context, lang) {
                                                    return Text(lang is English
                                                        ? "Description"
                                                        : "الوصف");
                                                  },
                                                )),
                                              ),
                                              IconButton(
                                                  onPressed: () async {
                                                    if (name.text.isNotEmpty &&
                                                        desc.text.isNotEmpty &&
                                                        carImage is String) {
                                                      Map<String, dynamic> res =
                                                          await AdminRepo
                                                              .addCategory(
                                                                  name.text,
                                                                  carImage!,
                                                                  desc.text);
                                                      if (res["code"]
                                                              .toString() ==
                                                          "1") {
                                                        savedCategories!.add(
                                                            Category.fromJson({
                                                          "categoryImage":
                                                              carImage,
                                                          "categoryBio":
                                                              desc.text,
                                                          "name": name.text
                                                        }));
                                                        numOfAddedCats++;
                                                        catKey.currentState!
                                                            .insertItem(1);
                                                      }
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(SnackBar(
                                                              content: Text(res[
                                                                  "message"])));
                                                      Navigator.pop(context);
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              const SnackBar(
                                                                  content: Text(
                                                                      "Please fill all fields")));
                                                    }
                                                  },
                                                  icon: const Icon(
                                                      Icons.add_box_rounded))
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                              icon: const Icon(Icons.add))
                        ],
                      ),
                    ),
                    Flexible(
                        flex: 3,
                        child: FutureBuilder<List<Category>>(
                          future: categories,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasData) {
                                savedCategories = snapshot.data;
                                return AnimatedList(
                                    key: catKey,
                                    scrollDirection: Axis.horizontal,
                                    initialItemCount: savedCategories!.length,
                                    itemBuilder: (context, index, animation) {
                                      return slideCat(
                                          animation,
                                          index,
                                          context,
                                          savedCategories!,
                                          catKey,
                                          size,
                                          numOfAddedCats);
                                    });
                              }
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const LinearProgressIndicator();
                            }
                            return Center(
                              child: Text(
                                "No available categories yet !",
                                style: GoogleFonts.arvo(fontSize: 23),
                              ),
                            );
                          },
                        ))
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: BlocBuilder<LanguageBloc, LanguageState>(
                        builder: (context, state) {
                          if (state is English) {
                            return Text(
                              "Consultants : ",
                              maxLines: 2,
                              overflow: TextOverflow.fade,
                              textAlign: TextAlign.end,
                              style: GoogleFonts.arvo(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            );
                          } else {
                            return Text("المرشدين",
                                overflow: TextOverflow.fade,
                                textAlign: TextAlign.end,
                                style: GoogleFonts.arvo(
                                    fontSize: 24, fontWeight: FontWeight.bold));
                          }
                        },
                      ),
                    ),
                    Flexible(
                        flex: 5,
                        child: FutureBuilder<List<Map<String, dynamic>>>(
                          future: consultants,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasData) {
                                savedConsultants = snapshot.data;

                                return AnimatedList(
                                    key: conKey,
                                    scrollDirection: Axis.vertical,
                                    initialItemCount: savedConsultants!.length,
                                    itemBuilder: (context, index, animation) {
                                      return slideCon(animation, index, context,
                                          savedConsultants!, conKey, size);
                                    });
                              }
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const LinearProgressIndicator();
                            }
                            return Center(
                              child: Text(
                                "No available consultants yet !",
                                style: GoogleFonts.arvo(fontSize: 23),
                              ),
                            );
                          },
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

SlideTransition slideCat(
    Animation<double> animation,
    int index,
    BuildContext context,
    List<Category> savedCategories,
    GlobalKey<AnimatedListState> globalKey,
    Size size,
    int num) {
  return SlideTransition(
    position: Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0))
        .animate(animation),
    child: GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ConsByAdmin(
                  cat: savedCategories[index].name,
                )));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
              child: index < savedCategories.length - num
                  ? SizedBox(
                      height: 70,
                      width: 70,
                      child: ClipOval(
                        child: CachedNetworkImage(
                            imageUrl: mainUrl + savedCategories[index].image,
                            errorWidget: (context, error, ob) {
                              return Image.asset("assets/error.jpn");
                            },
                            progressIndicatorBuilder:
                                (context, string, progress) {
                              return const CircularProgressIndicator();
                            }),
                      ))
                  : Image.file(
                      File.fromUri(Uri.parse(savedCategories[index].image)))),
          Text(
            savedCategories[index].name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.arvo(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}

SlideTransition slideCon(
    Animation<double> animation,
    int index,
    BuildContext context,
    List<Map<String, dynamic>> savedCons,
    GlobalKey<AnimatedListState> globalKey,
    Size size) {
  return SlideTransition(
    position: Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0))
        .animate(animation),
    child: GestureDetector(
      onTap: () async {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DeleteConProfileByAdmin(
                savedCons: savedCons,
                index: index,
                listContext: context,
                listKey: globalKey,
                id: savedCons[index]["id"].toString())));
      },
      child: Container(
          margin: const EdgeInsets.all(7),
          padding: const EdgeInsets.all(10),
          width: size.width * 0.85,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                  color: Colors.grey, blurRadius: 10, offset: Offset(2, 2))
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: size.width * 0.3,
                height: size.height * 0.14,
                child: ClipOval(
                    child: (savedCons[index]["imageURL"] is String
                        ? Image.network(
                            mainUrl + savedCons[index]["imageURL"].toString(),
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            "assets/default.jpg",
                            fit: BoxFit.cover,
                          ))),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    savedCons[index]["fname"] + " " + savedCons[index]["lname"],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.arvo(
                        fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                        semanticLabel: savedCons[index]["rate"].toString(),
                        size: 30,
                      ),
                      Text(
                        savedCons[index]["rate"].toString(),
                        style: const TextStyle(fontSize: 23),
                      )
                    ],
                  ),
                  Text(
                    savedCons[index]["spec"] ?? "no spec",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.arvo(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          )),
    ),
  );
}
