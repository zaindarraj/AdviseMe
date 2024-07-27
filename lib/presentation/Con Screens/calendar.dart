import 'package:advise_me/logic/BloCs/User%20BloC/user_bloc.dart';
import 'package:advise_me/logic/Repos/userRepo.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:google_fonts/google_fonts.dart';

class SetScheduleScreen extends StatefulWidget {
  const SetScheduleScreen({super.key});

  @override
  State<SetScheduleScreen> createState() => _SetScheduleScreenState();
}

class _SetScheduleScreenState extends State<SetScheduleScreen> {
  Time _starttime = Time.fromTimeOfDay(TimeOfDay.now(), 0);
  Time _endtime = Time.fromTimeOfDay(TimeOfDay.now(), 0);
  DateTime date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Center(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close)),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  AppLocalizations.of(context)!.set_schedule,
                  style: GoogleFonts.arvo(
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                      color: Colors.grey),
                ),
                SizedBox(
                    height: size.height * 0.2,
                    child: Calendar(
                      initialDate: date,
                      onDateSelected: (value) {
                        setState(() {
                          print(value);
                          date = value;
                        });
                      },
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          showPicker(
                            context: context,
                            value: _starttime,
                            onChange: (newTime) {
                              setState(() {
                                print(newTime);
                                _starttime = newTime;
                              });
                            },
                          ),
                        );
                      },
                      child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor),
                          child: Text(
                            "${AppLocalizations.of(context)!.from} ${_starttime.hour}:${_starttime.hour}",
                            style: const TextStyle(color: Colors.black),
                          )),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          showPicker(
                            context: context,
                            value: _endtime,
                            onChange: (newTime) {
                              setState(() {
                                _endtime = newTime;
                              });
                            },
                          ),
                        );
                      },
                      child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor),
                          child: Text(
                            "${AppLocalizations.of(context)!.to} ${_endtime.hour}:${_endtime.hour}",
                            style: const TextStyle(color: Colors.black),
                          )),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text((await UserRepo.setSechdule({
                      "date": "${date.year}/${date.month}/${date.day}",
                      "from_hour": "${_starttime.hour}:${_starttime.hour}",
                      "to_hour": "${_endtime.hour}:${_endtime.hour}",
                      "consultant_id":
                          BlocProvider.of<UserBloc>(context).user.id
                    })))));
                  },
                  child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration:
                          BoxDecoration(color: Theme.of(context).primaryColor),
                      child: Text(
                        AppLocalizations.of(context)!.confirm,
                        style: const TextStyle(color: Colors.black),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
