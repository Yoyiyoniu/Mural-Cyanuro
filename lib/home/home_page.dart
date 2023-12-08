import 'dart:math';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:mural_cyanurito/home/Text/Pup_Text.dart';
import 'package:mural_cyanurito/home/image/pup_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(130, 184, 228, 1),
      appBar: AppBar(
        toolbarHeight: 91,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Image.asset(
          'assets/title/cyanuritoletra.png',
          fit: BoxFit.cover,
          height: 100,
        ),
      ),
      body: const ImageGrid(),
    );
  }
}

class ImageGrid extends StatefulWidget {
  const ImageGrid({super.key});

  @override
  State<ImageGrid> createState() => _ImageGridState();
}

class _ImageGridState extends State<ImageGrid> {
  Set<String> deblurredImageSet = <String>{};
  Set<String> deblurredTextSet = <String>{};

  @override
  void initState() {
    super.initState();
  }

  Future<List<String>> loadImageAssetsList() async {
    final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    return assetManifest
        .listAssets()
        .where((string) => string.startsWith("assets/test-images/"))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    double blur = 15;
    double textBlur = 3;
    return FutureBuilder<List<String>>(
      future: loadImageAssetsList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final imageAssetsList = snapshot.data;

          return GridView.builder(
            key: const PageStorageKey<String>('page'),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 30.0,
            ),
            itemCount: imageAssetsList?.length,
            itemBuilder: (context, index) {
              String fileName = imageAssetsList![index].split('/').last;
              String fileNameWithoutExtension =
                  fileName.substring(0, fileName.length - 4);
              String uniqueId = 'id_$index';
              String textUniqueId = 'id_Text$index';

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      debugPrint('Tapped on $uniqueId');
                      setState(() {
                        // Toggle selected image

                        if (!deblurredImageSet.contains(uniqueId)) {
                          deblurredImageSet.add(uniqueId);
                        }
                      });
                      pupImage(context, imageAssetsList, index);
                    },

                    //? ------------------ Imagen ------------------

                    child: ImageFiltered(
                      imageFilter: deblurredImageSet.contains(uniqueId)
                          ? ImageFilter.blur(sigmaX: 0, sigmaY: 0)
                          : ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                      child: Container(
                        height: 320.0,
                        width: 270.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.primaries[
                              Random().nextInt(Colors.primaries.length)],
                          image: DecorationImage(
                            image: AssetImage(imageAssetsList[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  //? ------------------ Texto debajo de la imagen ------------------
                  ImageFiltered(
                    imageFilter: deblurredTextSet.contains(textUniqueId)
                        ? ImageFilter.blur(sigmaX: 0, sigmaY: 0)
                        : ImageFilter.blur(sigmaX: textBlur, sigmaY: textBlur),
                    child: RichText(
                      text: TextSpan(
                        text: fileNameWithoutExtension,
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'SignikaNegative',
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Future.delayed(const Duration(milliseconds: 500),
                                () {
                              setState(() {
                                // Toggle selected text
                                if (!deblurredTextSet.contains(textUniqueId)) {
                                  deblurredTextSet.add(textUniqueId);
                                }
                              });
                              pupText(context, fileNameWithoutExtension);
                            });

                            debugPrint('Tapped on $textUniqueId');
                          },
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error al cargar la lista de imágenes'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 500))
        .slideY(begin: -0.5, duration: const Duration(milliseconds: 400))
        .shimmer(duration: 500.ms);
  }
}
