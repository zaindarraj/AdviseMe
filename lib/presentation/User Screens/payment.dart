import 'package:advise_me/logic/BloCs/User%20BloC/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
              style: TextStyle(fontSize: 23),
            )));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Flexible(
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
                  Text(
                    AppLocalizations.of(context)!.payment_method,
                    style: GoogleFonts.arvo(fontSize: 23),
                  ),
                  Divider(
                    color: Colors.transparent,
                  ),
                  StatefulBuilder(builder: (context, setSpec) {
                    return Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10)),
                      width: size.width * 0.8,
                      alignment: Alignment.centerLeft,
                      child: DropdownButton(
                          isExpanded: true,
                          icon: const Icon(
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
              Divider(
                color: Colors.transparent,
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
                    hintText: AppLocalizations.of(context)!.card_number),
              ),
              SizedBox(
                height: size.height * 0.2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                        flex: 2,
                        child: Text(
                          AppLocalizations.of(context)!.exp_date,
                          style: GoogleFonts.arvo(fontSize: 23),
                        )),
                    Flexible(
                      flex: 6,
                      child: Calendar(
                        selectedTodayColor: Theme.of(context).primaryColor,
                        selectedColor: Theme.of(context).primaryColor,
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
                ),
              ),
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
                    hintText: AppLocalizations.of(context)!.card_name),
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
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Your card has expired")));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Fill all fields")));
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
                      AppLocalizations.of(context)!.conf_payment,
                      style: GoogleFonts.arvo(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
