import 'package:advise_me/logic/BloCs/User%20BloC/user_bloc.dart';
import 'package:advise_me/presentation/Admin%20Screens/admin.dart';
import 'package:advise_me/presentation/Con%20Screens/home_con.dart';
import 'package:advise_me/presentation/User%20Screens/home_user.dart';
import 'package:advise_me/presentation/User%20Screens/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import '../logic/BloCs/Profile BloC/profile_bloc.dart';
import '../logic/BloCs/languageBloc/language_bloc.dart';
import '../logic/Repos/userRepo.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is Consultant) {
            BlocProvider.of<ProfileBloc>(context).add(GetProfile(id: state.id));

            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const HomeCon()),
                (Route<dynamic> route) => false);
          } else if (state is User) {
            BlocProvider.of<ProfileBloc>(context).add(GetProfile(id: state.id));

            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const HomeUser()),
                (Route<dynamic> route) => false);
          } else if (state is Failed) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          } else if (state is Admin) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const AdminScreen()),
                (Route<dynamic> route) => false);
          }
        },
        child: Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(10),
              height: 500,
              alignment: Alignment.center,
              width: size.width * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BlocBuilder<LanguageBloc, LanguageState>(
                    builder: (context, state) {
                      return Text(
                        state is English ? "Welcome" : "أهلا بك من جديد",
                        style: GoogleFonts.arvo(
                            fontWeight: FontWeight.bold,
                            fontSize: 33,
                            color: Theme.of(context).primaryColor),
                      );
                    },
                  ),
                  TextField(
                    controller: email,
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              color: Theme.of(context).secondaryHeaderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              color: Theme.of(context).secondaryHeaderColor),
                        ),
                        hintText: AppLocalizations.of(context)!.email),
                  ),
                  TextField(
                    controller: password,
                    obscureText: true,
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              color: Theme.of(context).secondaryHeaderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              color: Theme.of(context).secondaryHeaderColor),
                        ),
                        hintText: AppLocalizations.of(context)!.pass),
                  ),
                  BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      return GestureDetector(
                        onTap: () async {
                          if (email.text.isNotEmpty) {
                            if ((await UserRepo.reset({"email": email.text})) ==
                                1) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Please check your email for new password")));
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Please enter your email above")));
                          }
                        },
                        child: Container(
                          width: size.width * 0.7,
                          child: BlocBuilder<LanguageBloc, LanguageState>(
                            builder: (context, state) {
                              return Text(
                                state is English
                                    ? "Reset your password"
                                    : "اعد تعيين كلمة المرور",
                                style: GoogleFonts.arvo(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      if (email.text.isNotEmpty && password.text.isNotEmpty) {
                        BlocProvider.of<UserBloc>(context).add(
                            Signin(email: email.text, password: password.text));
                      }
                    },
                    child: Container(
                        alignment: Alignment.center,
                        height: size.height * 0.08,
                        width: size.width * 0.7,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: BlocBuilder<UserBloc, UserState>(
                          builder: (context, state) {
                            if (state is Loading) {
                              return CircularProgressIndicator();
                            } else {
                              return Text(
                                AppLocalizations.of(context)!.sign_in,
                                style: GoogleFonts.arvo(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              );
                            }
                          },
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen()));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: size.width * 0.7,
                      child: BlocBuilder<LanguageBloc, LanguageState>(
                        builder: (context, state) {
                          return Text(
                            state is English
                                ? "Don't have an account? ? sign up"
                                : "ليس لديك حساب؟ انشأ حساب",
                            style: GoogleFonts.arvo(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
