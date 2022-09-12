import 'package:banking_app/constants/const.dart';
import 'package:banking_app/cubit/cubit.dart';
import 'package:banking_app/cubit/states.dart';
import 'package:banking_app/models/customer.dart';
import 'package:banking_app/screens/customer_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          var appCubit = AppCubit.get(context);
          return FutureBuilder(
            future: appCubit.appData.getAllCustomers(),
            builder: (BuildContext context,
                AsyncSnapshot<List<Customer>?> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else {
                final customers = snapshot.data ?? [];
                return ListView.separated(
                    itemBuilder: (context, index) => CustomersListItem(
                          customer: customers[index],
                          customers: customers,
                        ),
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: customers.length);
              }
            },
          );
        },
        listener: (context, state) {});
  }
}

class CustomersListItem extends StatelessWidget {
  final Customer customer;
  final List<Customer> customers;

  const CustomersListItem(
      {required this.customer, required this.customers, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CustomerInfoScreen(
                      customer: customer,
                      customers: customers,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Card(
          color: primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customer.name,
                          style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: secondaryColor),
                        ),
                        Text(
                          customer.email,
                          style: TextStyle(color: secondaryColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 40.0,
                  ),
                  Text(
                    '${customer.currentBalance.toString()} USD',
                    style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: moneyColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
