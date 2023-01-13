import 'package:flutter/material.dart';
import 'package:yedikule/question.dart';
import 'package:yedikule/scratcher_game.dart';

class GameSettings {
  List<QuestionAnswer> questions;
  List<String> imagePaths;
  GameSettings(
    this.questions,
    this.imagePaths,
  );
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
    if (step == 0)
      return QuestionAnswerWidget(
        questions: widget.settings.questions,
        onCorrectAnswer: () {
          setState(() {
            step = 1;
          });
        },
      );
    return ScratcherGame(onCompleted: widget.onCompleted, settings: widget.settings);
  }
}
