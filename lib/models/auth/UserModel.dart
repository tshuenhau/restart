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
  int current_points;
  int total_points;
  int total_weight;
  int level;
  String fcmToken;
  List<int> forest;

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
      required this.updatedAt,
      required this.current_points,
      required this.total_points,
      required this.total_weight,
      required this.level,
      required this.fcmToken,
      required this.forest});

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
      updatedAt: DateTime.parse(json['updatedAt']).toLocal(),
      current_points: json['current_points'] ?? 0,
      total_weight: json['total_weight'] ?? 0,
      total_points: json['total_points'] ?? 0,
      level: json['level'] ?? 1,
      fcmToken: json['fcm_token'] ?? "",
      forest: json['forest'].cast<int>() ?? [],
    );
  }

  @override
  String toString() {
    return 'name: $name, email: $email, hp: $hp, address: $address, profilePic: $profilePic, joined: $joined, upcomingTxns: $upcomingTxns';
  }
}
