import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sign_app/View/sign_list.dart';
import 'package:sign_app/View/sign_property_list.dart';
import 'package:sign_app/View/test_anim_list.dart';

Future<void> searchDialogBuilder(BuildContext context) {
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
                  onPressed: () {
                    // Close alert dialog before going to the search list
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const TestAnimList()));
                  },
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
                    builder: (context) => SearchSignList(search: search, signIds: [],)),
              );
            },
          ),
        ],
      );
    },
  );
}
