import 'package:restart/models/TransactionModel.dart';

class UserModel {
  String id;
  String name;
  String email;
  String hp;
  String address;
  String addressDetails;
  String profilePic;
  DateTime joined;
  List<TransactionModel>? upcomingTxns;
  DateTime updatedAt;

  UserModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.hp,
      required this.address,
      required this.addressDetails,
      required this.profilePic,
      required this.joined,
      required this.upcomingTxns,
      required this.updatedAt});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['_id'],
        name: json['name'] ?? "",
        email: json['email'] ?? "",
        hp: json['hp'],
        address: json['address'] ?? "",
        addressDetails: json['addressDetails'] ?? "",
        profilePic: json['profilePic'],
        joined: DateTime.parse(json['joined']),
        upcomingTxns: json['seller']?['upcoming'] ?? [],
        updatedAt: DateTime.parse(json['updatedAt']).toLocal());
  }

  @override
  String toString() {
    return 'name: $name, email: $email, hp: $hp, address: $address, profilePic: $profilePic, joined: $joined, upcomingTxns: $upcomingTxns';
  }
}
