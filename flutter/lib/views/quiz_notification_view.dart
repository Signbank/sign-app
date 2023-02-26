import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuizNotificationDialog extends StatelessWidget {
  const QuizNotificationDialog({super.key, required this.isDone});

  final bool isDone;

  @override
  Widget build(BuildContext context) {
    String title = isDone ? "Quiz completed" : "Learn from your mistakes";
    String text = isDone
        ? "Well done you completed the whole list!"
        : "Looks like you made a few mistakes.\nWould you like to go over them?";
    String buttonText = isDone ? "Go back home" : "Yes";
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.popUntil(
              context, ModalRoute.withName(Navigator.defaultRouteName)),
        ),
        title: Text(title),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Expanded(
            child: Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                    child: Text(
                  text,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                )))),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Visibility(
              visible: !isDone,
              child: Expanded(
                child: TextButton(
                  child: const Text("No"),
                  onPressed: () => Navigator.popUntil(
                      context, ModalRoute.withName(Navigator.defaultRouteName)),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                    onPressed: () {
                      if (isDone) {
                        Navigator.popUntil(context,
                            ModalRoute.withName(Navigator.defaultRouteName));
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(buttonText)),
              ),
            )
          ],
        )
      ]),
    );
  }
}
