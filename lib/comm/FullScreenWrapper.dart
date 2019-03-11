import 'package:flutter/cupertino.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenWrapper extends StatelessWidget {
  const FullScreenWrapper(
      {
        this.loadingChild,
        this.backgroundDecoration,
        this.minScale,
        this.maxScale,
        this.initialScale,
        this.imageUrl,
        this.basePosition = Alignment.center});

  final Widget loadingChild;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final dynamic initialScale;
  final Alignment basePosition;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: PhotoView(
          imageProvider: NetworkImage(this.imageUrl),
          loadingChild: loadingChild,
          backgroundDecoration: backgroundDecoration,
          minScale: minScale,
          maxScale: maxScale,
          initialScale: initialScale,
          basePosition: basePosition,
        ));
  }
}