import 'package:flutter_gradient_generator/models/abstract_gradient.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:flutter/material.dart';

//TODO: Give users optoons for image size and format

/// A wrapper class for downloading gradients.
class GradientDownloader {
  /// Downloads the [gradient] as an image
  Future<void> downloadGradientAsImage(AbstractGradient gradient) async {
    const imageName = 'gradient.png';
    const imageWidth = 1600.0;
    const imageHeight = 1200.0;

    final ScreenshotController screenshotController = ScreenshotController();
    final flutterGradient = gradient.toFlutterGradient();

    final imageBytes = await screenshotController.captureFromWidget(
      AspectRatio(
        aspectRatio: imageWidth / imageHeight,
        child: Container(
          decoration: BoxDecoration(
            gradient: flutterGradient,
          ),
          width: imageWidth,
        ),
      ),
    );

    await WebImageDownloader.downloadImageFromUInt8List(
      uInt8List: imageBytes,
      name: imageName,
    );
  }
}
