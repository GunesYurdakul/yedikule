import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class QuestionAnswer {
  String question;
  List<String> options;
  int answerIdx;
  QuestionAnswer(
    this.question,
    this.options,
    this.answerIdx,
  );
}

class QuestionAnswerWidget extends StatefulWidget {
  final QuestionAnswer question;
  final Function onCorrectAnswer;
  const QuestionAnswerWidget({
    super.key,
    required this.onCorrectAnswer,
    required this.question,
  });

  @override
  State<QuestionAnswerWidget> createState() => _QuestionAnswerWidgetState();
}

class _QuestionAnswerWidgetState extends State<QuestionAnswerWidget> {
  bool? isCorrectAnswerFound;
  int questionIdx = 0;
  int? selectedIdx;
  @override
  void didUpdateWidget(covariant QuestionAnswerWidget oldWidget) {
    selectedIdx = null;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.lime,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: Card(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          widget.question.question,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ] +
              widget.question.options
                  .mapIndexed(
                    (idx, option) => Container(
                      child: Card(
                        color: (widget.question.answerIdx == idx &&
                                isCorrectAnswerFound == true)
                            ? Colors.green
                            : (isCorrectAnswerFound == false &&
                                    selectedIdx == idx
                                ? Colors.red
                                : Colors.white),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedIdx = idx;
                              isCorrectAnswerFound =
                                  widget.question.answerIdx == idx;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              option,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList() +
              [
                if (isCorrectAnswerFound == true)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.black),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                      child: const Text(
                        "Next",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () {
                        widget.onCorrectAnswer();
                      },
                    ),
                  )
              ],
        ),
      ),
    );
  }
}
