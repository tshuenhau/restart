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
  MISSION_STATUS status;
  int code;

  MissionModel(
      {required this.id,
      required this.title,
      required this.body,
      required this.exp,
      required this.status,
      required this.code});

  factory MissionModel.fromJson(Map<String, dynamic> json) {
    int status = json['status'];
    return MissionModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      exp: json['exp'],
      status: json['status'] == 0
          ? MISSION_STATUS.INCOMPLETE
          : json['status'] == 1
              ? MISSION_STATUS.COMPLETED
              : MISSION_STATUS.COLLECTED,
      code: json['code'],
    );
  }

  @override
  String toString() {
    return 'title: $title, body: $body, exp: $exp, status: $status, code: $code';
  }
}
