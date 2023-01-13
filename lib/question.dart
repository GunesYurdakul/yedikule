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
  final List<QuestionAnswer> questions;
  final Function onCorrectAnswer;
  const QuestionAnswerWidget({
    super.key,
    required this.onCorrectAnswer,
    required this.questions,
  });

  @override
  State<QuestionAnswerWidget> createState() => _QuestionAnswerWidgetState();
}

class _QuestionAnswerWidgetState extends State<QuestionAnswerWidget> {
  bool? isCorrectAnswerFound;
  int questionIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.amberAccent,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
                Container(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Text(widget.questions[questionIdx].question),
                    ),
                  ),
                )
              ] +
              widget.questions[questionIdx].options
                  .mapIndexed(
                    (idx, option) => Container(
                      child: Card(
                        color: (widget.questions[questionIdx].answerIdx == idx && isCorrectAnswerFound == true) ? Colors.green : (isCorrectAnswerFound == false ? Colors.red : Colors.white),
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                if (widget.questions[questionIdx].answerIdx == idx) {
                                  if ((questionIdx + 1) == widget.questions.length) {
                                    isCorrectAnswerFound = true;
                                  } else {
                                    questionIdx += 1;
                                  }
                                }
                              });
                            },
                            child: Text(
                              option,
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
                      padding: EdgeInsets.all(20),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all(Colors.black),
                          backgroundColor: MaterialStateProperty.all(Colors.white),
                        ),
                        child: const Text("Next"),
                        onPressed: () {
                          widget.onCorrectAnswer();
                        },
                      ))
              ],
        ),
      ),
    );
  }
}
