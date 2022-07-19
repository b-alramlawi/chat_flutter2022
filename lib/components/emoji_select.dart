import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/cupertino.dart';

class EmojiSelect extends StatefulWidget {
  const EmojiSelect({Key key}) : super(key: key);

  @override
  State<EmojiSelect> createState() => _EmojiSelectState();
}

class _EmojiSelectState extends State<EmojiSelect> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return EmojiPicker(
        rows: 4,
        columns: 7,
        onEmojiSelected: (emoji, category) {
          emoji;
          setState(() {
            _controller.text = _controller.text + emoji.emoji;
          });
        });
  }
}
