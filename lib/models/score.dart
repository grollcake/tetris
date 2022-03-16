import 'package:cloud_firestore/cloud_firestore.dart';

class Score {
  String? userId;
  String? username;
  int? score;
  int? stage;
  DateTime? dateTime;
  int? playCount;
  String? deviceUUID;
  String? platform;

  Score({
    this.userId,
    this.username,
    this.score,
    this.stage,
    this.dateTime,
    this.playCount,
    this.deviceUUID,
    this.platform,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'username': username,
        'score': score,
        'datetime': dateTime,
        'stage': stage,
        'playCount': playCount,
        'deviceUUID': deviceUUID,
        'platform': platform,
      };

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      userId: json['userId'],
      username: json['username'],
      score: json['score'],
      dateTime: json['datetime'] == null ? null : (json['datetime'] as Timestamp).toDate(),
      stage: json['stage'],
      playCount: json['playCount'],
      deviceUUID: json['deviceUUID'],
      platform: json['platform'],
    );
  }
}
