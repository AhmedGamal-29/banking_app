import 'package:banking_app/cubit/cubit.dart';
import 'package:banking_app/constants/const.dart';
import 'package:banking_app/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'database/app_data/app_data.dart';
import 'database/app_data/sqflite_data.dart';

Future<void> main() async {
  await Hive.initFlutter();

  final customersData = SqliteData();
  await customersData.init();

  runApp(MyApp(appData: customersData));
}

class MyApp extends StatelessWidget {
  final AppData appData;

  const MyApp({required this.appData, Key? key}) : super(key: key);

  // root of the application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(appData: appData)..getAllTransfers(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.blue,
            appBarTheme: const AppBarTheme(color: secondaryColor),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              selectedItemColor: secondaryColor,
            )),
        home: const WelcomeScreen(),
      ),
    );
  }
}
