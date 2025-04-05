import 'dart:convert';

import 'package:flutter_gradient_generator/models/abstract_gradient.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:flutter/material.dart';

//TODO: Give users options for image size and format

/// A wrapper class for downloading gradients.
class GradientDownloader {
  final ScreenshotController screenshotController = ScreenshotController();
  final double imageWidth = 1600.0;
  final double imageHeight = 1600.0;

  /// Downloads the [gradient] as an image
  Future<void> downloadGradientAsImage(AbstractGradient gradient) async {
    const imageName = 'gradient.png';

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

  /// Returns the [gradient] as a data URL
  Future<String> getGradientDataUrl(AbstractGradient gradient) async {
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

    final base64String = base64Encode(imageBytes);

    return 'data:image/png;base64,$base64String';
  }
}
