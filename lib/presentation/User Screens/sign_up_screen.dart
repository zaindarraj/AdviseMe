import 'package:advise_me/logic/BloCs/User%20BloC/user_bloc.dart';
import 'package:advise_me/presentation/Con%20Screens/sign_up_conslutant.dart';
import 'package:advise_me/presentation/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../logic/BloCs/languageBloc/language_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController fname = TextEditingController();
  TextEditingController confPas = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: BlocListener<UserBloc, UserState>(
          listener: (context, state) {},
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(10),
              width: size.width * 0.8,
              height: size.height ,
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  BlocBuilder<LanguageBloc, LanguageState>(
                    builder: (context, state) {
                      return SizedBox(
                        width: size.width * 0.8,
                        height: size.height * 0.1,
                        child: Center(
                          child: Text(
                            state is English
                                ? "Welcome"
                                : "أهلا بك,عرفنا عن نفسك",
                            style: GoogleFonts.arvo(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Theme.of(context).secondaryHeaderColor),
                            maxLines: 2,
                          ),
                        ),
                      );
                    },
                  ),
                  Flexible(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextField(
                          maxLength: 25,
                          controller: email,
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color:
                                        Theme.of(context).secondaryHeaderColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color:
                                        Theme.of(context).secondaryHeaderColor),
                              ),
                              hintText: "Email"),
                        ),
                        TextField(
                          controller: fname,
                          maxLength: 8,
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color:
                                        Theme.of(context).secondaryHeaderColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color:
                                        Theme.of(context).secondaryHeaderColor),
                              ),
                              hintText: "First Name"),
                        ),
                        TextField(
                          maxLength: 8,
                          controller: lname,
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color:
                                        Theme.of(context).secondaryHeaderColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color:
                                        Theme.of(context).secondaryHeaderColor),
                              ),
                              hintText: "Last Name"),
                        ),
                        Form(
                          autovalidateMode: AutovalidateMode.disabled,
                          key: _form,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextFormField(
                                maxLength: 40,
                                onChanged: (value) {
                                  _form.currentState!.validate();
                                },
                                validator: ((value) {
                                  if (password.text != confPas.text) {
                                    return "Passwords don't match";
                                  }
                                  return null;
                                }),
                                controller: password,
                                obscureText: true,
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
                                    hintText: "Password"),
                              ),
                              TextField(
                                maxLength: 40,
                                controller: confPas,
                                obscureText: true,
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
                                    hintText: "Confirm Password"),
                                onChanged: (value) {
                                  _form.currentState!.validate();
                                },
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (email.text.isEmpty ||
                                password.text.isEmpty ||
                                fname.text.isEmpty ||
                                lname.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "Please fill out the whole fileds")));
                            } else {
                              BlocProvider.of<UserBloc>(context)
                                  .add(Signup(args: {
                                "email": email.text,
                                "password": password.text,
                                "fname": fname.text,
                                "lname": lname.text,
                                "accountType": "1",
                              }));
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
                                  state is English ? "Sign Up" : "انشاء الحساب",
                                  style: GoogleFonts.arvo(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
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
                                    builder: (context) =>
                                        const SignInScreen()));
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            height: size.height * 0.08,
                            width: size.width * 0.7,
                            child: BlocBuilder<LanguageBloc, LanguageState>(
                              builder: (context, state) {
                                return Text(
                                  state is English
                                      ? "Already have an account ? sign in"
                                      : "لديك حساب مسبق ؟ سجل دخول",
                                  style: GoogleFonts.arvo(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
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
                                    builder: (context) =>
                                        const SignUpScreenCon()));
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            height: size.height * 0.08,
                            width: size.width * 0.7,
                            child: BlocBuilder<LanguageBloc, LanguageState>(
                              builder: (context, state) {
                                return Text(
                                  state is English
                                      ? "You are a conultant ? sign up"
                                      : "انت مرشد ؟ انشئ حسابا",
                                  style: GoogleFonts.arvo(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
