import 'package:flutter/material.dart';
import 'package:sign_app/controllers/home_page_controller.dart';
import 'package:sign_app/views/quiz_list_page.dart';
import 'package:sign_app/views/quiz_page.dart';
import 'package:sign_app/views/search_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'models/quiz_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum ListMenuItems { edit, delete }

class _HomePageState extends State<HomePage> {
  late HomePageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HomePageController(callback);
    _controller.getLastPracticedList();
    _controller.fetchListData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.sign_app),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _lastPracticedList(),
          ListTile(
            trailing: IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const QuizListView()));
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
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const QuizView())).then((value) => setState((){
                              if(value.type == QuizList){

                              }
                        }));
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
                              // TODO: Edit current list
                              break;
                            case ListMenuItems.delete:
                              // TODO: Create pop up that asks if the user is sure
                              _controller.deleteList(index);
                              break;
                          }
                        },
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => searchDialogBuilder(context),
        tooltip: AppLocalizations.of(context)!.search,
        child: const Icon(Icons.search),
      ),
    );
  }

  Widget _lastPracticedList() {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const QuizView()));
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

  void callback() => setState(() {});
}
