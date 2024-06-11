import 'package:advise_me/logic/BloCs/User%20BloC/user_bloc.dart';
import 'package:advise_me/presentation/Con%20Screens/schedule.dart';

import 'package:advise_me/presentation/main_screen.dart';
import 'package:advise_me/presentation/Con%20Screens/profileCon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCon extends StatefulWidget {
  const HomeCon({super.key});

  @override
  State<HomeCon> createState() => _HomeConState();
}

class _HomeConState extends State<HomeCon> {
  final _buildBody = <Widget>[
    const Schedule(),
    const ConProfileScreen(),
  ];
  int selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.white,
          onTap: (index) {
            setState(() {
              selectedPage = index;
            });
          },
          currentIndex: selectedPage,
          backgroundColor: const Color.fromARGB(255, 226, 212, 240),
          items: const [
            BottomNavigationBarItem(
              label: "Session",
              icon: Icon(
                Icons.chat,
              ),
            ),
            BottomNavigationBarItem(
              label: "Profile",
              icon: Icon(Icons.person),
            )
          ]),
      body: BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserInitial) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                  (Route<dynamic> route) => false);
            }
          },
          child: IndexedStack(
            index: selectedPage,
            children: _buildBody,
          )),
    );
  }
}
