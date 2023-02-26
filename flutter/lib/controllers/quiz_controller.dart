import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sign_app/controllers/base_controller.dart';
import 'package:sign_app/models/sign.dart';
import 'package:sign_app/views/quiz_notification_view.dart';

class QuizController extends Controller {
  QuizController(this._callback);

  final Function _callback;
  List<Sign> _signList = List.empty();
  late List<String> _multipleChoiceOptions;
  final List<int> _wrongAnswers = List.empty(growable: true);
  bool _isRepeatingWrongAnswers = false;
  int _currentSignIndex = 0;
  int _chosenAnswerIndex = 0;
  int _numberOfMultipleChoiceOptions = 3;

  Future<void> fetchQuiz() async {
    _signList = Sign.listFromJson(jsonDecode(_signJson));

    _multipleChoiceOptions = _getMultipleChoiceOptions(_currentSignIndex);

    _callback();
  }

  List<String> _getMultipleChoiceOptions(int index) {
    List<Sign> tempSignList = List.from(_signList);
    List<String> multipleChoiceOptions = [];

    //Add name of the current sign which is the correct answer
    multipleChoiceOptions.add(tempSignList[index].name);
    //Remove the current sign so that it can't be in the multiple choice list more than once
    tempSignList.removeAt(index);

    //Shuffle the list to make the items in random order
    tempSignList.shuffle();

    //Check if there are enough items in the list
    if (tempSignList.length - 1 < _numberOfMultipleChoiceOptions) {
      _numberOfMultipleChoiceOptions = tempSignList.length;
    }

    //Get the first random items of the list and add them to the multiple choice options
    tempSignList.sublist(0, _numberOfMultipleChoiceOptions).forEach((sign) {
      multipleChoiceOptions.add(sign.name);
    });

    //Shuffle the list so that the correct answer is not always the first one
    multipleChoiceOptions.shuffle();

    return multipleChoiceOptions;
  }

  void checkAnswer() {
    if(_isRepeatingWrongAnswers){
      return;
    }

    if (multipleChoiceOptions[_chosenAnswerIndex] !=
        _signList[_currentSignIndex].name) {
      _wrongAnswers.add(_currentSignIndex);
    }
  }

  void nextSign(BuildContext context) {
    // If the user is not at the end of the list increment the index and update the view
    if (_currentSignIndex < _signList.length - 1) {
      _currentSignIndex++;

      //Get new multiple choice options
      _multipleChoiceOptions = _getMultipleChoiceOptions(_currentSignIndex);
      _callback();
      return;
    }

    if (_wrongAnswers.length <= 1) {
      _showQuizDialog(context, true);
      _isRepeatingWrongAnswers = false;
      return;
    }

    // Completed the whole list so start repeating the wrong answers
    if (!_isRepeatingWrongAnswers) {
      _isRepeatingWrongAnswers = true;
      _multipleChoiceOptions = _getMultipleChoiceOptions(_wrongAnswers[0]);
      _showQuizDialog(context, false);
      _callback();
      return;
    }

    // User is already repeating the wrong answers so remote the first which they already covered
    _wrongAnswers.removeAt(0);
    _multipleChoiceOptions = _getMultipleChoiceOptions(_wrongAnswers[0]);
    _callback();
    return;
  }

  void _showQuizDialog(BuildContext context, bool isDone) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => QuizNotificationDialog(
              isDone: isDone,
            ),
        fullscreenDialog: true));
  }

  ///Getters
  String get signName => _isRepeatingWrongAnswers
      ? _wrongAnswerName
      : _signList[_currentSignIndex].name;

  String get signVideoUrl => _isRepeatingWrongAnswers
      ? _wrongAnswerVideoUrl
      : _signList[_currentSignIndex].videoUrl;

  //Getter for retrieving the wrong answer info used in the getters above
  String get _wrongAnswerName => _signList[_wrongAnswers[0]].name;

  String get _wrongAnswerVideoUrl => _signList[_wrongAnswers[0]].videoUrl;

  String get chosenAnswer => _multipleChoiceOptions[_chosenAnswerIndex];

  List<String> get multipleChoiceOptions => _multipleChoiceOptions;

  get _signJson =>
      '[{"sign_name": "ACCEPTEREN-A", "video_url": "glossvideo/NGT/AC/ACCEPTEREN-A-51.mp4", "image_url": "glossimage/NGT/AC/ACCEPTEREN-A-51.png"},{"sign_name": "ACCEPTEREN-B","video_url": "glossvideo/NGT/AC/ACCEPTEREN-B-3277.mp4","image_url": "glossimage/NGT/AC/ACCEPTEREN-B-3277.png"},{"sign_name": "ACCEPTEREN-C","video_url": "glossvideo/NGT/AC/ACCEPTEREN-C-4160.mp4","image_url": "glossimage/NGT/AC/ACCEPTEREN-C-4160.png"},{"sign_name": "ACCEPTEREN-D", "video_url": "glossvideo/NGT/AC/ACCEPTEREN-A-51.mp4", "image_url": "glossimage/NGT/AC/ACCEPTEREN-A-51.png"}]';

  ///Setters
  set setChosenAnswerIndex(int index) => _chosenAnswerIndex = index;
}
