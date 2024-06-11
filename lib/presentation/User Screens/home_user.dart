import 'package:advise_me/logic/BloCs/Profile%20BloC/profile_bloc.dart';
import 'package:advise_me/logic/BloCs/User%20BloC/user_bloc.dart';
import 'package:advise_me/logic/BloCs/languageBloc/language_bloc.dart';
import 'package:advise_me/logic/Repos/cateRepo.dart';
import 'package:advise_me/logic/Repos/userRepo.dart';
import 'package:advise_me/logic/classes/category.dart';
import 'package:advise_me/presentation/Con%20Screens/schedule.dart';
import 'package:advise_me/presentation/User%20Screens/profile_user.dart';
import 'package:advise_me/presentation/User%20Screens/schedule_user.dart';
import 'package:advise_me/presentation/main_screen.dart';
import 'package:advise_me/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          backgroundColor: const Color.fromARGB(255, 226, 212, 240),
          items: const [
            BottomNavigationBarItem(
              label: "Session",
              icon: Icon(
                Icons.chat,
              ),
            ),
            BottomNavigationBarItem(
              label: "Home",
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: "Profile",
              icon: Icon(Icons.person),
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
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            width: size.width * 0.8,
            height: size.height * 0.1,
            alignment: Alignment.centerLeft,
            child: BlocBuilder<LanguageBloc, LanguageState>(
              builder: (context, lanstate) {
                return BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    if (lanstate is English) {
                      if (state is UserProfile) {
                        return Text(
                          "Hi ${state.fname} !",
                          style: GoogleFonts.arvo(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        );
                      } else {
                        return Text(
                          "Welcome Home...",
                          style: GoogleFonts.arvo(fontSize: 32),
                        );
                      }
                    } else {
                      if (state is UserProfile) {
                        return Text(
                          "اهلا بك ${state.fname}",
                          maxLines: 2,
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.end,
                          style: GoogleFonts.arvo(fontSize: 32),
                        );
                      } else {
                        return Text(
                          "أهلا بك",
                          textAlign: TextAlign.end,
                          style: GoogleFonts.arvo(fontSize: 32),
                        );
                      }
                    }
                  },
                );
              },
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
                  child: BlocBuilder<LanguageBloc, LanguageState>(
                    builder: (context, state) {
                      if (state is English) {
                        return Text(
                          "Categories : ",
                          maxLines: 2,
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.end,
                          style: GoogleFonts.arvo(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        );
                      } else {
                        return Text("الاختصاصات",
                            overflow: TextOverflow.fade,
                            textAlign: TextAlign.end,
                            style: GoogleFonts.arvo(
                                fontSize: 24, fontWeight: FontWeight.bold));
                      }
                    },
                  ),
                ),
                Flexible(
                    flex: 2,
                    child: FutureBuilder<List<Category>>(
                      future: categories,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
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
                                                height: size.height * 0.1,
                                                child: Image.network(url +
                                                    snapshot
                                                        .data![index].image)),
                                            Text(
                                              snapshot.data![index].name,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.arvo(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
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
                            "No available categories yet !",
                            style: GoogleFonts.arvo(fontSize: 23),
                          ),
                        );
                      },
                    ))
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            height: size.height * 0.5,
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
                    flex: 2,
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: consultants,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (newContext) =>
                                                  BrowseConProfile(
                                                      id: snapshot.data![index]
                                                              ["id"]
                                                          .toString())));
                                    },
                                    child: Container(
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: size.width * 0.3,
                                              height: size.height * 0.14,
                                              child: ClipOval(
                                                  child: (snapshot.data![index]
                                                          ["imageURL"] is String
                                                      ? Image.network(
                                                          url +
                                                              snapshot
                                                                  .data![index][
                                                                      "imageURL"]
                                                                  .toString(),
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.asset(
                                                          "assets/default.jpg",
                                                          fit: BoxFit.cover,
                                                        ))),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  snapshot.data![index]
                                                          ["fname"] +
                                                      " " +
                                                      snapshot.data![index]
                                                          ["lname"],
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.arvo(
                                                      fontSize: 23,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.yellow,
                                                      semanticLabel: snapshot
                                                          .data![index]["rate"]
                                                          .toString(),
                                                      size: 30,
                                                    ),
                                                    Text(
                                                      snapshot.data![index]
                                                              ["rate"]
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 23),
                                                    )
                                                  ],
                                                ),
                                                Text(
                                                  snapshot.data![index]["spec"],
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.arvo(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
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
                            "No available Consultants yet !",
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
    );
  }
}
