import 'dart:io';

import 'package:fc_native_video_thumbnail/fc_native_video_thumbnail.dart';
import 'package:flutter/rendering.dart';

class GenerateThumbnailsService {
  static Future<File?> generate(
      {required File file, int? width, int? height}) async {
    try {
      var plugin = FcNativeVideoThumbnail();

      String fileDest = file.path + "thumbnails.jpeg";

      await plugin.getVideoThumbnail(
          srcFile: file.path,
          destFile: fileDest,
          width: width ?? 300,
          height: height ?? 300,
          srcFileUri: false,
          format: "jpeg");

      if (File(fileDest).existsSync() == true) {
        final thumbnails = File(fileDest);
        var decodedImage =
            await decodeImageFromList(thumbnails.readAsBytesSync());
        print("Bien généré");
        return thumbnails;
      } else {
        print("Problème d'extration du thumbnails");
        return null;
      }
    } catch (e) {
      print("Une erreur est survenu ${e} ");
      return null;
    }
  }
}
