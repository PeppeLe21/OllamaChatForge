import 'package:cached_network_image/cached_network_image.dart';
import 'package:com.example.app/src/constants/sizes.dart';
import 'package:flutter/cupertino.dart';

class TCircularImage extends StatelessWidget {
  const TCircularImage({
    super.key,
    this.width = 56,
    this.height = 56,
    this.overlayColor,
    this.backgroundColor,
    required this.image,
    this.fit = BoxFit.cover,
    this.padding =  textDefaultSize,
    this.isNetworkImage = false,
  });

  final BoxFit? fit;
  final String image;
  final bool isNetworkImage;
  final Color? overlayColor;
  final Color? backgroundColor;
  final double width, height, padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Center(
          child: isNetworkImage ? CachedNetworkImage(
            fit: fit,
            imageUrl: image,
            color: overlayColor,
          )
              : Image(
                  fit: fit,
                  image: AssetImage(image),
                  color: overlayColor,
          )
        ),
      ),
    );
  }
}