import 'package:sign_app/models/sign.dart';

class QuizList {
  final int id;
  late String name;
  late List<Sign> signs;

  QuizList({
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

  Map<String, dynamic> toJson() => {
    'name': name,
    'signs': List.from(signs.map((sign) => sign.toJson())),
  };
}
