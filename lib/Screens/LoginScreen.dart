import 'package:flutter/material.dart';

import '../Model/ChatModel.dart';
import 'ButtonCard.dart';
import 'HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late ChatModel sourceChat;
  List<ChatModel> chatmodels = [
    ChatModel(
      name: "Shikhar",
      isGroup: false,
      currentMessage: "Hi Everyone",
      time: "4:00",
      icon: "person.svg",
      id: 1,
    ),
    ChatModel(
      name: "User 2",
      isGroup: false,
      currentMessage: "What's Up",
      time: "13:00",
      icon: "person.svg",
      id: 2,
    ),
    ChatModel(
      name: "User 3",
      isGroup: false,
      currentMessage: "What's Up",
      time: "13:00",
      icon: "person.svg",
      id: 3,
    ),
    ChatModel(
      name: "User 4",
      isGroup: false,
      currentMessage: "What's Up",
      time: "13:00",
      icon: "person.svg",
      id: 4,
    ),
    ChatModel(
      name: "User 5",
      isGroup: false,
      currentMessage: "What's Up",
      time: "13:00",
      icon: "person.svg",
      id: 5,
    ),
    ChatModel(
      name: "User 6",
      isGroup: false,
      currentMessage: "What's Up",
      time: "13:00",
      icon: "person.svg",
      id: 6,
    ),
    ChatModel(
      name: "User 7",
      isGroup: false,
      currentMessage: "What's Up",
      time: "13:00",
      icon: "person.svg",
      id: 7,
    ),
    ChatModel(
      name: "User 8",
      isGroup: false,
      currentMessage: "What's Up",
      time: "13:00",
      icon: "person.svg",
      id: 8,
    ),
    ChatModel(
      name: "User 9",
      isGroup: false,
      currentMessage: "What's Up",
      time: "13:00",
      icon: "person.svg",
      id: 9,
    ),
    ChatModel(
      name: "User 10",
      isGroup: false,
      currentMessage: "What's Up",
      time: "13:00",
      icon: "person.svg",
      id: 10,
    ),
    ChatModel(
      name: "User 11",
      isGroup: false,
      currentMessage: "What's Up",
      time: "13:00",
      icon: "person.svg",
      id: 11,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: chatmodels.length,
          itemBuilder: (contex, index) => InkWell(
                onTap: () {
                  sourceChat = chatmodels.removeAt(index);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => Homescreen(
                                chatmodels: chatmodels,
                                sourchat: sourceChat,
                              )));
                },
                child: ButtonCard(
                  name: chatmodels[index].name,
                  icon: Icons.person,
                ),
              )),
    );
  }
}
