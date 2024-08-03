import 'package:advise_me/logic/BloCs/Notification%20BloC/cubit/notification_cubit.dart';
import 'package:advise_me/logic/BloCs/Profile%20BloC/profile_bloc.dart';
import 'package:advise_me/logic/BloCs/User%20BloC/user_bloc.dart';
import 'package:advise_me/presentation/SplashScreen.dart';
import 'package:advise_me/strings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'firebase_options.dart';
import 'logic/BloCs/languageBloc/language_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: state.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate, // Add this line
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'), // English
              Locale('ar'), // Arabic
            ],
            theme: ThemeData(
              secondaryHeaderColor:
                  const Color.fromRGBO(172, 168, 231, 0.8745098039215686),
              primaryColor: const Color.fromRGBO(172, 168, 231, 1.0),
            ),
            title: appTitle,
            home: const Splashscreen(),
          );
        },
      ),
    );
  }
}
