import 'package:flutter/material.dart';
import 'package:sign_app/view/search_dialog.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => searchDialogBuilder(context),
        tooltip: AppLocalizations.of(context)!.search,
        child: const Icon(Icons.search),
      ),
    );
  }
}
