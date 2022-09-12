
class Transfer {
  late int? id;
  late int receiverId;
  late int senderId;
  late double transferMoney;

  Transfer(
      {this.id,
      required this.receiverId,
      required this.senderId,
      required this.transferMoney});

  Transfer.fromJson(Map<String, dynamic> json) {
    id = json['transferId'];
    receiverId = json['receiverId'];
    senderId = json['senderId'];
    transferMoney = json['transferMoney'];
  }

  Map<String, dynamic> toJson() => {
        'receiverId': receiverId,
        'senderId': senderId,
        'transferMoney': transferMoney
      };
}
