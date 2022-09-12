import 'package:banking_app/constants/const.dart';
import 'package:banking_app/cubit/cubit.dart';
import 'package:banking_app/cubit/states.dart';
import 'package:banking_app/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:banking_app/models/customer.dart';

class TransfersScreen extends StatelessWidget {
  const TransfersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          List<Transfer> transfers = AppCubit.get(context).transfers;
          if (transfers.isEmpty) {
            return const Center(
              child: Card(
                  color: primaryColor,
                  child: Text(
                    'No Transfers Yet!',
                    style: TextStyle(color: secondaryColor, fontSize: 25.0),
                  )),
            );
          } else {
            return ListView.separated(
                itemBuilder: (context, index) =>
                    TransactionsListItem(transfer: transfers[index]),
                separatorBuilder: (context, index) => const Divider(),
                itemCount: transfers.length);
          }
        },
        listener: (context, state) {});
  }
}

class TransactionsListItem extends StatelessWidget {
  final Transfer transfer;

  TransactionsListItem({required this.transfer, Key? key}) : super(key: key);

  Future<List<Customer>?>? senderReceiver;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          var appCubit = AppCubit.get(context);

          return FutureBuilder(
              future: appCubit.getSenderReceiverById(
                  transfer.senderId, transfer.receiverId),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Customer?>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Card(
                      color: primaryColor,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'From: ${snapshot.data?.first?.name}',
                                  style: const TextStyle(
                                      fontSize: 19, color: secondaryColor),
                                ),
                                const SizedBox(
                                  height: 9,
                                ),
                                Text(
                                  'To: ${snapshot.data?.last?.name}',
                                  style: const TextStyle(
                                      fontSize: 19, color: secondaryColor),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 40.0,
                          ),
                          Text(
                            '${transfer.transferMoney} USD',
                            style: const TextStyle(
                                fontSize: 19, color: moneyColor),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              });
        },
        listener: (context, state) {});
  }
}
