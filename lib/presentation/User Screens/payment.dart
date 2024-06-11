import 'package:advise_me/logic/BloCs/User%20BloC/user_bloc.dart';
import 'package:advise_me/logic/BloCs/languageBloc/language_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../logic/Repos/userRepo.dart';

class Payment extends StatefulWidget {
  String sID;
  Payment({super.key, required this.sID});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  TextEditingController num = TextEditingController();
  TextEditingController name = TextEditingController();
  List<String> items = ["Paypal", "Apple Card"];
  List<DropdownMenuItem>? list;
  DateTime date = DateTime.now();
  String? value;
  @override
  void initState() {
    value = items.first;
    list = List.generate(
        2,
        (index) => DropdownMenuItem(
            value: items[index],
            child: Text(
              items[index],
              style: GoogleFonts.arvo(fontSize: 23),
            )));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SafeArea(
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back))
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BlocBuilder<LanguageBloc, LanguageState>(
                        builder: (context, state) {
                      if (state is English) {
                        return Text(
                          "Select Payment Method",
                          style: GoogleFonts.arvo(fontSize: 23),
                        );
                      } else {
                        return Text(
                          "اختر طريقة الدفع",
                          style: GoogleFonts.arvo(fontSize: 23),
                        );
                      }
                    }),
                    StatefulBuilder(builder: (context, setSpec) {
                      return Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        width: size.width * 0.8,
                        alignment: Alignment.centerLeft,
                        child: DropdownButton(
                            isExpanded: true,
                            icon: Icon(
                              Icons.payment,
                              size: 30,
                            ),
                            items: list,
                            value: value,
                            onChanged: (Newvalue) {
                              setSpec(() {
                                value = Newvalue;
                              });
                            }),
                      );
                    }),
                  ],
                ),
                TextField(
                  controller: num,
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
                      hintText: "CardNumber"),
                ),
                SizedBox(
                    height: size.height * 0.2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                            flex: 2,
                            child: BlocBuilder<LanguageBloc, LanguageState>(
                                builder: (context, state) {
                              if (state is English) {
                                return Text(
                                  "Expiration Date",
                                  style: GoogleFonts.arvo(fontSize: 23),
                                );
                              } else {
                                return Text(
                                  "نهاية الصلاحية",
                                  style: GoogleFonts.arvo(fontSize: 23),
                                );
                              }
                            })),
                        Flexible(
                          flex: 9,
                          child: Calendar(
                            initialDate: date,
                            onDateSelected: (value) {
                              setState(() {
                                print(value);
                                date = value;
                              });
                            },
                          ),
                        ),
                      ],
                    )),
                TextField(
                  controller: name,
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
                      hintText: "Card Holder Name"),
                ),
                GestureDetector(
                  onTap: () async {
                    if (num.text.isNotEmpty && name.text.isNotEmpty) {
                      if (date.isAfter(DateTime.now())) {
                        Map<String, dynamic> res = await UserRepo.bookSession({
                          "schedual_id": super.widget.sID,
                          "user_id": BlocProvider.of<UserBloc>(context).user.id
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(res["message"])));
                        Navigator.pop(context);
                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Your card has expired")));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Fill all fields")));
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
                          state is English
                              ? "Confirm Payment"
                              : "تأكيد العملية",
                          style: GoogleFonts.arvo(
                              fontSize: 22, fontWeight: FontWeight.bold),
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
    );
  }
}
