
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/images.dart';

class AlertImageDialog extends StatefulWidget {
  const AlertImageDialog({Key key}) : super(key: key);

  @override
  State<AlertImageDialog> createState() => _AlertImageDialogState();
}

class _AlertImageDialogState extends State<AlertImageDialog> {
  @override
  Widget build(BuildContext context) {

    final images = Provider.of<ImagesProvider>(context);

    return AlertDialog(
      title: const Text('AlertDialog Title'),
      content:  SizedBox(
        height: 175,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 60),
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          children: List.generate(images.images.length, (index) {
            Asset asset = images.images[index];
            return Padding(
              padding: const EdgeInsets.all(5),
              child: Stack(
                children: <Widget>[
                  AssetThumb(
                    asset: asset,
                    width: 300,
                    height: 300,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        images.images.removeAt(index);
                      });
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(90),
                          color: Colors.white,
                        ),
                        child: const Icon(Icons.close,
                            color: Colors.black, size: 18)),
                  )
                ],
              ),
            );
          }),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Approve'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

