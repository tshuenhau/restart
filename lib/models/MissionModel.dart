enum MISSION_STATUS {
  INCOMPLETE,
  COMPLETED,
  COLLECTED,
}

class MissionModel {
  String id;
  String title;
  String body;
  int exp;
  double weight;
  MISSION_STATUS status;
  int code;

  MissionModel(
      {required this.id,
      required this.title,
      required this.body,
      required this.weight,
      required this.exp,
      required this.status,
      required this.code});

  factory MissionModel.fromJson(Map<String, dynamic> json) {
    return MissionModel(
      id: json['_id'],
      title: json['title'] ?? "",
      body: json['body'] ?? "",
      weight: json['weight'].toDouble(),
      exp: json['exp'],
      status: json['status'] == 0
          ? MISSION_STATUS.INCOMPLETE
          : json['status'] == 1
              ? MISSION_STATUS.COMPLETED
              : MISSION_STATUS.COLLECTED,
      code: json['code'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'title: $title, body: $body, exp: $exp, status: $status, code: $code';
  }
}
