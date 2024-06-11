import 'package:advise_me/logic/BloCs/Notification%20BloC/cubit/notification_cubit.dart';
import 'package:advise_me/logic/BloCs/Profile%20BloC/profile_bloc.dart';
import 'package:advise_me/logic/BloCs/User%20BloC/user_bloc.dart';
import 'package:advise_me/presentation/main_screen.dart';
import 'package:advise_me/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'logic/BloCs/languageBloc/language_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => NotificationCubit(num: "0")),
          BlocProvider(create: (_) => LanguageBloc()..add(StartUp())),
          BlocProvider(create: (_) => UserBloc()..add(CheckStorage())),
          BlocProvider(create: (_) => ProfileBloc()),
        ],
        child: MaterialApp(
          theme: ThemeData(
            primaryColor: const Color.fromRGBO(225, 190, 231, 0.5),
            secondaryHeaderColor: const Color.fromRGBO(33, 33, 33, 1),
          ),
          title: appTitle,
          home: const MainScreen(),
        ));
  }
}
