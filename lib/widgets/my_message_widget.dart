import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_pro/models/message_model.dart';

class MyMessageWidget extends StatelessWidget {
  const MyMessageWidget({super.key, required this.message});
  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    final time = formatDate(message.timeSent, [hh, ':', nn, ' ']);
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 30.0, top: 5.0, bottom: 20.0),
              child: Text(
                message.message,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            Positioned(bottom: 4, right: 10, child: Row(children: [
              Text(time,
              
              style: TextStyle(fontSize: 10, color: Colors.white),),
              Icon(
                message.isSeen ? Icons.done_all : Icons.done,
                size: 16,
                color: message.isSeen ? Colors.blue : Colors.white,
              )
              ],)),
          ],
        ),
      ),
    );
  }
}
