import 'package:sign_app/controllers/base_controller.dart';
import 'package:sign_app/models/user_quiz_list_data.dart';
import 'package:sign_app/url_config.dart';

class HomePageController extends Controller {
  HomePageController(this._callback);

  final Function _callback;
  List<UserQuizListData> _lists = List.empty(growable: true);
  final _endpointUrl = "/user-quiz-lists/";
  UserQuizListData? _mostRecentQuiz;

  Future<void> fetchListData() async {
    var returnData = await super.getRequest(
        url: signAppBaseUrl + _endpointUrl,
        fromJsonFunction: UserQuizListData.listFromJson,
        requiresCredentials: true);

    if (returnData != null) {
      _lists = returnData;
      setMostRecentQuiz();
      _callback();
    }
  }

  void setMostRecentQuiz() {
    if(_lists.isEmpty){
      _mostRecentQuiz = null;
      return;
    }

    _mostRecentQuiz ??= _lists.first;

    for (var element in _lists) {
      if (element.lastPracticedDate
          .isAfter(_mostRecentQuiz!.lastPracticedDate)) {
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
  String get lastPracticedListName => _mostRecentQuiz != null ? _mostRecentQuiz!.name : "";

  double get lastPracticedListProgression => _mostRecentQuiz != null ?
      (_mostRecentQuiz!.lastPracticedIndex / _mostRecentQuiz!.signIDs.length) : 0.0;

  UserQuizListData? get lastPracticedListData => _mostRecentQuiz;

  int get listsLength => _lists.length;

  String listsTitle(int index) => _lists[index].name;

  UserQuizListData getUserQuizListData(int index) {
    return _lists[index];
  }

  ///Setters
  void addList(UserQuizListData dataList) {
    _lists.add(dataList);
    _callback();
  }
}
