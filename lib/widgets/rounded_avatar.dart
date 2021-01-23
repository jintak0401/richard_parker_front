import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:richard_parker/constants/common_size.dart';

class RoundedAvatar extends StatelessWidget {
  final double size;
  final String imageUrl;

  const RoundedAvatar({Key key, this.size = avatar_size, this.imageUrl = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl.length > 0) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: size,
          height: size,
        ),
      );
    } else {
      return Icon(Icons.account_circle_sharp, size: size);
    }
  }
}
