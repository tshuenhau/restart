enum TXN_STATUS { INCOMPLETE, COMPLETED, CANCELLED, REJECTED }

class TransactionModel {
  String id;
  String user;
  String seller;
  DateTime date;
  String location;
  String locationDetails;
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
    required this.locationDetails,
    required this.points,
    required this.weight,
    required this.status,
    required this.updatedAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['_id'],
      user: json['seller'],
      seller: json['collector'],
      date: DateTime.parse(json['date']).toLocal(),
      location: json['location'],
      locationDetails: json['locationDetails'] ?? "",
      points: json['points'].toInt(),
      weight: json['weight'].toDouble(),
      status: TXN_STATUS.values[json['status']],
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  @override
  String toString() {
    return 'id: $id, location: $location, location details: $locationDetails, date: $date';
  }
}
