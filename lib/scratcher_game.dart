import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:scratcher/scratcher.dart';
import 'package:yedikule/game.dart';

// https://drive.google.com/drive/folders/1nv3ii5-rFgfLVdgegULyPAxgUDag1Xsr?usp=share_link
class ScratcherGame extends StatefulWidget {
  final GameSettings settings;
  final Function onCompleted;
  const ScratcherGame(
      {super.key, required this.onCompleted, required this.settings});

  @override
  State<ScratcherGame> createState() => _ScratcherGameState();
}

class _ScratcherGameState extends State<ScratcherGame>
    with SingleTickerProviderStateMixin {
  AudioPlayer? player;

  @override
  void initState() {
    super.initState();
  }

  bool hasWon = false;
  bool? isdoneVisible;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Scratcher(
            brushSize: 30,
            threshold: 90,
            color: Colors.red,
            onChange: (value) => print("Scratch progress: $value%"),
            onThreshold: () async {
              setState(() {
                hasWon = true;
/*              // Play without waiting for completion
                AudioCache player = AudioCache();
                const alarmAudioPath = "check.mp3";
                player.load(alarmAudioPath); */

                Future.delayed(Duration(seconds: 1))
                    .then((value) => setState((() {
                          isdoneVisible = true;
                          var data = player!.setAsset('assets/mb3.mp3').then(
                              (value) =>
                                  player?.playerStateStream.listen((event) {}));
                        })));
                Future.delayed(Duration(seconds: 2))
                    .then((value) => setState(() {
                          isdoneVisible = false;
                        }));
              });
            },
            image: Image.asset(widget.settings.imagePaths.last),
            child: Image.asset(widget.settings.imagePaths.first),
          ),
        ),
        Visibility(
          visible: hasWon,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
                // If the widget is visible, animate to 0.0 (invisible).
                // If the widget is hidden, animate to 1.0 (fully visible).
                opacity: isdoneVisible == true ? 1.0 : 0.0,
                duration: const Duration(seconds: 1),
                child: Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "lib/assets/done.png",
                    width: MediaQuery.of(context).size.width * 0.75,
                  ),
                ),
              ),
              if (isdoneVisible == false)
                ElevatedButton(
                  onPressed: () {
                    widget.onCompleted();
                  },
                  child: const Text(
                    "Go back to map and explore other towers!",
                  ),
                )
            ],
          ),
        )
      ],
    );
  }
}
