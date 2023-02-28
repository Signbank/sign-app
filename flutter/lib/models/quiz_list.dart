import 'package:sign_app/models/sign.dart';

class QuizList {
  final int id;
  final String name;
  final List<Sign> signs;

  const QuizList({
    required this.id,
    required this.name,
    required this.signs,
  });

  factory QuizList.fromJson(Map<String, dynamic> json) {
    return QuizList(
      id: json['id'],
      name: json['name'],
      signs: Sign.listFromJson(json['signs']),
    );
  }
}
