import 'dart:io';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import "package:fingerprint/main.dart";

import 'package:fingerprint/constants.dart';

Image overlay = Image.asset("assets/fingerprint_overlay_2.png");


class CameraPage extends StatefulWidget {
  const CameraPage({
    super.key,
    required this.title,
    this.leftSide = true,
  });

  final String title;
  final bool leftSide;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with TickerProviderStateMixin{
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late FlashMode flashMode;
  late bool showFlashMode = false;
  late int flashIndex = 0;

  AnimationController? animationController;
  List animation = [];
  List icons = [Icons.flash_auto, Icons.flash_off, Icons.flash_on];
  OverlayEntry? overlayEntry;
  GlobalKey globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      cameras.first,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    flashMode = FlashMode.off;

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();

    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    for (int i = 3; i > 0; i--) {
      animation.add(Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: animationController!,
          curve: Interval(0.2 * i, 1.0, curve: Curves.ease))));
    }
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    overlayEntry!.remove();
    _controller.dispose();
    super.dispose();
  }

  _showOverLay() async {
    RenderBox? renderBox =
        globalKey.currentContext!.findRenderObject() as RenderBox?;
    Offset offset = renderBox!.localToGlobal(Offset.zero);

    OverlayState? overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        bottom: renderBox.size.height + 16,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < animation.length; i++)
              ScaleTransition(
                scale: animation[i],
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      flashMode = FlashMode.values[i];
                      flashIndex = i;
                      _controller.setFlashMode(flashMode);
                    });
                    // Fluttertoast.showToast(msg: 'Icon Button Pressed');
                  },
                  child: Icon(
                    icons[i],
                  ),
                  backgroundColor: MyColors.lakeLaselle,
                  mini: true,
                ),
              )
          ],
        ),
      ),
    );
    animationController!.addListener(() {
      overlayState!.setState(() {});
    });
    animationController!.forward();
    overlayState!.insert(overlayEntry!);

    await Future.delayed(const Duration(seconds: 5))
        .whenComplete(() => animationController!.reverse())
        .whenComplete(() => overlayEntry!.remove());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return Stack(
              alignment: FractionalOffset.center,
              children: <Widget>[
                CameraPreview(_controller),
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.3,
                    child : widget.leftSide ? overlay : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(math.pi),
                      child: overlay
                    ),
                  ),
                ),
              ],
            );
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          FloatingActionButton(
            // Provide an onPressed callback.
            onPressed: () async {
              // Take the Picture in a try / catch block. If anything goes wrong,
              // catch the error.
              try {
                // Ensure that the camera is initialized.
                await _initializeControllerFuture;

                // Attempt to take a picture and get the file `image`
                // where it was saved.
                final image = await _controller.takePicture();

                if (!context.mounted) return;

                // If the picture was taken, display it on a new screen.
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DisplayPictureScreen(
                      // Pass the automatically generated path to
                      // the DisplayPictureScreen widget.
                      imagePath: image.path,
                      leftSide: widget.leftSide,
                    ),
                  ),
                );
              } catch (e) {
                // If an error occurs, log the error to the console.
                print(e);
              }
            },
            child: const Icon(Icons.camera_alt),
          ),
          FloatingActionButton(
            key: globalKey,
            shape: const CircleBorder(),
            onPressed: () {
              _showOverLay();
            },
            child: Icon(icons[flashIndex])//const Icon(Icons.flash_off_outlined),
            /*switch (flashMode) {
              case FlashMode.off:
                const Icon(Icons.flash_off_outlined);
                break;
              case FlashMode.always:
                const Icon(Icons.flash_on_outlined);
                break;
            }, */
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  const DisplayPictureScreen({
    super.key,
    required this.imagePath,
    required this.leftSide,
  });

  final String imagePath;
  final bool leftSide;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fingerprint Scan')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Stack(
        children: <Widget>[
          Image.file(File(imagePath)),
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Builder(
                builder: (context) {
                  if (leftSide) {
                    return overlay;
                  } else {
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(math.pi),
                      child: overlay
                    );
                  }
                }
              ),
            ),
          ),
        ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
          Navigator.pop(context, imagePath);
        },
        child: const Icon(Icons.check),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

