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
      _callback();
    }
  }

  void deleteList(int index) {
    super
        .deleteRequest(url: "$signAppBaseUrl$_endpointUrl${_lists[index].id}/");
    _lists.removeAt(index);
    _callback();
  }

  ///Getters
  String get lastPracticedListName => "Country names";
  double get lastPracticedListProgression => 0.8;
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
