import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';
import 'package:flutter_sound/flutter_sound.dart';

class AIChate extends StatefulWidget {
  const AIChate({Key? key}) : super(key: key);

  @override
  State<AIChate> createState() => _AIChateState();
}

class _AIChateState extends State<AIChate> {
  TextEditingController _userInput = TextEditingController();
  ScrollController _scrollController = ScrollController(); // Add ScrollController

  static const apiKey = "AIzaSyD9YZ99IOKqYQRQiB8iOU0neC19wl5ncSI";

  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

  final List<Message> _messages = [];

  bool isSpeedDialEnabled = true;

  Future<void> sendMessage() async {
    final message = _userInput.text;

    setState(() {
      _messages.add(Message(isUser: true, message: message, date: DateTime.now()));
    });

    final content = [Content.text(message)];
    final response = await model.generateContent(content);

    setState(() {
      _messages.add(Message(
          isUser: false, message: response.text ?? "", date: DateTime.now()));
    });

    // Scroll to the bottom after adding a message
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:   Color.fromARGB(255, 13, 52, 102),
        title: Text('AI-AAR',style: GoogleFonts.adamina(color: Colors.white, fontSize: 23),),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.8),
              BlendMode.dstATop,
            ),
            image: AssetImage('assets/images/bgAndroid.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController, // Assign ScrollController
                itemCount: _messages.length,
                reverse: false, // Set reverse to true
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Messages(
                    isUser: message.isUser,
                    message: message.message,
                    date: DateFormat('HH:mm').format(message.date),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Row(
                  children: [
                    Expanded(
                      flex: 15,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          controller: _userInput,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromARGB(255, 170, 180, 201),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            labelText: 'Enter Message ....',
                          ),
                          onFieldSubmitted: (value) {
                            sendMessage();
                            _userInput.clear();
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.all(12),
                      iconSize: 30,
                      onPressed: () {
                        // Add functionality for voice input here
                      },
                      icon: Icon(
                        Icons.mic,
                        color: Colors.white,
                      ),
                    ),
                    if (isSpeedDialEnabled) // Check if SpeedDial is enabled
                      IconButton(
                        padding: EdgeInsets.all(12),
                        iconSize: 30,
                        onPressed: () {
                          sendMessage();
                          _userInput.clear(); // Clear the text field
                        },
                        icon: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Message {
  final bool isUser;
  final String message;
  final DateTime date;

  Message({required this.isUser, required this.message, required this.date});
}

class Messages extends StatelessWidget {
  final bool isUser;
  final String message;
  final String date;

  const Messages({
    Key? key,
    required this.isUser,
    required this.message,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(vertical: 15)
          .copyWith(left: isUser ? 100 : 10, right: isUser ? 10 : 100),
      decoration: BoxDecoration(
        color: isUser ? Color.fromARGB(255, 8, 18, 36) : Colors.grey.shade400,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: isUser ? Radius.circular(10) : Radius.zero,
          topRight: Radius.circular(10),
          bottomRight: isUser ? Radius.zero : Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: isUser ? Colors.white : Colors.black,
            ),
          ),
          Text(
            date,
            style: TextStyle(
              fontSize: 10,
              color: isUser ? Colors.white : Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
