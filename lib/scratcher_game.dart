import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:scratcher/scratcher.dart';
import 'package:yedikule/game.dart';

// https://drive.google.com/drive/folders/1nv3ii5-rFgfLVdgegULyPAxgUDag1Xsr?usp=share_link
class ScratcherGame extends StatefulWidget {
  final List<String> imagePaths;
  final Function onCompleted;
  const ScratcherGame(
      {super.key, required this.onCompleted, required this.imagePaths});

  @override
  State<ScratcherGame> createState() => _ScratcherGameState();
}

class _ScratcherGameState extends State<ScratcherGame>
    with SingleTickerProviderStateMixin {
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
            threshold: 60,
            onChange: (value) => print(
              "Scratch progress: $value%",
            ),
            onThreshold: () async {
              setState(
                () {
                  hasWon = true;
                  Future.delayed(const Duration(seconds: 1)).then(
                    (value) => setState(
                      (() {
                        isdoneVisible = true;
                        final assetsAudioPlayer = AssetsAudioPlayer();

                        assetsAudioPlayer.open(
                          Audio("lib/assets/check.mp3"),
                          volume: 1,
                        );
                        assetsAudioPlayer.play();
                      }),
                    ),
                  );
                  Future.delayed(const Duration(seconds: 2)).then(
                    (value) => setState(
                      () {
                        isdoneVisible = false;
                      },
                    ),
                  );
                },
              );
            },
            image: Image.asset(
              widget.imagePaths.last,
              width: MediaQuery.of(context).size.width,
            ),
            child: Image.asset(
              widget.imagePaths.first,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ),
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
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.black),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }
}
