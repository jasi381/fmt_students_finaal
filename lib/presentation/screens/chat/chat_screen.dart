import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:students/presentation/appComponents/textComponents/text_component.dart';
import 'package:students/utils/constants.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  List<Message> msgs = [];
  bool isTyping = false;
  bool showSendButton = false;
  ui.Image? backgroundImage;

  final markdownStyleSheet = MarkdownStyleSheet(
    p: GoogleFonts.roboto(color: Colors.black, fontSize: 15),
    h1: GoogleFonts.roboto(color: Colors.black, fontSize: 24),
    h2: GoogleFonts.roboto(color: Colors.black, fontSize: 22),
    h3: GoogleFonts.roboto(color: Colors.black, fontSize: 20),
    h4: GoogleFonts.roboto(color: Colors.black, fontSize: 18),
    h5: GoogleFonts.roboto(color: Colors.black, fontSize: 16),
    h6: GoogleFonts.roboto(color: Colors.black, fontSize: 14),
    em: GoogleFonts.poppins(fontStyle: FontStyle.italic),
    strong: GoogleFonts.poppins(fontWeight: FontWeight.bold),
    blockquote: GoogleFonts.poppins(color: Colors.black),
    code: GoogleFonts.poppins(
      color: Colors.black,
    ),
  );

  @override
  void initState() {
    super.initState();
    controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    controller.removeListener(_onTextChanged);
    controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      showSendButton = controller.text.trim().isNotEmpty;
    });
  }

  void sendMsg() async {
    String text = controller.text;
    String apiKey = Constants.chatGptKey;
    controller.clear();
    if (text.isEmpty) return;

    // Hide the keyboard
    FocusScope.of(context).unfocus();

    setState(() {
      msgs.insert(0, Message(true, text));
      isTyping = true;
    });

    scrollController.animateTo(0.0,
        duration: const Duration(seconds: 1), curve: Curves.linear);

    try {
      var response = await http.post(
          Uri.parse("https://api.openai.com/v1/chat/completions"),
          headers: {
            "Authorization": "Bearer $apiKey",
            "Content-Type": "application/json"
          },
          body: jsonEncode({
            "model": "gpt-3.5-turbo",
            "messages": [
              {"role": "user", "content": text}
            ]
          }));

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        setState(() {
          isTyping = false;
          msgs.insert(
              0,
              Message(
                  false,
                  json["choices"][0]["message"]["content"]
                      .toString()
                      .trimLeft()));
        });
        scrollController.animateTo(0.0,
            duration: const Duration(seconds: 1), curve: Curves.easeOut);

        // Add vibration
        HapticFeedback.heavyImpact();
      }
    } on Exception {
      setState(() {
        isTyping = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Some error occurred, please try again!")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CustomAppBar(
          title: "Chat with Teacher",
          status: "Online",
          onDeleteClicked: () {
            if (msgs.isNotEmpty) {
              setState(() {
                msgs.clear(); // Clear the list of messages only if it's not empty
              });

              // Scroll to the top after clearing the list
              WidgetsBinding.instance.addPostFrameCallback((_) {
                scrollController.animateTo(
                  0.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("No messages to delete")),
              );
            }
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: msgs.isEmpty
                ? Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/chat_asset.png",
                        width: MediaQuery.of(context).size.width * 0.7,
                        // height: MediaQuery.of(context).size.height * 0.7,
                      ),
                      const PoppinsText(
                        text: "Ask your doubts",
                        fontWeight: ui.FontWeight.w500,
                        fontSize: 25,
                      ),
                    ],
                  )
                : ListView.builder(
                    controller: scrollController,
                    itemCount: msgs.length,
                    shrinkWrap: true,
                    reverse: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              margin: const EdgeInsets.only(right: 8),
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xffFF8B59),
                                image: DecorationImage(
                                  image: AssetImage(msgs[index].isSender
                                      ? "assets/images/user_avatar.png"
                                      : "assets/images/teacher_avatar.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    msgs[index].isSender ? 'You' : 'Teacher',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  MarkdownBody(
                                    data: msgs[index].msg,
                                    styleSheet: markdownStyleSheet,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding:  EdgeInsets.only(left: 16,right: 16,bottom: MediaQuery.of(context).padding.bottom),
            child: Row(
              children: [
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: showSendButton
                        ? MediaQuery.of(context).size.width - 80
                        : MediaQuery.of(context).size.width - 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      cursorColor: Colors.black45,
                      controller: controller,
                      style: GoogleFonts.roboto(color: Colors.black),
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "Write a message",
                        hintStyle: GoogleFonts.roboto(color: Colors.black54),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black45),
                            borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black26),
                            borderRadius: BorderRadius.circular(10)),
                        suffixIcon: isTyping
                            ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 5,
                                  height: 5,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    strokeCap: ui.StrokeCap.round,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xffFF8B59),
                                    ),
                                  ),
                                ),
                              )
                            : null,
                      ),
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          sendMsg();
                        }
                      },
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: showSendButton ? 48 : 0,
                  child: showSendButton
                      ? Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: InkWell(
                            onTap: sendMsg,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color(0xffFF6E2F),
                                shape: BoxShape.circle,
                              ),
                              child:
                                  const Icon(Icons.send, color: Colors.white),
                            ),
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  bool isSender;
  String msg;

  Message(this.isSender, this.msg);
}

class CustomAppBar extends StatelessWidget {
  final String title;
  final String status;
  final VoidCallback onDeleteClicked;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.status,
    required this.onDeleteClicked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 10, left: 16),
      color: Constants.appBarColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Image.asset(
            'assets/images/teacher_avatar.png',
            color: Colors.white,
            height: 42,
            width: 28,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                status,
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
              onPressed: () {
                onDeleteClicked();
              },
              icon: const Icon(
                CupertinoIcons.delete,
                color: Colors.white,
              ))
        ],
      ),
    );
  }
}
