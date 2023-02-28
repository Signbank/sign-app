import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sign_app/controllers/quiz_list_controller.dart';

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
    _controller = QuizListController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.saveList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing
            ? AppLocalizations.of(context)!.edit
            : AppLocalizations.of(context)!.createList),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(8), child: _showListView())),
          ElevatedButton(
              onPressed: () {
                _controller.saveList();
                Navigator.pop(context, _controller.quizList);
              },
              child: Text('Save'))
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
