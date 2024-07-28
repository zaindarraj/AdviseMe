import 'dart:async';
import 'dart:io';

import 'package:advise_me/logic/Repos/adminRepo.dart';
import 'package:advise_me/logic/classes/consts.dart';
import 'package:advise_me/presentation/pdfVIEWR.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';

import '../../logic/BloCs/languageBloc/language_bloc.dart';
import '../../logic/Repos/profileRepo.dart';
import '../../logic/Repos/userRepo.dart';
import '../../logic/classes/porfile.dart';

class BrowseConProfileByAdmin extends StatefulWidget {
  String id;
  String? requestID;
  ProfileModel? profileModel;
  BrowseConProfileByAdmin(
      {super.key, required this.id, this.profileModel, this.requestID});

  @override
  State<BrowseConProfileByAdmin> createState() => _BrowseConProfileState();
}

class _BrowseConProfileState extends State<BrowseConProfileByAdmin> {
  Future<ProfileModel> getNewProfile() async {
    return await Future.delayed(Duration.zero).then((value) {
      return super.widget.profileModel!;
    });
  }

  Future<dynamic>? profile;
  Future<File> createFileOfPdfUrl(String url) async {
    Completer<File> completer = Completer();
    try {
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  @override
  void initState() {
    if (super.widget.profileModel is! ProfileModel) {
      profile = ProfileRepo.getProfile(super.widget.id);
    } else {
      profile = getNewProfile();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: FutureBuilder<dynamic>(
      future: profile,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            if (snapshot.data is ProfileModel) {
              ProfileModel profileModel = snapshot.data;
              return SafeArea(
                child: Container(
                  padding: EdgeInsets.all(8),
                  height: size.height * 0.7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon:
                                  const Icon(Icons.arrow_back_ios_new_rounded))
                        ],
                      ),
                      SizedBox(
                          height: size.height * 0.2,
                          width: size.width * 0.4,
                          child: ClipOval(
                              child: (profileModel.userImage != null
                                  ? Image.network(
                                      mainUrl + profileModel.userImage!,
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
                            "${profileModel.fname} ${profileModel.lname}",
                            overflow: TextOverflow.fade,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 24),
                          ),
                          Text(
                            profileModel.spec is String
                                ? "* ${profileModel.spec!}"
                                : "* Not Specified",
                            overflow: TextOverflow.fade,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 18),
                          )
                        ],
                      ),
                      Text(
                        profileModel.bio is String
                            ? "* ${profileModel.bio!}"
                            : "* Not Specified",
                        overflow: TextOverflow.fade,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                      const VerticalDivider(
                        thickness: 20,
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              BlocBuilder<LanguageBloc, LanguageState>(
                                  builder: (context, state) {
                                return Text(state is English
                                    ? "Certificate : "
                                    : "الشهادة");
                              }),
                              IconButton(
                                  onPressed: () async {
                                    String remotePDFpath =
                                        (await createFileOfPdfUrl(
                                                mainUrl + profileModel.cer!))
                                            .path;

                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PDFViewerScreen(
                                                    pdf: remotePDFpath)));
                                  },
                                  icon: const Icon(Icons.attach_file))
                            ],
                          ),
                          Row(
                            children: [
                              BlocBuilder<LanguageBloc, LanguageState>(
                                  builder: (context, state) {
                                return Text(state is English
                                    ? "CV : "
                                    : "السيرة الذاتية");
                              }),
                              IconButton(
                                  onPressed: () async {
                                    String remotePDFpath =
                                        (await createFileOfPdfUrl(
                                                mainUrl + profileModel.cv!))
                                            .path;

                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PDFViewerScreen(
                                                    pdf: remotePDFpath)));
                                  },
                                  icon: const Icon(Icons.attach_file))
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.price_dotted,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              profileModel.price.toString(),
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                              onPressed: () async {
                                if (super.widget.profileModel
                                    is! ProfileModel) {
                                  Map<String, dynamic> res =
                                      await AdminRepo.approveCon({
                                    "con_id": widget.requestID ?? widget.id,
                                    "approve": "1"
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(res["message"])));
                                  Navigator.pop(context);
                                }
                                {
                                  Map<String, dynamic> res =
                                      await AdminRepo.approveChanges({
                                    "con_id": widget.requestID ?? widget.id,
                                    "approve": "1"
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(res["message"])));
                                }
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  alignment: Alignment.center,
                                  width: size.width * 0.3,
                                  height: size.height * 0.05,
                                  child:
                                      BlocBuilder<LanguageBloc, LanguageState>(
                                    builder: (context, lang) {
                                      return Text(
                                        lang is English ? "Accept" : "قبول",
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      );
                                    },
                                  ))),
                          TextButton(
                              onPressed: () async {
                                if (super.widget.profileModel
                                    is! ProfileModel) {
                                  Map<String, dynamic> res =
                                      await AdminRepo.approveCon({
                                    "userid": super.widget.id,
                                    "approve": "0"
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(res["message"])));
                                  Navigator.pop(context);
                                }
                                {
                                  Map<String, dynamic> res =
                                      await AdminRepo.approveChanges({
                                    "userid": super.widget.id,
                                    "approve": "0"
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(res["message"])));
                                }
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  alignment: Alignment.center,
                                  width: size.width * 0.3,
                                  height: size.height * 0.05,
                                  child:
                                      BlocBuilder<LanguageBloc, LanguageState>(
                                    builder: (context, lang) {
                                      return Text(
                                        lang is English ? "Reject" : "رفض",
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      );
                                    },
                                  ))),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }
          }
        }
        return Center(
          child: SizedBox(
              width: size.width * 0.9,
              height: 5,
              child: const LinearProgressIndicator()),
        );
      },
    ));
  }
}

