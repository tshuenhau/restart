class TimeslotModel {
  String id;
  DateTime time;
  List<double> location;

  TimeslotModel({required this.id, required this.time, required this.location});

  factory TimeslotModel.fromJson(Map<String, dynamic> json) {
    return TimeslotModel(
        id: json['_id'],
        time: DateTime.parse(json['time']).toLocal(),
        location: List.from(json['location']));
  }
}
