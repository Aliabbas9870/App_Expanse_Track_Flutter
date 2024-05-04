// import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({Key? key}) : super(key: key);

  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  List<ChatMessage> messages = [];
  final ChatUser currentUser =
      ChatUser(id: '1', firstName: 'Ali', lastName: 'Abbas', profileImage: 'https://cdn.pixabay.com/photo/2016/08/31/11/54/user-1633249_960_720.png');
  final ChatUser geminiUser = ChatUser(
    id: '2',
    firstName: 'Chate',
    lastName: 'Bot',
    profileImage: 'https://cdn.pixabay.com/photo/2016/08/31/11/54/user-1633249_960_720.png',
  );
  final Gemini gemini = Gemini.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 213, 213, 219),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor:Color.fromARGB(255, 13, 52, 102),
        centerTitle: true,
        title: Text(
          'ChatBot',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return DashChat(
      inputOptions: InputOptions(
        trailing: [
          IconButton(
            icon: Icon(Icons.image),
            onPressed: sendMediaMessage,
          )
        ],
      ),
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages.insert(0, chatMessage);
    });
    try {
      String question = chatMessage.text ?? '';
      List<Uint8List>? images;
      if (chatMessage.medias != null) {
        question = chatMessage.medias!.first.url;
        images = [File(chatMessage.medias!.first.url).readAsBytesSync()];
      }

      gemini.streamGenerateContent(question, images: images).listen((event) {
        String? response =
            event.content?.parts?.map((part) => part.text ?? '').join().trim();

        setState(() {
          messages.insert(
            0,
            ChatMessage(
              user: geminiUser,
              createdAt: DateTime.now(),
              text: response ?? 'No response found',
            ),
          );
        });
      });
    } catch (e) {
      Get.snackbar('Error', '$e');
    }
  }

  void sendMediaMessage() async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      final chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        // text: 'Image selected',
        medias: [
          ChatMedia(
            url: file.path,
            fileName: '',
            type: MediaType.image,
          ),
        ],
      );

      // Send image to chatbot for processing
      _sendMessage(chatMessage);
    }
  }
}
