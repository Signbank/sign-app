import 'package:sign_app/controllers/base_controller.dart';

class HomePageController extends Controller{
 HomePageController(this._callback);

 final Function _callback;
 List<String> _lists = ['Country names'];


  void getLastPracticedList() {
   _callback();
  }

  void fetchListData() {}

 ///Getters
 String get lastPracticedListName => "Country names";
 double get lastPracticedListProgression => 0.8;

 int get listsLength => _lists.length;
 String listsTitle(int index) => _lists[index];
}