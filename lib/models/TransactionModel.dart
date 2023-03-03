import 'package:geocoding/geocoding.dart';

enum TXN_STATUS { INCOMPLETE, COMPLETED, CANCELLED, REJECTED }

class TransactionModel {
  String id;
  String user;
  String seller;
  DateTime date;
  List<dynamic> location;
  String locationString;
  int points;
  double weight;
  TXN_STATUS status;
  DateTime updatedAt;

  TransactionModel({
    required this.id,
    required this.user,
    required this.seller,
    required this.date,
    required this.location,
    required this.locationString,
    required this.points,
    required this.weight,
    required this.status,
    required this.updatedAt,
  });

  static Future<TransactionModel> create(Map<String, dynamic> json) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        json['location'][0], json['location'][1]);
    return TransactionModel(
      id: json['_id'],
      user: json['seller'],
      seller: json['collector'],
      date: DateTime.parse(json['date']),
      location: json['location'],
      locationString: placemarks[0].name.toString(),
      points: json['points'].toInt(),
      weight: json['weight'].toDouble(),
      status: TXN_STATUS.values[json['status']],
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  @override
  String toString() {
    return 'locationString: $locationString, location: $location, date: $updatedAt';
  }

  // factory TransactionModel.fromJson(Map<String, dynamic> json) {
  //   return TransactionModel(
  //     id: json['_id'],
  //     user: json['seller'],
  //     seller: json['collector'],
  //     date: DateTime.parse(json['date']),
  //     location: json['location'],
  //     points: json['points'].toInt(),
  //     weight: json['weight'].toDouble(),
  //     status: TXN_STATUS.values[json['status']],
  //     updatedAt: DateTime.parse(json['updatedAt']),
  //   );
  // }
}
