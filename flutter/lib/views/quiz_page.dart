import 'package:flutter/material.dart';
import 'package:sign_app/controllers/quiz_controller.dart';
import 'package:sign_app/red_impact_color.dart';
import 'package:sign_app/url_config.dart';
import 'package:sign_app/views/video_player.dart';

class QuizView extends StatefulWidget {
  const QuizView({super.key});

  @override
  State<StatefulWidget> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  late final QuizController _controller;
  late final Future _dataFuture;
  bool _isAnswerChecked = false;

  @override
  void initState() {
    super.initState();
    _controller = QuizController(callback);
    _dataFuture = _controller.fetchQuiz();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz list name"),
      ),
      body: FutureBuilder<void>(
        future: _dataFuture,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            VideoPlayerView(
                key: ValueKey<String>(_controller.signVideoUrl),
                url: signBankBaseMediaUrl + _controller.signVideoUrl),
            _multipleChoiceList(),
            AnimatedCrossFade(
              crossFadeState: _isAnswerChecked
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 500),
              firstChild: Padding(
                padding: const EdgeInsets.all(8),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _controller.checkAnswer();
                          _isAnswerChecked = true;
                        });
                      },
                      child: const Text("Check answer")),
                ),
              ),
              secondChild: Padding(
                padding: const EdgeInsets.all(8),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isAnswerChecked = false;
                          _controller.nextSign(context);
                        });
                      },
                      child: const Text("Next sign")),
                ),
              ),
            ),
          ]);
        },
      ),
    );
  }

  Widget _multipleChoiceList() {
    return Expanded(
      child: ListView.builder(
          itemCount: _controller.multipleChoiceOptions.length,
          itemBuilder: (context, index) {
            var backgroundColor = _setMultipleChoiceBackgroundColor(index);
            return Card(
              color: backgroundColor,
              child: RadioListTile(
                activeColor: _isAnswerChecked ? Colors.white : Colors.blue,
                value: _controller.multipleChoiceOptions[index],
                groupValue: _controller.chosenAnswer,
                onChanged: (newValue) {
                  if (!_isAnswerChecked) {
                    setState(() {
                      _controller.setChosenAnswerIndex = index;
                    });
                  }
                },
                title: Center(
                    child: Text(
                  _controller.multipleChoiceOptions[index],
                  style: TextStyle(
                      color: backgroundColor == Colors.green ? Colors.white : Colors.black),
                )),
              ),
            );
          }),
    );
  }

  Color _setMultipleChoiceBackgroundColor(int index) {
    if (_isAnswerChecked) {
      if (_controller.multipleChoiceOptions[index] == _controller.signName) {
        return Colors.green;
      }

      if (_controller.multipleChoiceOptions[index] ==
          _controller.chosenAnswer) {
        return CustomColor.redImpactToLight;
      }
    }

    return Colors.white;
  }

  void callback() => setState(() {});
}
