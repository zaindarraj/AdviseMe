import 'package:advise_me/logic/BloCs/User%20BloC/user_bloc.dart';
import 'package:advise_me/logic/BloCs/languageBloc/language_bloc.dart';
import 'package:advise_me/logic/Repos/userRepo.dart';
import 'package:advise_me/presentation/User%20Screens/payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class BrowseSchedules extends StatefulWidget {
  final String conID;
  const BrowseSchedules({super.key, required this.conID});

  @override
  State<BrowseSchedules> createState() => _BrowseSchedulesState();
}

class _BrowseSchedulesState extends State<BrowseSchedules> {
  Future<List>? schedules;
  @override
  void initState() {
    schedules = UserRepo.getSchdules({"consultant_id": super.widget.conID});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back)),
                  BlocBuilder<LanguageBloc, LanguageState>(
                      builder: (context, state) {
                    if (state is English) {
                      return Text("Available Schedules : ",
                          style: GoogleFonts.arvo(
                              fontSize: 23, fontWeight: FontWeight.bold));
                    }
                    return Text("الاوقات المتاحة",
                        style: GoogleFonts.arvo(
                            fontSize: 28, fontWeight: FontWeight.bold));
                  }),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 8,
            child: FutureBuilder<List>(
                future: schedules,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isNotEmpty) {
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {

                              return GestureDetector(
                                onTap: () async {
                                  print(snapshot.data![index]
                                                    ["schedual_id"]);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Payment(
                                                sID: snapshot.data![index]
                                                    ["schedual_id"].toString(),
                                              ))).then((value) {
                                                setState(() {
                                                      schedules = UserRepo.getSchdules({"consultant_id": super.widget.conID});

                                                });
                                              });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  alignment: Alignment.center,
                                  height: size.height * 0.3,
                                  margin: EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 10,
                                          offset: Offset(2, 2))
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      BlocBuilder<LanguageBloc, LanguageState>(
                                        builder: (context, state) {
                                          return ListTile(
                                            leading: Text(
                                                state is English
                                                    ? "Date"
                                                    : "التاريخ",
                                                style: GoogleFonts.arvo(
                                                    fontSize: 23)),
                                            trailing: Text(
                                                snapshot.data![index]["date"],
                                                style: GoogleFonts.arvo(
                                                    fontSize: 23)),
                                          );
                                        },
                                      ),
                                      BlocBuilder<LanguageBloc, LanguageState>(
                                        builder: (context, state) {
                                          return ListTile(
                                            leading: Text(
                                                state is English
                                                    ? "From"
                                                    : "وقت البداية",
                                                style: GoogleFonts.arvo(
                                                    fontSize: 23)),
                                            trailing: Text(
                                                snapshot.data![index]["from"],
                                                style: GoogleFonts.arvo(
                                                    fontSize: 23)),
                                          );
                                        },
                                      ),
                                      BlocBuilder<LanguageBloc, LanguageState>(
                                        builder: (context, state) {
                                          return ListTile(
                                            leading: Text(
                                                state is English
                                                    ? "To"
                                                    : "وقت النهاية",
                                                style: GoogleFonts.arvo(
                                                    fontSize: 23)),
                                            trailing: Text(
                                                snapshot.data![index]["to"],
                                                style: GoogleFonts.arvo(
                                                    fontSize: 23)),
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                      }
                    }
                  }

                  return Center(
                    child: BlocBuilder<LanguageBloc, LanguageState>(
                        builder: (context, state) {
                      if (state is English) {
                        return Text("Sorry this Consultant is busy",
                            style: GoogleFonts.arvo(
                              fontSize: 18,
                            ));
                      }
                      return Text("مع الأسف المرشد ليس لديه وقت",
                          style: GoogleFonts.arvo(fontSize: 18));
                    }),
                  );
                }),
          )
        ],
      ),
    );
  }
}
