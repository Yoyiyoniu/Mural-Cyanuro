import 'dart:math';
import 'dart:ui';
import 'package:confetti/confetti.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mural_cyanurito/home/Text/pup_text.dart';
import 'package:mural_cyanurito/home/image/pup_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(130, 184, 228, 1),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          if (_isAppBarVisible)
            SliverAppBar(
              expandedHeight: 100.0,
              pinned: true,
              floating: true,
              snap: true,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.keyboard_double_arrow_up_sharp,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _isAppBarVisible = !_isAppBarVisible;
                    });
                  },
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Image.asset(
                  'assets/title/cyanuritoletra.png',
                  fit: BoxFit.cover,
                  height: 60,
                  alignment: Alignment.center,
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          const SliverFillRemaining(
            child: ImageGrid(),
          ),
        ],
      ),
      floatingActionButton: !_isAppBarVisible
          ? FloatingActionButton(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: const Icon(
                Icons.keyboard_double_arrow_down_sharp,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _isAppBarVisible = !_isAppBarVisible;
                });
              },
            )
          : null,
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
  bool isPlaying = false;
  final controller = ConfettiController();
  List<String> imageAssetsList = [];

  @override
  void initState() {
    super.initState();
    loadImages();
    setState(() {
      isPlaying = controller.state == ConfettiControllerState.playing;
    });
  }

  Future<void> loadImages() async {
    final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final assets = assetManifest
        .listAssets()
        .where((string) => string.startsWith("assets/images/"))
        .toList();
    assets.shuffle();
    setState(() {
      imageAssetsList = assets;
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double imageBlur = 20;
    double textBlur = 5;

    return imageAssetsList.isEmpty
        ? const Center(
            child: CircularProgressIndicator(
              semanticsLabel: 'Cargando imágenes',
            ),
          )
        : GridView.builder(
            key: const PageStorageKey<String>('page'),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 30.0,
            ),
            itemCount: imageAssetsList.length,
            itemBuilder: (context, index) {
              String fileName = imageAssetsList[index].split('/').last;
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
                        if (!deblurredImageSet.contains(uniqueId)) {
                          deblurredImageSet.add(uniqueId);
                        }
                      });
                      pupImage(context, imageAssetsList, index);
                    },
                    child: ImageFiltered(
                      imageFilter: deblurredImageSet.contains(uniqueId)
                          ? ImageFilter.blur(sigmaX: 0, sigmaY: 0)
                          : ImageFilter.blur(
                              sigmaX: imageBlur, sigmaY: imageBlur),
                      child: Container(
                        height: 320.0,
                        width: 280.0,
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
                  ImageFiltered(
                    imageFilter: deblurredTextSet.contains(textUniqueId)
                        ? ImageFilter.blur(sigmaX: 0, sigmaY: 0)
                        : ImageFilter.blur(sigmaX: textBlur, sigmaY: textBlur),
                    child: RichText(
                      text: TextSpan(
                        text: fileNameWithoutExtension,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: 'Pacifico-Regular',
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Future.delayed(
                              const Duration(milliseconds: 500),
                              () {
                                if (isPlaying) {
                                  controller.stop();
                                } else {
                                  controller.play();
                                }
                                setState(() {
                                  controller.play();
                                  if (!deblurredTextSet
                                      .contains(textUniqueId)) {
                                    deblurredTextSet.add(textUniqueId);
                                  }
                                });
                                pupText(context, fileNameWithoutExtension,
                                    controller);
                              },
                            );
                            debugPrint('Tapped on $textUniqueId');
                          },
                      ),
                    ),
                  ),
                ],
              );
            },
          );
  }
}
