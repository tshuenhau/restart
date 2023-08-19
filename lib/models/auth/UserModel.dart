import 'package:restart/models/TransactionModel.dart';
import 'dart:math';

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
  double total_weight;
  int exp_for_level;
  int level;
  String app_version;
  String fcmToken;
  List<int> forest;
  List<dynamic> history;

  UserModel({
    required this.id,
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
    required this.exp_for_level,
    required this.app_version,
    required this.fcmToken,
    required this.forest,
    required this.history,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    print(json);
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
      total_weight: json['total_weight'].toDouble() ?? 0.00,
      total_points: json['total_points'] ?? 0,
      exp_for_level:
          json['exp_for_level'] ?? (pow(json['level'], 1.3) * 20).ceil(),
      level: json['level'] ?? 1,
      app_version: json['app_version'] ?? "",
      fcmToken: json['fcm_token'] ?? "",
      forest: json['forest'].length == 0
          ? [0, 0, 0, 0, 0, 0, 0, 0, 0]
          : json['forest'].cast<int>(),
      history: json["seller"]["history"],
    );
  }

  @override
  String toString() {
    return 'name: $name, email: $email, hp: $hp, address: $address, profilePic: $profilePic, joined: $joined, forest: $forest';
  }
}
