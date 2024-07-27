import 'package:advise_me/logic/BloCs/Profile%20BloC/profile_bloc.dart';
import 'package:advise_me/logic/BloCs/User%20BloC/user_bloc.dart';
import 'package:advise_me/logic/Repos/cateRepo.dart';
import 'package:advise_me/logic/Repos/userRepo.dart';
import 'package:advise_me/logic/classes/category.dart';
import 'package:advise_me/logic/classes/consts.dart';
import 'package:advise_me/logic/classes/porfile.dart';
import 'package:advise_me/presentation/User%20Screens/profile_user.dart';
import 'package:advise_me/presentation/User%20Screens/sessions.dart';
import 'package:advise_me/presentation/main_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Con Screens/consByCat.dart';
import 'browse_profile.dart';

class HomeUser extends StatefulWidget {
  const HomeUser({super.key});

  @override
  State<HomeUser> createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  final _buildBody = <Widget>[
    const ScheduleUser(),
    const HomePage(),
    const UserProfileScreen(),
  ];
  int selectedPage = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.white,
          onTap: (index) {
            setState(() {
              selectedPage = index;
            });
          },
          currentIndex: selectedPage,
          backgroundColor: Theme.of(context).primaryColor,
          items: [
            BottomNavigationBarItem(
              label: AppLocalizations.of(context)!.session,
              icon: const Icon(
                Icons.chat,
              ),
            ),
            BottomNavigationBarItem(
              label: AppLocalizations.of(context)!.home,
              icon: const Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: AppLocalizations.of(context)!.profile,
              icon: const Icon(Icons.person),
            )
          ]),
      body: BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserInitial) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                  (Route<dynamic> route) => false);
            }
          },
          child: IndexedStack(
            index: selectedPage,
            children: _buildBody,
          )),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Future<List<Category>>? categories;
  Future<List<Map<String, dynamic>>>? consultants;
  @override
  void initState() {
    consultants = UserRepo.getAllConsultants();
    categories = CateRepo.getCats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              height: size.height * 0.1,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(5),
              child: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is UserProfile) {
                    return Text(
                      "${AppLocalizations.of(context)!.hi} ${state.fname} !",
                      style: GoogleFonts.arvo(
                          fontSize: 32, fontWeight: FontWeight.bold),
                    );
                  } else {
                    return Text(
                      AppLocalizations.of(context)!.welcome,
                      style: GoogleFonts.arvo(fontSize: 32),
                    );
                  }
                },
              ),
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 1,
                    child: Text(
                      AppLocalizations.of(context)!.cats,
                      maxLines: 2,
                      overflow: TextOverflow.fade,
                      textAlign: TextAlign.end,
                      style: GoogleFonts.arvo(
                          fontSize: 24, fontWeight: FontWeight.bold),
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
                              return GridView.builder(
                                  scrollDirection: Axis.horizontal,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 1),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (_) => ConsByCat(
                                                      cat: snapshot
                                                          .data![index].name,
                                                    )));
                                      },
                                      child: Container(
                                          margin: const EdgeInsets.all(7),
                                          width: size.width * 0.3,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SizedBox(
                                                  height: 70,
                                                  width: 70,
                                                  child: ClipOval(
                                                    child: CachedNetworkImage(
                                                        imageUrl: mainUrl +
                                                            snapshot
                                                                .data![index]
                                                                .image,
                                                        errorWidget: (context,
                                                            error, ob) {
                                                          return Image.asset(
                                                              "assets/error.jpn");
                                                        },
                                                        progressIndicatorBuilder:
                                                            (context, string,
                                                                progress) {
                                                          return const CircularProgressIndicator();
                                                        }),
                                                  )),
                                              Text(
                                                snapshot.data![index].name,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.arvo(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          )),
                                    );
                                  });
                            }
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const LinearProgressIndicator();
                          }
                          return Center(
                            child: Text(
                              AppLocalizations.of(context)!.no_cats,
                              style: GoogleFonts.arvo(fontSize: 23),
                            ),
                          );
                        },
                      ))
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.cons,
                    maxLines: 2,
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.end,
                    style: GoogleFonts.arvo(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Flexible(
                      flex: 2,
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: consultants,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 8, left: 8, right: 8),
                                child: snapshot.data!.isEmpty
                                    ? Center(
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .no_cons))
                                    : ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              print(snapshot.data![index]);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (newContext) =>
                                                          BrowseConProfile(
                                                            profileModel: ProfileModel
                                                                .fromJson(snapshot
                                                                        .data![
                                                                    index]),
                                                          )));
                                            },
                                            child: Container(
                                                margin: const EdgeInsets.all(7),
                                                padding:
                                                    const EdgeInsets.all(10),
                                                width: size.width * 0.85,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  boxShadow: const [
                                                    BoxShadow(
                                                        color: Colors.grey,
                                                        blurRadius: 10,
                                                        offset: Offset(2, 2))
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                alignment: Alignment.center,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    SizedBox(
                                                      width: 70,
                                                      height: 70,
                                                      child: ClipOval(
                                                          child: (snapshot.data![
                                                                          index]
                                                                      [
                                                                      "imageURL"]
                                                                  is String
                                                              ? Image.network(
                                                                  mainUrl +
                                                                      snapshot
                                                                          .data![
                                                                              index]
                                                                              [
                                                                              "imageURL"]
                                                                          .toString(),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              : Image.asset(
                                                                  "assets/default.jpg",
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ))),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Text(
                                                          snapshot.data![index]
                                                                  ["fname"] +
                                                              " " +
                                                              snapshot.data![
                                                                      index]
                                                                  ["lname"],
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              GoogleFonts.arvo(
                                                                  fontSize: 23,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons.star,
                                                              color:
                                                                  Colors.amber,
                                                              semanticLabel: snapshot
                                                                              .data![index]
                                                                          [
                                                                          "rate"] !=
                                                                      null
                                                                  ? snapshot
                                                                      .data![
                                                                          index]
                                                                          [
                                                                          "rate"]
                                                                      .toString()
                                                                  : "0",
                                                              size: 30,
                                                            ),
                                                            Text(
                                                              snapshot.data![index]
                                                                          [
                                                                          "rate"] !=
                                                                      null
                                                                  ? snapshot
                                                                      .data![
                                                                          index]
                                                                          [
                                                                          "rate"]
                                                                      .toString()
                                                                  : "0",
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          23),
                                                            )
                                                          ],
                                                        ),
                                                        Text(
                                                          snapshot.data![index]
                                                                  ["spec"] ??
                                                              "no spec",
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              GoogleFonts.arvo(
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )),
                                          );
                                        }),
                              );
                            } else {
                              return const LinearProgressIndicator();
                            }
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const LinearProgressIndicator();
                          }
                          return Center(
                            child: Text(
                              AppLocalizations.of(context)!.no_cons,
                              style: GoogleFonts.arvo(fontSize: 23),
                            ),
                          );
                        },
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
