import 'package:advise_me/logic/Repos/userRepo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import 'calendar.dart';

class BrowseSchedulesCon extends StatefulWidget {
  final String conID;
  const BrowseSchedulesCon({super.key, required this.conID});

  @override
  State<BrowseSchedulesCon> createState() => _BrowseSchedulesConState();
}

class _BrowseSchedulesConState extends State<BrowseSchedulesCon> {
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
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => const SetScheduleScreen()))
                .then((value) {
              setState(() {
                schedules =
                    UserRepo.getSchdules({"consultant_id": super.widget.conID});
              });
            });
          }),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.available_schedules,
            style: GoogleFonts.arvo(fontSize: 23, fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<List>(
          future: schedules,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(5),
                          alignment: Alignment.center,
                          height: size.height * 0.3,
                          margin: const EdgeInsets.all(18),
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
                              ListTile(
                                leading: Text(
                                    AppLocalizations.of(context)!.date,
                                    style: GoogleFonts.arvo(fontSize: 23)),
                                trailing: Text(snapshot.data![index]["date"],
                                    style: GoogleFonts.arvo(fontSize: 23)),
                              ),
                              ListTile(
                                leading: Text(
                                    AppLocalizations.of(context)!.from,
                                    style: GoogleFonts.arvo(fontSize: 23)),
                                trailing: Text(snapshot.data![index]["from"],
                                    style: GoogleFonts.arvo(fontSize: 23)),
                              ),
                              ListTile(
                                leading: Text(AppLocalizations.of(context)!.to,
                                    style: GoogleFonts.arvo(fontSize: 23)),
                                trailing: Text(snapshot.data![index]["to"],
                                    style: GoogleFonts.arvo(fontSize: 23)),
                              ),
                            ],
                          ),
                        );
                      });
                }
              }
            }

            return Center(
                child: Text(AppLocalizations.of(context)!.no_schedule));
          }),
    );
  }
}
