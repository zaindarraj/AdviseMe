import 'package:advise_me/logic/BloCs/User%20BloC/user_bloc.dart';
import 'package:advise_me/presentation/Con%20Screens/sign_up_conslutant.dart';
import 'package:advise_me/presentation/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
      appBar: AppBar(),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {},
        child: Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(10),
              width: size.width * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Text(
                      AppLocalizations.of(context)!.welcome,
                      style:
                          TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextField(
                    maxLength: 25,
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
                    controller: fname,
                    maxLength: 8,
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
                        hintText: AppLocalizations.of(context)!.first_name),
                  ),
                  TextField(
                    maxLength: 8,
                    controller: lname,
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
                        hintText: AppLocalizations.of(context)!.last_name),
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
                                    color:
                                        Theme.of(context).secondaryHeaderColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color:
                                        Theme.of(context).secondaryHeaderColor),
                              ),
                              hintText: AppLocalizations.of(context)!.password),
                        ),
                        TextField(
                          maxLength: 40,
                          controller: confPas,
                          obscureText: true,
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
                              hintText:
                                  AppLocalizations.of(context)!.conf_pass),
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
                            const SnackBar(
                                content:
                                    Text("Please fill out the whole fileds")));
                      } else {
                        BlocProvider.of<UserBloc>(context).add(Signup(args: {
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
                              builder: (context) => const SignInScreen()));
                    },
                    child: Container(
                        alignment: Alignment.centerLeft,
                        height: size.height * 0.08,
                        width: size.width * 0.7,
                        child: Text(
                          AppLocalizations.of(context)!.already_have_account,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreenCon()));
                    },
                    child: Container(
                        alignment: Alignment.centerLeft,
                        height: size.height * 0.08,
                        width: size.width * 0.7,
                        child: Text(
                          AppLocalizations.of(context)!.you_cons,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )),
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
