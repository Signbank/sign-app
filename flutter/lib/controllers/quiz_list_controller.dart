import 'package:sign_app/controllers/base_controller.dart';
import 'package:sign_app/models/sign.dart';
import 'package:sign_app/models/user_quiz_list_data.dart';
import 'package:sign_app/url_config.dart';

class QuizListController extends Controller {
  QuizListController(this._callback, this._isEditing,
      {UserQuizListData? userQuizListData})
      : _userQuizListData = userQuizListData ?? UserQuizListData(
      id: 0,
      userId: 1,
      lastPracticedDate: DateTime.now(),
      lastPracticedIndex: 0,
      name: '',
      signIDs: []);

  final UserQuizListData _userQuizListData;
  late List<Sign> _signs;
  final Function _callback;
  final bool _isEditing;
  final _endpointUrl = "/user-quiz-lists/";

  UserQuizListData saveList() {
    //TODO: add correct user id
    if (_isEditing) {
      super.putRequest(
          url: "$signAppBaseUrl$_endpointUrl${_userQuizListData.id}/",
          body: _userQuizListData,
          fromJsonFunction: UserQuizListData.fromJson);
    } else {
      super.postRequest(
          url: signAppBaseUrl + _endpointUrl,
          body: _userQuizListData,
          fromJsonFunction: UserQuizListData.fromJson);
    }

    return _userQuizListData;
  }

  ///Getters
  int get listsLength => _userQuizListData.signIDs.length;

  String get quizListName => _userQuizListData.name;

  String listsTitle(int index) {
    return _signs[index].name;
  }

  ///Setters
  void addSign(Sign sign) {
    _userQuizListData.signIDs.add(sign.id);
    _callback();
  }

  void removeSign(int index) {
    _signs.removeAt(index);
    _callback();
  }

  set setQuizListName(String name) => _userQuizListData.name = name;
}
