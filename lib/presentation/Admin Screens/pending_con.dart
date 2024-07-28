import 'package:advise_me/logic/Repos/adminRepo.dart';
import 'package:advise_me/logic/classes/porfile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../logic/classes/category.dart';
import 'browseProfileByAdmin.dart';

class PendingConScreen extends StatefulWidget {
  GlobalKey<AnimatedListState> listKey;
  List<Category>? savedCategories;
  int index;
  PendingConScreen(
      {super.key,
      required this.listKey,
      required this.savedCategories,
      required this.index});

  @override
  State<PendingConScreen> createState() => _PendingConScreenState();
}

class _PendingConScreenState extends State<PendingConScreen> {
  final _buildBody = <Widget>[
    const PendingAdminApproval(),
    const ChangesPendingAdmin(),
  ];
  int selectedPage = 0;

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
                label: "Pending Consulants",
                icon: Icon(
                  Icons.login_rounded,
                ),
              ),
              BottomNavigationBarItem(
                label: "Pending Changes",
                icon: Icon(Icons.person_rounded),
              ),
            ]),
        body: IndexedStack(
          index: selectedPage,
          children: _buildBody,
        ));
  }
}

class PendingAdminApproval extends StatefulWidget {
  const PendingAdminApproval({super.key});

  @override
  State<PendingAdminApproval> createState() => _PendingAdminApprovalState();
}

class _PendingAdminApprovalState extends State<PendingAdminApproval> {
  Future<List<Map<String, dynamic>>>? pending;
  @override
  void initState() {
    pending = AdminRepo.getPendingConsultants();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back)),
          ),
          SizedBox(
            height: size.height * 0.8,
            child: FutureBuilder<List<Map<String, dynamic>>>(
                future: pending,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) =>
                                            BrowseConProfileByAdmin(
                                                id: snapshot.data![index]["id"]
                                                    .toString())))
                                    .then((value) {
                                  setState(() {
                                    pending = AdminRepo.getPendingConsultants();
                                  });
                                });
                              },
                              child: Container(
                                  margin: const EdgeInsets.all(7),
                                  padding: const EdgeInsets.all(10),
                                  width: size.width * 0.85,
                                  height: size.height * 0.15,
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: SizedBox(
                                          height: size.height * 0.2,
                                          width: size.width * 0.3,
                                          child: ClipOval(
                                            child: (Image.asset(
                                              "assets/default.jpg",
                                              fit: BoxFit.fill,
                                            )),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              snapshot.data![index]["fname"] +
                                                  " " +
                                                  snapshot.data![index]
                                                      ["lname"],
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.arvo(
                                                  fontSize: 23,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              snapshot.data![index]["spec"] ??
                                                  "no spec",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.arvo(
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              snapshot.data![index]["email"] ??
                                                  "No Email",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.arvo(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                            );
                          });
                    } else {
                      return Center(
                        child: SizedBox(
                            width: size.width * 0.9,
                            height: 5,
                            child: const LinearProgressIndicator()),
                      );
                    }
                  } else {
                    return Center(
                      child: SizedBox(
                          width: size.width * 0.9,
                          height: 5,
                          child: const LinearProgressIndicator()),
                    );
                  }
                  return const Center(
                    child: Text("No Pendings"),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class ChangesPendingAdmin extends StatefulWidget {
  const ChangesPendingAdmin({super.key});

  @override
  State<ChangesPendingAdmin> createState() => _ChangesPendingAdminState();
}

class _ChangesPendingAdminState extends State<ChangesPendingAdmin> {
  Future<List<Map<String, dynamic>>>? pending;
  @override
  void initState() {
    pending = AdminRepo.getPendingChanges();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back)),
          ),
          SizedBox(
            height: size.height * 0.8,
            child: FutureBuilder<List<Map<String, dynamic>>>(
                future: pending,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      print(snapshot.data);
                      if (snapshot.data!.isEmpty) {
                        return Center(child: Text("No Pending Changes"));
                      }
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                print(snapshot.data![index]["requestID"]
                                    .toString());
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                  builder: (context) => BrowseConProfileByAdmin(
                                    id: snapshot.data![index]["id"].toString(),
                                    requestID: snapshot.data![index]
                                            ["requestID"]
                                        .toString(),
                                    profileModel: ProfileModel.fromJson(
                                        snapshot.data![index]),
                                  ),
                                ))
                                    .then((value) {
                                  setState(() {
                                    pending = AdminRepo.getPendingChanges();
                                  });
                                });
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
                                            child: (Image.asset(
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
                                            snapshot.data![index]["fname"] +
                                                " " +
                                                snapshot.data![index]["lname"],
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.arvo(
                                                fontSize: 23,
                                                fontWeight: FontWeight.bold),
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
                                                snapshot.data![index]["rate"] ==
                                                        null
                                                    ? "0"
                                                    : snapshot.data![index]
                                                            ["rate"]
                                                        .toString(),
                                                style: const TextStyle(
                                                    fontSize: 23),
                                              )
                                            ],
                                          ),
                                          Text(
                                            snapshot.data![index]
                                                        ["specialty"] ==
                                                    null
                                                ? "*No Spec"
                                                : snapshot.data![index]
                                                    ["specialty"],
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
                            );
                          });
                    }
                  }
                  return const Center(
                    child: Text("No Pendings"),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
