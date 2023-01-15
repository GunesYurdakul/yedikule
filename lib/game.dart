import 'package:flutter/material.dart';
import 'package:yedikule/question.dart';
import 'package:yedikule/scratcher_game.dart';

class GameSettings {
  List<GameStep> steps;
  String name;
  GameSettings(
    this.name,
    this.steps,
  );
}

class GameStep {
  QuestionAnswer? question;
  List<String>? imagePaths;
  GameStep({
    this.imagePaths,
    this.question,
  });
}

class Game extends StatefulWidget {
  final GameSettings settings;
  final Function onCompleted;

  const Game({
    super.key,
    required this.settings,
    required this.onCompleted,
  });

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  int step = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.settings.name,
        ),
      ),
      backgroundColor: Colors.lime,
      body: step == widget.settings.steps.length
          ? Container(
              color: Colors.lime,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.sentiment_very_satisfied_rounded,
                    size: 90,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Congratulations!\n You have unlocked all images!",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      textStyle: MaterialStateProperty.all(
                        const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    child:
                        const Text("Go back to map and explore other towers!"),
                    onPressed: () {
                      widget.onCompleted();
                    },
                  ),
                ],
              ),
            )
          : widget.settings.steps[step].question != null
              ? QuestionAnswerWidget(
                  question: (widget.settings.steps[step].question)!,
                  onCorrectAnswer: () {
                    setState(() {
                      step += 1;
                    });
                  },
                )
              : ScratcherGame(
                  onCompleted: () {
                    setState(() {
                      step += 1;
                    });
                  },
                  imagePaths: widget.settings.steps[step].imagePaths!,
                ),
    );
  }
}
