
import 'package:flutter/material.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

import '../../model/message.dart';
import 'chat_image_view.dart';

class MessageBubble extends StatefulWidget {
  const MessageBubble({@required this.message});

  final MessageObject message;

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          widget.message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: widget.message.isMe
              ? const Color(0xFFd9b382)
              : const Color(0xFFFFFFFF),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: (widget.message.text.isNotEmpty)? Stack(
            children: [
              widget.message.isMe
                  ? Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 5,
                        bottom: 20,
                      ),
                      child: Text(
                        widget.message.text,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 50,
                        top: 5,
                        bottom: 10,
                      ),
                      child:
                          Text(
                              widget.message.text,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            )


                          /// image holder

                    ),
              widget.message.isMe
                  ? Positioned(
                      bottom: 4,
                      right: 10,
                      child: Row(
                        children: [
                          Text(
                            widget.message.time,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(
                            Icons.done,
                            size: 15,
                          ),
                        ],
                      ),
                    )
                  : Positioned(
                      bottom: 4,
                      right: 10,
                      child: Text(
                        widget.message.time,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
            ],
          ):getImageList(),
        ),
      ),
    );
  }

  /// load image list
  Widget getImageList() {
    if (widget.message.imagesList == null ||
        widget.message.imagesList.isEmpty) {
      return Container();
    } else {
      return Padding(
        padding: const EdgeInsets.all(7.0),
        child: Column(
          children: [
            Directionality(
              textDirection:
              widget.message.isMe ? TextDirection.rtl : TextDirection.ltr,
              child: GridView.count(
                crossAxisCount: 1,
                controller: ScrollController(keepScrollOffset: false),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children:
                List.generate(widget.message.imagesList.length, (index) {
                  String image = widget.message.imagesList[index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 3, bottom: 3),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImageProductView(
                                  onlineImage: image,
                                )));
                      },
                      child: OptimizedCacheImage(
                        imageUrl: image,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error_outline),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    }
  }
}
