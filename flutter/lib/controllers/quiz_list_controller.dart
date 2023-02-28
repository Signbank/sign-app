import 'package:sign_app/controllers/base_controller.dart';
import 'package:sign_app/models/quiz_list.dart';
import 'package:sign_app/models/sign.dart';

class QuizListController extends Controller {
  QuizListController(
      {QuizList quizList = const QuizList(id: 0, name: '', signs: [])})
      : _quizList = quizList;

  final QuizList _quizList;


  void saveList() {}

  ///Getters
  int get listsLength => _quizList.signs.length;
  QuizList get quizList => _quizList;

  String listsTitle(int index) {
    return _quizList.signs[index].name;
  }

  ///Setters
  void addSign(Sign sign) => _quizList.signs.add(sign);
  void removeSign(int index) => _quizList.signs.removeAt(index);

}