class DeleteConProfileByAdmin extends StatefulWidget {
  String id;
  BuildContext listContext;
  int index;
  List<Map<String, dynamic>> savedCons;

  GlobalKey<AnimatedListState> listKey;
  DeleteConProfileByAdmin({
    super.key,
    required this.savedCons,
    required this.index,
    required this.listContext,
    required this.listKey,
    required this.id,
  });

  @override
  State<DeleteConProfileByAdmin> createState() => _DeleteConProfileState();
}

class _DeleteConProfileState extends State<DeleteConProfileByAdmin> {
  Future<dynamic>? profile;
  Future<File> createFileOfPdfUrl(String url) async {
    Completer<File> completer = Completer();
    try {
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  @override
  void initState() {
    profile = profile = ProfileRepo.getProfile(super.widget.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: size.width * 0.9,
        height: size.height * 0.7,
        child: FutureBuilder<dynamic>(
          future: profile,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                if (snapshot.data is ProfileModel) {
                  ProfileModel profileModel = snapshot.data;
                  return SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                    Icons.arrow_back_ios_new_rounded))
                          ],
                        ),
                        SizedBox(
                            height: size.height * 0.2,
                            width: size.width * 0.4,
                            child: ClipOval(
                                child: (profileModel.userImage != "null"
                                    ? Image.network(
                                        mainUrl + profileModel.userImage!,
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
                              "${profileModel.fname} ${profileModel.lname}",
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24),
                            ),
                            Text(
                              profileModel.spec is String
                                  ? "* ${profileModel.spec!}"
                                  : "* Not Specified",
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 18),
                            )
                          ],
                        ),
                        Text(
                          profileModel.bio is String
                              ? "* ${profileModel.bio!}"
                              : "* Not Specified",
                          overflow: TextOverflow.fade,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                        const VerticalDivider(
                          thickness: 20,
                        ),
                        Row(
                          children: [
                            Row(
                              children: [
                                BlocBuilder<LanguageBloc, LanguageState>(
                                    builder: (context, state) {
                                  return Text(state is English
                                      ? "Certificate : "
                                      : "الشهادة");
                                }),
                                IconButton(
                                    onPressed: () async {
                                      String remotePDFpath =
                                          (await createFileOfPdfUrl(
                                                  mainUrl + profileModel.cer!))
                                              .path;

                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PDFViewerScreen(
                                                      pdf: remotePDFpath)));
                                    },
                                    icon: const Icon(Icons.attach_file))
                              ],
                            ),
                            Row(
                              children: [
                                BlocBuilder<LanguageBloc, LanguageState>(
                                    builder: (context, state) {
                                  return Text(state is English
                                      ? "CV : "
                                      : "السيرة الذاتية");
                                }),
                                IconButton(
                                    onPressed: () async {
                                      String remotePDFpath =
                                          (await createFileOfPdfUrl(
                                                  mainUrl + profileModel.cv!))
                                              .path;

                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PDFViewerScreen(
                                                      pdf: remotePDFpath)));
                                    },
                                    icon: const Icon(Icons.attach_file))
                              ],
                            ),
                          ],
                        ),
                        Center(
                          child: TextButton(
                              onPressed: () async {
                                Map<String, dynamic> res =
                                    await UserRepo.deletAccount(
                                        super.widget.id);
                                if (res["code"].toString() == "1") {
                                  super
                                      .widget
                                      .savedCons
                                      .removeAt(super.widget.index);
                                  super.widget.listKey.currentState!.removeItem(
                                      super.widget.index, (context, animation) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                              begin: const Offset(-1, 0),
                                              end: const Offset(0, 0))
                                          .animate(animation),
                                      child: Container(
                                          margin: const EdgeInsets.all(7),
                                          width: size.width * 0.3,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Removing",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.arvo(
                                                fontSize: 23,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    );
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(res["message"])));
                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(res["message"])));
                                }
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  alignment: Alignment.center,
                                  width: size.width * 0.3,
                                  height: size.height * 0.05,
                                  child:
                                      BlocBuilder<LanguageBloc, LanguageState>(
                                    builder: (context, lang) {
                                      return Text(
                                        lang is English ? "Delete" : "حذف",
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      );
                                    },
                                  ))),
                        )
                      ],
                    ),
                  );
                }
              }
            }
            return const Center(
              child: SizedBox(
                  width: 10, height: 10, child: LinearProgressIndicator()),
            );
          },
        ),
      ),
    ));
  }
}
