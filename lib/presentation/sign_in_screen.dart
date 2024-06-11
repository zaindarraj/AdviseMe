import 'package:advise_me/logic/BloCs/User%20BloC/user_bloc.dart';
import 'package:advise_me/logic/Repos/userRepo.dart';
import 'package:advise_me/presentation/User%20Screens/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../logic/BloCs/languageBloc/language_bloc.dart';

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
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {},
        child: Center(
          child: Container(
            padding: EdgeInsets.all(10),
            width: size.width * 0.8,
            height: size.height * 0.7,
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
                          color: Theme.of(context).secondaryHeaderColor),
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
                      hintText: "Email"),
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
                      hintText: "Password"),
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
                    child: BlocBuilder<LanguageBloc, LanguageState>(
                      builder: (context, state) {
                        return Text(
                          state is English ? "Sign in" : "تسجيل الدخول",
                          style: GoogleFonts.arvo(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                  ),
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
                    height: size.height * 0.08,
                    width: size.width * 0.7,
                    child: BlocBuilder<LanguageBloc, LanguageState>(
                      builder: (context, state) {
                        return Text(
                          state is English
                              ? "Don't have an account? ? sign up"
                              : "ليس لديك حساب؟ انشأ حساب",
                          style: GoogleFonts.arvo(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if (email.text.isNotEmpty) {
                      if ((await UserRepo.reset({"email": email.text})) == 1) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Please check your email for new password")));
                      }
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Please enter your email above")));
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: size.height * 0.08,
                    width: size.width * 0.7,
                    child: BlocBuilder<LanguageBloc, LanguageState>(
                      builder: (context, state) {
                        return Text(
                          state is English
                              ? "Reset your password"
                              : "اعد تعيين كلمة المرور",
                          style: GoogleFonts.arvo(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
