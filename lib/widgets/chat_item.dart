import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ChatItem extends StatefulWidget {
  final String text;
  final bool isMe;
 


  ChatItem({
    Key? key,
    required this.text,
    required this.isMe,
  }) : super(key: key);

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  final FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isSpeaking) {
          _stopSpeaking();
        } else {
          _speakText(widget.text);
        }
        setState(() {
          isSpeaking = !isSpeaking;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 12,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment:
              widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!widget.isMe) ProfileContainer(isMe: widget.isMe),
            if (!widget.isMe) const SizedBox(width: 15),
            Container(
              padding: const EdgeInsets.all(15),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.60,
              ),
              decoration: BoxDecoration(
                color: widget.isMe
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.grey.shade800,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(15),
                  topRight: const Radius.circular(15),
                  bottomLeft: Radius.circular(widget.isMe ? 15 : 0),
                  bottomRight: Radius.circular(widget.isMe ? 0 : 15),
                ),
              ),
              child: Text(
                widget.text,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ),
            if (widget.isMe) const SizedBox(width: 15),
            if (widget.isMe) ProfileContainer(isMe: widget.isMe),
          ],
        ),
      ),
    );
  }

  Future<void> _speakText(String text) async {
    await flutterTts.speak(text);
  }

  Future<void> _stopSpeaking() async {
    await flutterTts.stop();
  }
}

class ProfileContainer extends StatelessWidget {
  const ProfileContainer({
    Key? key,
    required this.isMe,
  }) : super(key: key);

  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isMe
            ? Theme.of(context).colorScheme.secondary
            : Colors.grey.shade800,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(10),
          topRight: const Radius.circular(10),
          bottomLeft: Radius.circular(isMe ? 0 : 15),
          bottomRight: Radius.circular(isMe ? 15 : 0),
        ),
      ),
      child: Icon(
        isMe ? Icons.person : Icons.computer,
        color: Theme.of(context).colorScheme.onSecondary,
      ),
    );
  }
}



