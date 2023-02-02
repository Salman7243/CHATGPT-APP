import 'dart:async';

import 'package:chat_gbt_app/chatmessage.dart';
import 'package:chat_gbt_app/threedots.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  ChatGPT? chatGPT;

  StreamSubscription? _subscription;
  bool _isTyping = false;

  var kIranslateMode1V3;

  @override
  void initState() {
    super.initState();
    chatGPT = ChatGPT.instance;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _sendMessage() {
    ChatMessage _message =
        ChatMessage(text: _controller.text, sender: "User");
    setState(() {
      _messages.insert(0, _message);
      _isTyping = true;
    });
    _controller.clear();
    var message;
    final request = CompleteReq(
        prompt: message.Text, model: kIranslateMode1V3, max_tokens: 200);
    _subscription = chatGPT!
        .builder("sk-OPtbZc5yzely J4DSwBqST3B1bkF 113xrZzVOFUSyHZc3FUXB",
            orgId: "")
        .onCompleteStream(request: request)
        .listen((response) {
      Vx.log(response!.choices[0].text);
      ChatMessage botMessage =
          ChatMessage(text: response.choices[0].text, sender: "bot");

      setState(() {
        _isTyping = false;
        _messages.insert(0, botMessage);
      });
    });
  }

  Widget _buildTextComposer() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            onSubmitted: (value) => _sendMessage(),
            decoration: InputDecoration.collapsed(hintText: "Send a Message"),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: () => _sendMessage(),
        )
      ],
    ).px16();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Chat GPT Demo"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
                child: ListView.builder(
              // height: context.screenHeight,
              reverse: true,
              padding: Vx.m8,
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                return _messages[index];
              },
            )),
            if (_isTyping) ThreeDots(),
            const Divider(
              height: 1.0,
            ),
            Container(
              decoration: BoxDecoration(
                color: context.cardColor,
              ),
              child: _buildTextComposer(),
            )
          ],
        ),
      ),
    );
  }

  CompleteReq({required prompt, required model, required int max_tokens}) {}
}

class ChatGPT {
  static ChatGPT? instance;

  builder(String s, {required String orgId}) {}
}
