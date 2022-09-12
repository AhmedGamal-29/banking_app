
class Customer {
  int? id; //id in db
  late String name;
  late String email;
  late String phone;
  late double currentBalance;

  Customer(
      {this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.currentBalance});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['customerId'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    currentBalance = json['currentBalance'];
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
        'currentBalance': currentBalance,
      };

  @override
  bool operator ==(Object other) => other is Customer && other.name == name;

  @override
  int get hashCode => name.hashCode;
}
