import 'package:sign_app/controllers/base_controller.dart';
import 'package:sign_app/models/user_quiz_list_data.dart';

class HomePageController extends Controller{
 HomePageController(this._callback);

 final Function _callback;
 List<UserQuizListData> _lists = List.empty(growable: true);


  void getLastPracticedList() {
   _callback();
  }

  void fetchListData() {}

 void deleteList(int index) {
   _lists.removeAt(index);
   _callback();
 }

 ///Getters
 String get lastPracticedListName => "Country names";
 double get lastPracticedListProgression => 0.8;

 int get listsLength => _lists.length;
 String listsTitle(int index) => _lists[index].quizList.name;

}