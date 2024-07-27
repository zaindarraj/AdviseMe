import 'package:advise_me/logic/BloCs/languageBloc/language_bloc.dart';
import 'package:advise_me/logic/Repos/userRepo.dart';
import 'package:advise_me/logic/classes/consts.dart';
import 'package:advise_me/logic/classes/porfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import '../User Screens/browse_profile.dart';

class ConsByCat extends StatefulWidget {
  String cat;
  ConsByCat({super.key, required this.cat});

  @override
  State<ConsByCat> createState() => _ConsByCatState();
}

class _ConsByCatState extends State<ConsByCat> {
  Future<List<Map<String, dynamic>>>? consultants;
  @override
  void initState() {
    consultants = UserRepo.getByCat(super.widget.cat);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.cat,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Flexible(
              flex: 2,
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: consultants,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isNotEmpty) {
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
                                                profileModel:
                                                    ProfileModel.fromJson(
                                                        snapshot.data![index]),
                                              )));
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Align(
                                            child: SizedBox(
                                              width: 70,
                                              height: 70,
                                              child: ClipOval(
                                                  child: (snapshot.data![index]
                                                          ["imageURL"] is String
                                                      ? Image.network(
                                                          mainUrl +
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
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                      }
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
    );
  }
}

class ConsByAdmin extends StatefulWidget {
  String cat;
  ConsByAdmin({super.key, required this.cat});

  @override
  _ConsByAdminState createState() => _ConsByAdminState();
}

class _ConsByAdminState extends State<ConsByAdmin> {
  Future<List<Map<String, dynamic>>>? consultants;
  @override
  void initState() {
    consultants = UserRepo.getByCat(super.widget.cat);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios)),
              ],
            ),
          ),
          Flexible(
              flex: 2,
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: consultants,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isNotEmpty) {
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {},
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
                                                      mainUrl +
                                                          snapshot.data![index]
                                                                  ["imageURL"]
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
                                                  snapshot.data![index]["rate"]
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 23),
                                                )
                                              ],
                                            ),
                                            Text(
                                              snapshot.data![index]["spec"],
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
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const LinearProgressIndicator();
                  }
                  return BlocBuilder<LanguageBloc, LanguageState>(
                      builder: (context, lanstate) {
                    if (lanstate is English) {
                      return Center(
                        child: Text(
                          "No available Consultants yet !",
                          style: GoogleFonts.arvo(fontSize: 23),
                        ),
                      );
                    } else {
                      return Center(
                        child: Text(
                          "لا يوجد مرشدين حاليا",
                          style: GoogleFonts.arvo(fontSize: 23),
                        ),
                      );
                    }
                  });
                },
              ))
        ],
      ),
    );
  }
}
