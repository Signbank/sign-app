import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sign_app/views/search_property_list.dart';
import 'package:sign_app/views/sign_list.dart';

Future<dynamic> searchDialogBuilder(BuildContext context, {var isAddingSign}) {
  var searchInput = '';
  return showDialog<dynamic>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32))),
        title: Text(AppLocalizations.of(context)!.search),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 60,
              width: 400,
              child: ElevatedButton(
                  onPressed: () {
                    // Close alert dialog before going to the search list
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const SearchPropertyListView()));
                  },
                  child: Text(AppLocalizations.of(context)!.searchByGesture)),
            ),
            const Padding(padding: EdgeInsets.all(8)),
            TextField(
              onChanged: (value) {
                searchInput = value;
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32))),
                hintText: AppLocalizations.of(context)!.searchByWord,
              ),
            ),
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
                    builder: (context) => SearchSignListView(searchTerm: searchInput, isAddingSign: isAddingSign,)),
              );
            },
          ),
        ],
      );
    },
  );
}
