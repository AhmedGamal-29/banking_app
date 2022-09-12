import 'package:banking_app/models/customer.dart';
import 'package:banking_app/models/transaction.dart';

abstract class AppData {
  Future init();

  void close();

  Stream<List<Customer>>? watchAllCustomers();

  Stream<List<Transfer>>? watchAllTransfer();

  Future<List<Customer>>? getAllCustomers();

  Future<List<Transfer>>? getAllTransfer();

  Future<Customer>? findCustomerById(int id);

  Future<int> insertCustomer(Customer customer);

  Future<int> insertTransfer(Transfer transfer);

  Future updateCustomer(Customer customer, double currentBalance);
}
