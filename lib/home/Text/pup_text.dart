// ignore_for_file: file_names

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

Future<dynamic> pupText(
    BuildContext context, String fileNameWithoutExtension, controller) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: ConfettiWidget(
          confettiController: controller,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Center(
                  child: Text(
                fileNameWithoutExtension,
                style: const TextStyle(
                  fontSize: 55,
                  fontFamily: 'SignikaNegative',
                  fontStyle: FontStyle.italic,
                  color: Color.fromARGB(255, 241, 236, 236),
                ),
              )),
              ConfettiWidget(
                confettiController: controller,
                shouldLoop: true,
                blastDirectionality: BlastDirectionality.explosive,
              )
            ],
          ),
        ),
      )
          .animate()
          .moveY()
          .scaleXY(begin: 1, end: 1.1, duration: 250.ms)
          .then()
          .shake(hz: 2, rotation: 0.02, duration: 500.ms)
          .scaleXY(end: 1.1);
    },
  );
}
