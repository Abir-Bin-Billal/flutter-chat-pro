import 'package:flutter/material.dart';
import 'package:flutter_chat_pro/providers/authentication_provider.dart';
import 'package:flutter_chat_pro/providers/chat_provider.dart';
import 'package:flutter_chat_pro/utils/app_const.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class BottomChatField extends StatefulWidget {
  const BottomChatField({
    super.key,
    required this.contactUID,
    required this.groupId,
    required this.contactName,
    required this.contactImage,
  });
  final String contactUID;
  final String groupId;
  final String contactName;
  final String contactImage;

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  late TextEditingController _textEditingController;
  FocusNode? _focusNode;

void sendTextMessage() async {
  print("Sending message: '${_textEditingController.text.trim()}'");
  final currentUser = context.read<AuthenticationProvider>().userModel!;
  final ChatProvider chatProvider = context.read<ChatProvider>();

  chatProvider.sendTextMessage(
    sender: currentUser,
    message: _textEditingController.text,
    contactUID: widget.contactUID,
    contactName: widget.contactName,
    contactImage: widget.contactImage,
    messageType: MessageEnum.text,
    groupId: widget.groupId,
    onSuccess: () {
      _textEditingController.clear();
      _focusNode?.requestFocus();
      print("Message sent successfully");
    },
    onError: (error) {
      Fluttertoast.showToast(msg: error.toString());
      print("Error sending message: $error");
    },
  );
}


  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).primaryColor),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    height: 200,
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.image),
                          title: Text("Gallery"),
                          onTap: () {
                            // Handle gallery tap
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.camera),
                          title: Text("Camera"),
                          onTap: () {
                            // Handle camera tap
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.attachment),
          ),
          Expanded(
            child: TextFormField(
              controller: _textEditingController,
              focusNode: _focusNode,
              decoration: const InputDecoration.collapsed(
                hintText: "Type a message",
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: sendTextMessage,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Theme.of(context).primaryColor,
              ),
              margin: EdgeInsets.all(5),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.arrow_upward, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
