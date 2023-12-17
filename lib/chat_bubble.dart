import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  const ChatBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isGiphyLink = message.startsWith('Giphy: ');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color.fromARGB(255, 30, 180, 73),
      ),
      child: isGiphyLink
          ? _buildGiphyImage(message)
          : Text(
              message,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
    );
  }

  Widget _buildGiphyImage(String message) {
    // Remove the "Giphy: " prefix
    String giphyUrl = message.substring('Giphy: '.length);
    // Split the URL using '/'
    List<String> parts = giphyUrl.split('/');
    // Get the last part of the URL
    String lastPart = parts.last;
    // Remove the file extension from the last part
    String fileName = lastPart.split('.')[0];
    // Split the fileName using '-'
    List<String> subparts = fileName.split('-');
    // Get the last subpart (the unique identifier)
    String urlPart = subparts.last;

    String gifUrl = 'https://i.giphy.com/media/$urlPart/200.gif';

    return Image.network(
      gifUrl,
      fit: BoxFit.cover,
      width: 200,
      height: 200,
    );
  }
}
