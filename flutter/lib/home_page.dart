import 'package:flutter/material.dart';
import 'package:sign_app/controllers/home_page_controller.dart';
import 'package:sign_app/models/user_quiz_list_data.dart';
import 'package:sign_app/token_helper.dart';
import 'package:sign_app/views/login.dart';
import 'package:sign_app/views/quiz_list_page.dart';
import 'package:sign_app/views/quiz_page.dart';
import 'package:sign_app/views/register.dart';
import 'package:sign_app/views/search_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum ListMenuItems { edit, delete }

class _HomePageState extends State<HomePage> {
  late HomePageController _controller;
  late Future<Widget> _setupBodyFuture;

  @override
  void initState() {
    super.initState();
    _controller = HomePageController(callback);
    _setupBodyFuture = _setUpBody();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.sign_app),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                    builder: (context) => const LoginPage()))
                    .then((value) => setState(() {
                  _setupBodyFuture = _setUpBody();
                }));
              },
              icon: const Icon(Icons.person)),
        ],
      ),
      body: FutureBuilder(
        future: _setupBodyFuture,
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          if(snapshot.connectionState != ConnectionState.done){
            return const Center(child: CircularProgressIndicator(),);
          }

            Widget? widgetBody = snapshot.data;
            if(widgetBody == null){
              throw Exception("Something went wrong!");
            }

          return widgetBody;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => searchDialogBuilder(context),
        tooltip: AppLocalizations.of(context)!.search,
        child: const Icon(Icons.search),
      ),
    );
  }

  Future<Widget> _setUpBody() async {
    String token = await TokenHelper().getToken();

    if(token.isEmpty){
      return _loginBody();
    }

    await _controller.fetchListData();

    return _listBody();
  }

  Widget _lastPracticedList() {
    if (_controller.lastPracticedListData.id == 0) {
      return Column(
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                    builder: (context) => const LoginPage()))
                    .then((value) => setState(() {
                  // _tokenFuture = TokenHelper().getToken();
                }));
              },
              child: Text(
                AppLocalizations.of(context)!.login,
              )),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _controller.fetchListData();
            },
          ),
        ],
      );
    }
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => QuizView(
                      userQuizListData: _controller.lastPracticedListData,
                    )))
            .then((value) => setState(() {
                  _controller.setMostRecentQuiz();
                }));
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 6,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.pickUpWhereYouLeftOf,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _controller.lastPracticedListName,
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 20,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          child: LinearProgressIndicator(
                            value: _controller.lastPracticedListProgression,
                            semanticsLabel: 'Progress in list',
                            backgroundColor: Colors.grey,
                          ),
                        ),
                      ),
                      Text(
                        '${(_controller.lastPracticedListProgression * 100).round()}%',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginBody() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                AppLocalizations.of(context)!.loginHomepageText,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              )),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => const LoginPage()))
                    .then((value) => setState(() {
                          _setupBodyFuture = _setUpBody();
                        }));
              },
              child: Text(
                AppLocalizations.of(context)!.login,
              )),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const RegisterPage())).then((value){
                   _setupBodyFuture = _setUpBody();
              });
            },
            child: Text(AppLocalizations.of(context)!.createAnAccount),
          ),
        ],
      ),
    );
  }

  Widget _listBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _lastPracticedList(),
        ListTile(
          trailing: IconButton(
              onPressed: () async {
                UserQuizListData? userListData = await Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => const QuizListView()));

                if (userListData != null) {
                  _controller.addList(userListData);
                }
              },
              icon: const Icon(Icons.add)),
          title: Text(
            AppLocalizations.of(context)!.lists,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: const Divider(),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: _controller.listsLength,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => QuizView(
                                    userQuizListData:
                                        _controller.getUserQuizListData(index),
                                  )))
                          .then((value) => setState(() {}));
                    },
                    title: Text(_controller.listsTitle(index)),
                    trailing: PopupMenuButton<ListMenuItems>(
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<ListMenuItems>>[
                        PopupMenuItem<ListMenuItems>(
                          value: ListMenuItems.edit,
                          child: Text(
                            AppLocalizations.of(context)!.edit,
                          ),
                        ),
                        PopupMenuItem<ListMenuItems>(
                          value: ListMenuItems.delete,
                          child: Text(
                            AppLocalizations.of(context)!.delete,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                      onSelected: (ListMenuItems item) {
                        switch (item) {
                          case ListMenuItems.edit:
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => QuizListView(
                                      quizList: _controller
                                          .getUserQuizListData(index),
                                      isEditing: true,
                                    )));
                            break;
                          case ListMenuItems.delete:
                            _controller.deleteList(index);
                            _controller.getLastPracticedList();
                            break;
                        }
                      },
                    ),
                  ),
                );
              }),
        )
      ],
    );
  }

  void callback() => setState(() {});
}
