import 'package:banking_app/constants/const.dart';
import 'package:banking_app/cubit/cubit.dart';
import 'package:banking_app/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var appCubit = AppCubit.get(context);
          return Scaffold(
            backgroundColor: secondaryColor,
            appBar: AppBar(
              backgroundColor: primaryColor,
              title: const Text('Banking App'),
            ),
            body: appCubit.screens[appCubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: primaryColor,
              currentIndex: AppCubit.get(context).currentIndex,
              onTap: (index) {
                appCubit.changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: 'Customers',
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.monetization_on_outlined),
                    label: 'Transfers'),
              ],
            ),
          );
        });
  }
}
