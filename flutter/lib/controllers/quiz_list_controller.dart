import 'package:sign_app/controllers/base_controller.dart';
import 'package:sign_app/models/sign.dart';
import 'package:sign_app/models/user_quiz_list_data.dart';
import 'package:sign_app/url_config.dart';

class QuizListController extends Controller {
  QuizListController(this._callback, this._isEditing,
      {UserQuizListData? userQuizListData})
      : _userQuizListData = userQuizListData ??
            UserQuizListData(
                id: 0,
                userId: 1,
                lastPracticedDate: DateTime.now(),
                lastPracticedIndex: 0,
                name: '',
                signIDs: []);

  final UserQuizListData _userQuizListData;
  final List<Sign> _signs = List.empty(growable: true);
  final Function _callback;
  final bool _isEditing;
  final _endpointUrl = "/user-quiz-lists/";

  Future<UserQuizListData> saveList() async {
    if (_isEditing) {
      return await super.putRequest(
          url: "$signAppBaseUrl$_endpointUrl${_userQuizListData.id}/",
          body: _userQuizListData,
          fromJsonFunction: UserQuizListData.fromJson);
    }
    return await super.postRequest(
        url: signAppBaseUrl + _endpointUrl,
        body: _userQuizListData,
        fromJsonFunction: UserQuizListData.fromJson,
        requiresCredentials: true);
  }

  Future<void> getSignData() async {
    const endpointUrl = '/dictionary/gloss/api/';
    List<Sign> signData = await super.postRequest(url: signBankBaseUrl+endpointUrl, fromJsonFunction: Sign.listFromJson, body: _userQuizListData.signIDs);
    _signs.addAll(signData);
  }

  ///Getters
  int get listsLength => _userQuizListData.signIDs.length;

  String get quizListName => _userQuizListData.name;

  String listsTitle(int index) {
    return _signs[index].name;
  }

  ///Setters
  void addSign(Sign sign) {
    for(var element in _signs){
      if(element.id == sign.id){
        return;
      }
    }
    _signs.add(sign);
    _userQuizListData.signIDs.add(sign.id);
    _callback();
  }

  bool removeSign(int index) {
    if(_userQuizListData.signIDs.length <=1){
      return false;
    }

    _signs.removeAt(index);
    _userQuizListData.signIDs.removeAt(index);
    _callback();
    return true;
  }

  set setQuizListName(String name) => _userQuizListData.name = name;
}
