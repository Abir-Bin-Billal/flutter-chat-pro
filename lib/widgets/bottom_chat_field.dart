import 'package:flutter/material.dart';

class BottomChatField extends StatefulWidget {
  const BottomChatField({
    super.key,
    required this.contactId,
    required this.groupId,
    required this.contactName,
    required this.contactImage,
  });
  final String contactId;
  final String groupId;
  final String contactName;
  final String contactImage;

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
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
          IconButton(onPressed: () {
            showModalBottomSheet(context: context, builder: (context) {
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
            });
          }, icon: const Icon(Icons.attachment)),
          Expanded(
            child: TextFormField(
              decoration: const InputDecoration.collapsed(
                hintText: "Type a message",
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Theme.of(context).primaryColor,
              
            ),
            margin: EdgeInsets.all(5),
            child: Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.arrow_upward, color: Colors.white)),
          )
        ],
      ),
    );
  }
}
