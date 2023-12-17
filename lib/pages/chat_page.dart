import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final/chat_bubble.dart';
import 'package:flutter_final/chat_service.dart';
import 'package:giphy_picker/giphy_picker.dart';

class ChatPage extends StatefulWidget {
  final String receiverDisplayName;
  final String receiverUserID;

  const ChatPage({
    Key? key,
    required this.receiverDisplayName,
    required this.receiverUserID,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  late String apiKey;
  List<String> gifUrls = [];
  GiphyGif? _selectedGif;

  @override
  void initState() {
    super.initState();
    apiKey = 'Xgs18NNzmIUWtkMRi36dWlJTNK5Q2NkS';
  }

  Future<void> pickGif() async {
    final GiphyGif? gif = await GiphyPicker.pickGif(
      context: context,
      apiKey: apiKey,
      fullScreenDialog: false,
      showPreviewPage: false,
    );

    if (gif != null) {
      setState(() {
        _selectedGif = gif;
        _sendGIF(_selectedGif!.url!);
      });
    }
  }

  void _sendGIF(String message) async {
    if (_selectedGif != null) {
      message = 'Giphy: ${_selectedGif!.url}';
    }
    await _chatService.sendMessage(widget.receiverUserID, message);
  }

  void _sendTextMessage() async {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverUserID, message);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverDisplayName),
      ),
      body: Column(
        children: [
          if (_selectedGif != null) ...[
            Image.network(_selectedGif!.url!),
            const SizedBox(height: 10),
          ],
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
          widget.receiverUserID, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading..');
        }

        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.bottomLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Column(
              crossAxisAlignment:
                  (data['senderId'] == _firebaseAuth.currentUser!.uid)
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
              mainAxisAlignment:
                  (data['senderId'] == _firebaseAuth.currentUser!.uid)
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
              children: [
                // User Display Name.
                Row(
                  mainAxisAlignment:
                      (data['senderId'] == _firebaseAuth.currentUser!.uid)
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 50),
                    Text(data['senderDisplayName']),
                  ],
                ),
                const SizedBox(height: 5),
                // User message and avatar.
                Row(
                  mainAxisAlignment:
                      (data['senderId'] == _firebaseAuth.currentUser!.uid)
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                  children: [
                    if (data['senderId'] != _firebaseAuth.currentUser!.uid)
                      const CircleAvatar(
                        backgroundColor: Color.fromRGBO(174, 248, 195, 1),
                        backgroundImage: NetworkImage(
                          'https://cdn.icon-icons.com/icons2/1812/PNG/512/4213460-account-avatar-head-person-profile-user_115386.png',
                        ),
                      ),
                    const SizedBox(width: 10),
                    ChatBubble(message: data['message']),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(hintText: 'Enter message'),
              obscureText: false,
            ),
          ),
          IconButton(
            onPressed: _sendTextMessage,
            icon: const Icon(
              Icons.arrow_upward,
              size: 40,
            ),
          ),
          IconButton(
            onPressed: pickGif,
            icon: const Icon(
              Icons.gif_box,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}
