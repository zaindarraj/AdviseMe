import 'package:advise_me/logic/BloCs/User%20BloC/user_bloc.dart';
import 'package:advise_me/logic/BloCs/languageBloc/language_bloc.dart';
import 'package:advise_me/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  TextEditingController first = TextEditingController();
  TextEditingController second = TextEditingController();
  TextEditingController third = TextEditingController();
  TextEditingController fourth = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, lanState) {
        return Scaffold(
            body: Center(
          child: SizedBox(
            width: size.width * 0.8,
            height: size.height * 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  lanState is English ? verifyEn : verifyAr,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.arvo(fontSize: 23),
                ),
                Text(
                  BlocProvider.of<UserBloc>(context).user.email,
                  style: GoogleFonts.arvo(fontSize: 18),
                ),
                SizedBox(
                  height: size.height * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                          width: size.width * 0.15,
                          child: TextField(
                              keyboardType: TextInputType.number,
                              controller: first,
                              maxLength: 1,
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Theme.of(context)
                                          .secondaryHeaderColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Theme.of(context)
                                          .secondaryHeaderColor),
                                ),
                              ))),
                      SizedBox(
                          width: size.width * 0.15,
                          child: TextField(
                              keyboardType: TextInputType.number,
                              controller: second,
                              maxLength: 1,
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Theme.of(context)
                                          .secondaryHeaderColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Theme.of(context)
                                          .secondaryHeaderColor),
                                ),
                              ))),
                      SizedBox(
                          width: size.width * 0.15,
                          child: TextField(
                              keyboardType: TextInputType.number,
                              controller: third,
                              maxLength: 1,
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Theme.of(context)
                                          .secondaryHeaderColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Theme.of(context)
                                          .secondaryHeaderColor),
                                ),
                              ))),
                      SizedBox(
                          width: size.width * 0.15,
                          child: TextField(
                              controller: fourth,
                              maxLength: 1,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Theme.of(context)
                                          .secondaryHeaderColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Theme.of(context)
                                          .secondaryHeaderColor),
                                ),
                              )))
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (first.text.isNotEmpty &&
                        second.text.isNotEmpty &&
                        third.text.isNotEmpty &&
                        fourth.text.isNotEmpty) {
                      BlocProvider.of<UserBloc>(context).add(Verify(
                          id: BlocProvider.of<UserBloc>(context).user.id,
                          pin: first.text +
                              second.text +
                              third.text +
                              fourth.text));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Please fill out all the fields.")));
                    }
                  },
                  child: Container(
                      alignment: Alignment.center,
                      height: size.height * 0.08,
                      width: size.width * 0.7,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        lanState is English ? "Verify" : "تأكيد الحساب",
                        style: GoogleFonts.arvo(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      )),
                )
              ],
            ),
          ),
        ));
      },
    );
  }
}
