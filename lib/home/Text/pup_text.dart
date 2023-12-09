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
          .fadeIn(duration: 300.ms)
          .then()
          .shimmer(
              duration: const Duration(milliseconds: 800),
              delay: 400.ms,
              color: const Color.fromARGB(255, 59, 226, 255),
              size: 25)
          .shake(hz: 3)
          .scaleXY(end: 1.1);
    },
  );
}
