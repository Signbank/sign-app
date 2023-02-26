import 'package:flutter/material.dart';
import 'package:sign_app/views/quiz_page.dart';
import 'package:sign_app/views/search_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.sign_app),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: (){
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const QuizView()));
            },
            child: const Card(
              child: Text('Starting learning'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => searchDialogBuilder(context),
        tooltip: AppLocalizations.of(context)!.search,
        child: const Icon(Icons.search),
      ),
    );
  }
}
