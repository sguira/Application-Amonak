import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ViewImage extends StatefulWidget {
  final String imageUrl;
  final String heroTag;

  const ViewImage({super.key, required this.imageUrl, required this.heroTag});

  @override
  State<ViewImage> createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      alignment: Alignment.center,
      child: Stack(
        children: [
          PhotoView(
            imageProvider: NetworkImage(widget.imageUrl),
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.error,
                color: Colors.white,
                size: 50,
              );
            },
            loadingBuilder: (context, event) {
              if (event == null) return const SizedBox();
              return Center(
                child: CircularProgressIndicator(
                  value: event.expectedTotalBytes != null
                      ? event.cumulativeBytesLoaded / event.expectedTotalBytes!
                      : null,
                ),
              );
            },
          ),
          Positioned(
              child: IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 30),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
        ],
      ),
    );
  }
}
