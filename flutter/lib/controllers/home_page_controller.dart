import 'package:sign_app/controllers/base_controller.dart';
import 'package:sign_app/models/quiz_list.dart';
import 'package:sign_app/models/user_quiz_list_data.dart';
import 'package:sign_app/url_config.dart';

class HomePageController extends Controller {
  HomePageController(this._callback);

  final Function _callback;
  List<UserQuizListData> _lists = List.empty(growable: true);
  final _endpointUrl = "/user-quiz-lists/";
  late UserQuizListData _mostRecentQuiz;

  void getLastPracticedList() {
    _callback();
  }

  Future<void> fetchListData() async {
    var returnData = await super.getRequest(
        url: "$signAppBaseUrl/user-quiz-lists/",
        fromJsonFunction: UserQuizListData.listFromJson);

    if (returnData != null) {
      _lists = returnData;
      _setMostRecentQuiz();
      _callback();
    }
  }

  void _setMostRecentQuiz(){
    _mostRecentQuiz = _lists.first;
    for (var element in _lists) {
      if(element.lastPracticedDate.isBefore(_mostRecentQuiz.lastPracticedDate)){
        _mostRecentQuiz = element;
      }
    }
  }

  void deleteList(int index) {
    super
        .deleteRequest(url: "$signAppBaseUrl$_endpointUrl${_lists[index].id}/");
    _lists.removeAt(index);
    _callback();
  }

  ///Getters
  String get lastPracticedListName => _mostRecentQuiz.quizList.name;
  double get lastPracticedListProgression => (_mostRecentQuiz.lastPracticedIndex/_mostRecentQuiz.quizList.signs.length);
  int get listsLength => _lists.length;
  String listsTitle(int index) => _lists[index].quizList.name;
  UserQuizListData getUserQuizListData(int index) {
    return _lists[index];
  }

  ///Setters
  void addList(UserQuizListData dataList) {
    _lists.add(dataList);
    _callback();
  }

}
