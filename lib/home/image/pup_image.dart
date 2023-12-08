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
          height: 800,
          width: 500,
        ),
      )
          .animate()
          .moveY()
          .fadeIn(duration: 200.ms)
          .then()
          .shake(hz: 3)
          .scaleXY(end: 1.2 / 1.5);
    },
  );
}
