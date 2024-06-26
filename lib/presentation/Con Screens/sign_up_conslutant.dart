import 'package:advise_me/logic/BloCs/User%20BloC/user_bloc.dart';
import 'package:advise_me/logic/classes/category.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../logic/BloCs/languageBloc/language_bloc.dart';
import '../../logic/Repos/cateRepo.dart';
import '../User Screens/sign_up_screen.dart';
import '../sign_in_screen.dart';

class SignUpScreenCon extends StatefulWidget {
  const SignUpScreenCon({Key? key}) : super(key: key);

  @override
  State<SignUpScreenCon> createState() => _SignUpScreenConState();
}

class _SignUpScreenConState extends State<SignUpScreenCon> {
  TextEditingController email = TextEditingController();
  TextEditingController confPas = TextEditingController();
  FilePickerResult? cer;
  FilePickerResult? cv;
  TextEditingController password = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController fname = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  Future<List<Category>>? categories;
  String? cat;
  @override
  void initState() {
    categories = CateRepo.getCats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {},
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(10),
              width: size.width * 0.8,
              height: size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BlocBuilder<LanguageBloc, LanguageState>(
                    builder: (context, state) {
                      return SizedBox(
                        width: size.width * 0.8,
                        height: size.height * 0.04,
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
                  Column(
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
                        maxLength: 8,
                        controller: fname,
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
                      FutureBuilder<List<Category>>(
                          future: categories,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasData) {
                                List<DropdownMenuItem> list = [];
                                cat = snapshot.data!.first.name;
                                for (var element in snapshot.data!) {
                                  list.add(DropdownMenuItem(
                                      value: element.name,
                                      child: Text(element.name)));
                                }
                                return StatefulBuilder(
                                    builder: (context, setSpec) {
                                  return Container(
                                    alignment: Alignment.centerLeft,
                                    child: DropdownButton(
                                        icon: const Icon(Icons.category),
                                        items: list,
                                        value: cat,
                                        onChanged: (value) {
                                          cat = value;
                                          setSpec(() {});
                                        }),
                                  );
                                });
                              }
                            }
                            return TextField(
                              enabled: false,
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
                                  hintText: "Speciality"),
                            );
                          }),
                      Row(
                        children: [
                          Row(
                            children: [
                              BlocBuilder<LanguageBloc, LanguageState>(
                                  builder: (context, state) {
                                return Text(state is English
                                    ? "Attach Certificate : "
                                    : "الشهادة");
                              }),
                              IconButton(
                                  onPressed: () async {
                                    try {
                                      cer = await FilePicker.platform.pickFiles(
                                          type: FileType.custom,
                                          allowedExtensions: ['pdf']);
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Please grant needed permissions")));
                                    }
                                  },
                                  icon: const Icon(Icons.attach_file))
                            ],
                          ),
                          Row(
                            children: [
                              BlocBuilder<LanguageBloc, LanguageState>(
                                  builder: (context, state) {
                                return Text(state is English
                                    ? "Attach CV : "
                                    : "السيرة الذاتية");
                              }),
                              IconButton(
                                  onPressed: () async {
                                    try {
                                      cv = await FilePicker.platform.pickFiles(
                                          type: FileType.custom,
                                          allowedExtensions: ['pdf']);
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Please grant needed permissions")));
                                    }
                                  },
                                  icon: const Icon(Icons.attach_file))
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          if (email.text.isEmpty ||
                              password.text.isEmpty ||
                              fname.text.isEmpty ||
                              lname.text.isEmpty ||
                              cv is! FilePickerResult ||
                              cer is! FilePickerResult) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Please fill out the whole fileds")));
                          } else {
                            BlocProvider.of<UserBloc>(context)
                                .add(Signup(args: {
                              "email": email.text,
                              "password": password.text,
                              "fname": fname.text,
                              "lname": lname.text,
                              "accountType": "2",
                              "specialty": cat,
                              "certificate": cer!.files.first.path,
                              "cv": cv!.files.first.path
                            }));
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Signing Up !")));
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
                          height: size.height * 0.04,
                          width: size.width * 0.7,
                          child: BlocBuilder<LanguageBloc, LanguageState>(
                            builder: (context, state) {
                              return Text(
                                state is English
                                    ? "Already have an account ? sign in"
                                    : "لديك حساب مسبق ؟ سجل دخول",
                                style: GoogleFonts.arvo(
                                    fontSize: 14, fontWeight: FontWeight.bold),
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
                          alignment: Alignment.centerLeft,
                          height: size.height * 0.04,
                          width: size.width * 0.7,
                          child: BlocBuilder<LanguageBloc, LanguageState>(
                            builder: (context, state) {
                              return Text(
                                state is English
                                    ? "You are a user ? sign up"
                                    : "انت مستخدم عادي ؟ سجل حساب",
                                style: GoogleFonts.arvo(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              );
                            },
                          ),
                        ),
                      )
                    ],
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
