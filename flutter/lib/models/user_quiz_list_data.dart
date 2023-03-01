import 'package:sign_app/models/quiz_list.dart';

class UserQuizListData{
  final int id;
  final int userId;
  final DateTime lastPracticedDate;
  final int lastPracticedIndex;
  final QuizList quizList;

  UserQuizListData({required this.id, required this.userId, required this.lastPracticedDate, required this.lastPracticedIndex, required this.quizList});

  factory UserQuizListData.fromJson(Map<String, dynamic> json) {
    return UserQuizListData(
      id: json['id'],
      userId: json['user'],
      lastPracticedDate: DateTime.parse(json['last_practiced']),
      lastPracticedIndex: json['last_sign_index'],
      quizList: QuizList.fromJson(json['quiz_list']),
    );
  }

  static List<UserQuizListData> listFromJson(List<dynamic> json) {
    return json
        .map((data) => UserQuizListData.fromJson(data as Map<String, dynamic>))
        .toList()
        .cast<UserQuizListData>();
  }

  Map<String, dynamic> toJson() => {
    'user': userId,
    'last_practiced': lastPracticedDate.toString(),
    'last_sign_index': lastPracticedIndex,
    'quiz_list': quizList.toJson(),
  };
}