import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sign_app/controllers/quiz_list_controller.dart';
import 'package:sign_app/views/search_dialog.dart';

class QuizListView extends StatefulWidget {
  const QuizListView({super.key});

  @override
  State createState() => _QuizListViewState();
}

class _QuizListViewState extends State<QuizListView> {
  final bool _isEditing = false;
  late QuizListController _controller;

  @override
  void initState() {
    super.initState();
    _controller = QuizListController(callback);
  }

  @override
  void dispose() {
    super.dispose();
    //Todo: should the app save a list when a user does not click save?
    // _controller.saveList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing
            ? AppLocalizations.of(context)!.edit
            : AppLocalizations.of(context)!.createQuiz),
        actions: [
          IconButton(
              onPressed: () {
                var userDataQuizList = _controller.saveList();
                Navigator.pop(context, userDataQuizList);
              },
              icon: const Icon(Icons.save))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (value) {
                _controller.setQuizListName = value;
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32))),
                labelText: AppLocalizations.of(context)!.enterAQuizName,
              ),
            ),
          ),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(8), child: _showListView())),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () => searchDialogBuilder(context, isAddingSign: _controller),
                  child: const Text('Add a sign')),
            ),
          )
        ],
      ),
    );
  }

  Widget _showListView() {
    return ListView.builder(
        itemCount: _controller.listsLength,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(_controller.listsTitle(index)),
              trailing: IconButton(
                onPressed: () {
                  _controller.removeSign(index);
                },
                icon: const Icon(Icons.delete),
              ),
            ),
          );
        });
  }

  void callback() => setState(() {});
}
