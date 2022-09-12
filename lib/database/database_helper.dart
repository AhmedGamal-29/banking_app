// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:banking_app/models/customer.dart';
import 'package:banking_app/models/transaction.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlbrite/sqlbrite.dart';
import 'package:synchronized/synchronized.dart';

class DatabaseHelper {
  static const _databaseName = 'banking.db';
  static const _databaseVersion = 1;

  static const customerTable = 'customer';
  static const transferTable = 'transfer';
  static const customerId = 'customerId';
  static const transferId = 'transferId';

  static late BriteDatabase _streamDatabase;

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static var lock = Lock();

  static Database? _database;

  // create database
  Future _onCreate(Database db, int version) async {
    //customer table
    await db.execute('''CREATE TABLE $customerTable (
          $customerId INTEGER PRIMARY KEY,
          name TEXT,
          email TEXT,
          phone TEXT,
          currentBalance REAL)
          ''');

    //transaction table
    await db.execute('''CREATE TABLE $transferTable (
          $transferId INTEGER PRIMARY KEY,
          receiverId INTEGER,
          senderId INTEGER,
          transferMoney REAL)
          ''');
  }

  // this opens the database (creates it if it doesn't exist)
  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);

    // TODO: Not forget to turn off debugging before deploying app to store(s).
    //Sqflite.setDebugModeOn(true);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    // Handling to prevent concurrent access to data
    await lock.synchronized(
      () async {
        // DB, first time to be accessed
        if (_database == null) {
          _database = await _initDatabase();
          _streamDatabase = BriteDatabase(_database!);
        }
      },
    );
    return _database!;
  }

  Future<BriteDatabase> get streamDatabase async {
    await database;
    return _streamDatabase;
  }

  List<Customer> parseCustomer(List<Map<String, dynamic>> customerMaps) {
    final List<Customer> customers = [];

    for (var customerMap in customerMaps) {
      final customer = Customer.fromJson(customerMap);
      customers.add(customer);
    }

    return customers;
  }

  List<Transfer> parseTransfer(List<Map<String, dynamic>> transferMaps) {
    final List<Transfer> transfers = [];

    for (var transferMap in transferMaps) {
      final transfer = Transfer.fromJson(transferMap);
      transfers.add(transfer);
    }

    return transfers;
  }

  Future<List<Customer>> getAllCustomers() async {
    final db = await instance.streamDatabase;
    final customerMaps = await db.query(customerTable);
    final List<Customer> customers = parseCustomer(customerMaps);
    if (customers.isEmpty) insertDummyData();
    return customers;
  }

  Stream<List<Customer>> watchAllCustomers() async* {
    final db = await instance.streamDatabase;
    yield* db.createQuery(customerTable).mapToList((row) {
      return Customer.fromJson(row);
    });
  }

  Future<List<Transfer>> getAllTransfers() async {
    final db = await instance.streamDatabase;
    final transferMaps = await db.query(transferTable);
    final transfers = parseTransfer(transferMaps);
    return transfers;
  }

  Stream<List<Transfer>> watchAllTransfer() async* {
    final db = await instance.streamDatabase;
    yield* db
        .createQuery(transferTable)
        .mapToList((row) => Transfer.fromJson(row));
  }

  Future<Customer> findCustomerById(int id) async {
    final db = await instance.streamDatabase;
    final customerMaps =
        await db.query(customerTable, where: 'customerId = $id');
    final List<Customer> customers = parseCustomer(customerMaps);
    return customers.first;
  }

  Future<int> insert(String table, Map<String, dynamic> row) async {
    final db = await instance.streamDatabase;
    return db.insert(table, row);
  }

  Future<int> insertCustomer(Customer customer) {
    return insert(customerTable, customer.toJson());
  }

  Future<int> insertTransfer(Transfer transfer) {
    return insert(transferTable, transfer.toJson());
  }

  Future updateCustomer(Customer customer, double currentBalance) async {
    final db = await instance.streamDatabase;
    return db.rawUpdate('''
    UPDATE $customerTable SET currentBalance = $currentBalance WHERE $customerId = ${customer.id}
    ''');
  }

  //Dummy Data
  Future insertDummyData() async {
    insertCustomer(Customer(
        name: "Ahmed Kamel",
        email: "ahmad33@email.com",
        phone: "+201464617852",
        currentBalance: 3000.0));
    insertCustomer(Customer(
        name: "Mohamed Ali",
        email: "mohamed20@email.com",
        phone: "+201664617852",
        currentBalance: 55000.60));
    insertCustomer(Customer(
        name: "Ibrahem Ali",
        email: "ibrahem10@email.com",
        phone: "+201764617852",
        currentBalance: 4550.0));
    insertCustomer(Customer(
        name: "Mariam Ahmed",
        email: "mariam100@email.com",
        phone: "+201864617852",
        currentBalance: 9500.45));
    insertCustomer(Customer(
        name: "Hazem Sabry",
        email: "hazem15@gmail.com",
        phone: "+201464617852",
        currentBalance: 7350.0));
    insertCustomer(Customer(
        name: "Hend Barkat",
        email: "hend39@gmail.com",
        phone: "+201464617852",
        currentBalance: 3950.80));
    insertCustomer(Customer(
        name: "Hatem Ahmad",
        email: "hatem57@gmail.com",
        phone: "+201464617852",
        currentBalance: 5900.0));
    insertCustomer(Customer(
        name: "Sara Ahmed",
        email: "sara31@gmail.com",
        phone: "+201777617852",
        currentBalance: 3370.0));
    insertCustomer(Customer(
        name: "Mazen Sayed",
        email: "mazen95@gmail.com",
        phone: "+201964617852",
        currentBalance: 7500.0));
    insertCustomer(Customer(
        name: "Mai Mohamed",
        email: "Mai75@gmail.com",
        phone: "+201964717852",
        currentBalance: 10500.40));
    getAllCustomers();
  }

  void close() {
    _streamDatabase.close();
  }
}
