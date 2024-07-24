import 'dart:io';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import "package:fingerprint/main.dart";
import 'package:image/image.dart' as img;
import 'package:exif/exif.dart';

import 'package:fingerprint/constants.dart';

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
  late int flashIndex = 0;

  List icons = [Icons.flash_auto, Icons.flash_off, Icons.flash_on];

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      cameras.first,
      // Define the resolution to use.
      ResolutionPreset.max,
    );

    flashMode = FlashMode.off;

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: false,
      ),
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
            heroTag: "tag1",
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
                final imageBytes = await image.readAsBytes();
                final exifData = await readExifFromBytes(imageBytes);
                final orientation = exifData!['Image Orientation']?.values?.first ?? 1;

                // Decode the image
                final decodedImage = img.decodeImage(imageBytes);

                // Correct the orientation
                // img.Image orientedImage;
                // switch (orientation) {
                //   case 3:
                //     orientedImage = img.copyRotate(decodedImage!, 180);
                //     break;
                //   case 6:
                //     orientedImage = img.copyRotate(decodedImage!, 90);
                //     break;
                //   case 8:
                //     orientedImage = img.copyRotate(decodedImage!, -90);
                //     break;
                //   default:
                //     orientedImage = decodedImage!;
                // }

                // Save the corrected image to a file
                final pngImage = img.encodePng(decodedImage!);//orientedImage);
                final file = File('${image.path}.png');
                await file.writeAsBytes(pngImage);

                if (!context.mounted) return;

                // If the picture was taken, display it on a new screen.
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DisplayPictureScreen(
                      // Pass the automatically generated path to
                      // the DisplayPictureScreen widget.
                      imagePath: file.path,
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
            heroTag: "tag2",
            shape: const CircleBorder(),
            onPressed: () {
              setState(() {
                flashIndex = (flashIndex + 1) % 3;
                switch (flashIndex) {
                  case 0:
                    flashMode = FlashMode.auto;
                    break;
                  case 1:
                    flashMode = FlashMode.off;
                    break;
                  case 2:
                    flashMode = FlashMode.always;
                    break;
                }
                _controller.setFlashMode(flashMode);
              });
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

