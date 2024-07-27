import 'package:advise_me/presentation/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../logic/BloCs/languageBloc/language_bloc.dart';
import '../strings.dart';
import 'User Screens/sign_up_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<bool> languageSelected = [true, false];
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SafeArea(
                  child: SizedBox(
                      width: size.width,
                      height: size.height * 0.48,
                      child: Image.asset(
                        "assets/icon.png",
                        fit: BoxFit.fill,
                      ))),
              Container(
                width: double.infinity,
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.all(7),
                  width: size.width * 0.7,
                  height: size.height * 0.14,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  child: BlocBuilder<LanguageBloc, LanguageState>(
                    builder: (context, state) {
                      return Text(
                        state is Arabic ? qouteAR : qouteEN,
                        textAlign:
                            state is Arabic ? TextAlign.right : TextAlign.left,
                        style: GoogleFonts.arvo(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                            fontSize: 20),
                        maxLines: 2,
                      );
                    },
                  ),
                ),
              ),
              Container(
                height: size.height * 0.1,
                alignment: Alignment.center,
                width: size.width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const SignInScreen()));
                    }, child: BlocBuilder<LanguageBloc, LanguageState>(
                      builder: (context, state) {
                        return Text(
                          state is English ? "Sign in" : "تسجيل الدخول",
                          style: GoogleFonts.arvo(
                              fontSize: 23,
                              color: Theme.of(context).primaryColor),
                        );
                      },
                    )),
                    VerticalDivider(
                        color:
                            Colors.deepPurpleAccent.shade100.withOpacity(0.7)),
                    TextButton(onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const SignUpScreen()));
                    }, child: BlocBuilder<LanguageBloc, LanguageState>(
                      builder: (context, state) {
                        return Text(
                          state is English ? "Sign up" : "تسجيل حساب",
                          style: GoogleFonts.arvo(
                              fontSize: 23,
                              color: Theme.of(context).primaryColor),
                        );
                      },
                    )),
                  ],
                ),
              ),
              Container(
                height: size.height * 0.1,
                margin: const EdgeInsets.all(5),
                alignment: Alignment.center,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: BlocConsumer<LanguageBloc, LanguageState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    languageSelected = [state is English, state is Arabic];

                    return ToggleButtons(
                      borderRadius: BorderRadius.circular(10),
                      onPressed: (int index) {
                        if (index == 0) {
                          BlocProvider.of<LanguageBloc>(context)
                              .add(Select(english: (true)));
                        } else {
                          BlocProvider.of<LanguageBloc>(context)
                              .add(Select(english: (false)));
                        }
                        languageSelected = [false, false];
                        languageSelected[index] = true;
                      },
                      isSelected: languageSelected,
                      fillColor: Theme.of(context).primaryColor,
                      children: [
                        SizedBox(
                          width: size.width * 0.3,
                          child: const Text(
                            "English",
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.3,
                          child: const Text(
                            "عربي",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
