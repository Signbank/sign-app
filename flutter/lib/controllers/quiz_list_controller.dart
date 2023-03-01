import 'package:sign_app/controllers/base_controller.dart';
import 'package:sign_app/models/quiz_list.dart';
import 'package:sign_app/models/sign.dart';
import 'package:sign_app/models/user_quiz_list_data.dart';
import 'package:sign_app/url_config.dart';

class QuizListController extends Controller {
  QuizListController(this._callback, {QuizList? quizList})
      : _quizList = quizList ?? QuizList(id: 0, name: '', signs: []);

  final QuizList _quizList;
  final Function _callback;

  UserQuizListData saveList() {
    //TODO: add correct user id
    var userListData = UserQuizListData(
        id: 0,
        userId: 1,
        lastPracticedDate: DateTime.now(),
        lastPracticedIndex: 0,
        quizList: _quizList);

    super.postRequest(
        url: "$signAppBaseUrl/user-quiz-lists/",
        body: userListData,
        fromJsonFunction: UserQuizListData.fromJson);

    return userListData;
  }

  ///Getters
  int get listsLength => _quizList.signs.length;

  QuizList get quizList => _quizList;

  String listsTitle(int index) {
    return _quizList.signs[index].name;
  }

  ///Setters
  void addSign(Sign sign) {
    _quizList.signs.add(sign);
    _callback();
  }

  void removeSign(int index) {
    _quizList.signs.removeAt(index);
    _callback();
  }

  set setQuizListName(String name) => _quizList.name = name;
}
