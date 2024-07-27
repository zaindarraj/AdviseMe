import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  String? url;
  File? file;
  ImagePreview({super.key, this.url, this.file}) {
    if (url == null && file == null) {
      throw Exception("Neither a url or a file were supplied");
    }
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
        child: file == null
            ? CachedNetworkImage(
                imageUrl: url!,
                progressIndicatorBuilder: (context, url, progress) {
                  return const Center(
                    child: LinearProgressIndicator(),
                  );
                },
              )
            : Image.file(file!));
  }
}
