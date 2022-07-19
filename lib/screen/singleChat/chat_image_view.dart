import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageProductView extends StatefulWidget {
  const ImageProductView({
    this.onlineImage = '',
  });

  final String onlineImage;

  @override
  _ImageProductViewState createState() => _ImageProductViewState();
}

class _ImageProductViewState extends State<ImageProductView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            PhotoView(
              imageProvider: NetworkImage(widget.onlineImage),
            ),
            Positioned(
              top: 10.0,
              child: IconButton(
                color: Colors.white,
                iconSize: 50,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(70),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
