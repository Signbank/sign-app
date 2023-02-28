import 'package:sign_app/models/quiz_list.dart';

class UserQuizListData{
  int userId;
  DateTime lastPracticed;
  int lastPracticedIndex;
  bool isOwner;
  QuizList quizList;

  UserQuizListData(this.userId, this.lastPracticed, this.lastPracticedIndex, this.isOwner, this.quizList);
}