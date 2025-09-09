import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_pro/models/message_model.dart';
import 'package:swipe_to/swipe_to.dart';

class ContactMessageWidget extends StatelessWidget {
  const ContactMessageWidget({super.key, required this.message, required this.onRightSwipe});
  final MessageModel message;
  final Function() onRightSwipe;
  @override
  Widget build(BuildContext context) {
    final time = formatDate(message.timeSent, [hh, ':', nn, ' ']);
    return SwipeTo(
      onRightSwipe: (details) {
        onRightSwipe();
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.7,
          maxHeight: MediaQuery.sizeOf(context).height * 0.3,
        ),child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 30, top: 5, left: 10, bottom: 20),
                child: Text(
                  message.message,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              Positioned(bottom: 4, right: 10,child: Text(
                time,
                style: const TextStyle(fontSize: 10, color: Colors.black54),
              ),)
            ],
          ),
        ),
        )
      ),
    );
  }
}
