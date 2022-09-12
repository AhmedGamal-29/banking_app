import 'package:banking_app/cubit/states.dart';
import 'package:banking_app/database/app_data/app_data.dart';
import 'package:banking_app/models/customer.dart';
import 'package:banking_app/models/transaction.dart';
import 'package:banking_app/screens/customers_screen.dart';
import 'package:banking_app/screens/transactions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppCubit extends Cubit<AppStates> {
  final AppData appData;
  AppCubit({required this.appData}) : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screens = [
    const CustomersScreen(),
    const TransfersScreen(),
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  List<Transfer> transfers = [];
  getAllTransfers() {
    appData.getAllTransfer()?.then((value) {
      transfers = value;
    });
  }

  makeTransfer(Transfer transfer, Customer sender, Customer receiver) {
    //sender.currentBalance -= transfer.transferMoney;
    appData
        .updateCustomer(sender, sender.currentBalance - transfer.transferMoney)
        .then((value) {
      getAllTransfers();
      emit(BankDbTransferAddedState());
    });

    appData
        .updateCustomer(
            receiver, receiver.currentBalance + transfer.transferMoney)
        .then((value) {
      //repository.getAllCustomers();
      emit(BankDbTransferAddedState());
    });

    appData.insertTransfer(transfer);
  }

  Customer? dropDawnValue;
  changeDropDownValue(Customer? newValue) {
    dropDawnValue = newValue;
    emit(ChangeDropDownValue());
  }

  Future<List<Customer?>> getSenderReceiverById(
      int senderId, int receiverId) async {
    return [
      await appData.findCustomerById(senderId),
      await appData.findCustomerById(receiverId)
    ];
  }
}
