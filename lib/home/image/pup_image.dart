import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

Future<dynamic> pupImage(
    BuildContext context, List<String> imageAssetsList, int index) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            image: DecorationImage(
              image: AssetImage(imageAssetsList[index].toString()),
              fit: BoxFit.cover,
            ),
          ),
          height: 700,
          width: 500,
        ),
      )
          .animate()
          .moveY()
          .fadeIn(duration: 300.ms)
          .shake(hz: 3, rotation: 0.05, duration: 300.ms)
          .then()
          .scaleXY(end: 1.2 / 1.1);
    },
  );
}
