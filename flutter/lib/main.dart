import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sign_app/red_impact_color.dart';
import 'package:sign_app/sign_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign App',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSwatch(primarySwatch: CustomColor.redImpactToLight),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            )),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                )),
          )
        )
      ),
      darkTheme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSwatch(
              primarySwatch: CustomColor.redImpactToDark)),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
        Locale('nl', ''), // Dutch, no country code
      ],
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.sign_app),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _searchDialogBuilder(context),
        tooltip: AppLocalizations.of(context)!.search,
        child: const Icon(Icons.search),
      ),
    );
  }

  Future<void> _searchDialogBuilder(BuildContext context) {
    var search = '';
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32))),
          title: Text(AppLocalizations.of(context)!.search),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  search = value;
                },
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32))),
                  hintText: AppLocalizations.of(context)!.searchByWord,
                ),
              ),
              const Padding(padding: EdgeInsets.all(8)),
              SizedBox(
                height: 60,
                width: 400,
                child: ElevatedButton(
                    onPressed: () {},
                    child: Text(AppLocalizations.of(context)!.searchByGesture)),
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text(AppLocalizations.of(context)!.search),
              onPressed: () {
                // Close alert dialog before going to the search list
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => SearchSignList(search: search)),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
