import 'package:application_amonak/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LoadImage extends StatefulWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  const LoadImage(
      {super.key, required this.imageUrl, this.width, this.height, this.fit});

  @override
  State<LoadImage> createState() => _LoadImageState();
}

class _LoadImageState extends State<LoadImage> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          if (isLoading)
            // Shimmer.fromColors(
            //   baseColor: Colors.grey[300]!,
            //   highlightColor: Colors.grey[100]!,
            //   enabled: true,
            //   child: Container(
            //     width: widget.width,
            //     height: widget.height,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //   ),
            // ),
            Skeleton.replace(
              child: Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(widget.imageUrl!),
                    fit: widget.fit ?? BoxFit.contain,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
