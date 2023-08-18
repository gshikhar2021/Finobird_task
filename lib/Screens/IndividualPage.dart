import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/ReplyCard.dart';
import 'package:flutter_svg/svg.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import '../Model/ChatModel.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../Model/MessageModel.dart';
import 'OwnMessageCard.dart';

class IndividualPage extends StatefulWidget {
  IndividualPage({Key? key, required this.chatModel, required this.sourchat})
      : super(key: key);
  final ChatModel chatModel;
  final ChatModel sourchat;

  @override
  _IndividualPageState createState() => _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage> {
  bool show = false;
  FocusNode focusNode = FocusNode();
  FocusScopeNode _focusScopeNode = FocusScopeNode();

  bool sendButton = false;
  List<MessageModel> messages = [];
  TextEditingController _controller = TextEditingController();
  late IO.Socket socket;
  @override
  void initState() {
    super.initState();
    // connect();

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
    });
    connect();
  }

  void connect() {
    // MessageModel messageModel = MessageModel(sourceId: widget.sourceChat.id.toString(),targetId: );
    socket =
        IO.io("https://node-js-service-rx3q.onrender.com", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect();
    socket.emit("signin", widget.sourchat.id);
    socket.onConnect((data) {
      print("Connected");
      socket.on("message", (msg) {
        print(msg);
        setMessage("destination", msg["message"]);
      });
    });
    print(socket.connected);
    // socket.emit('msg', 'Shikhar');
  }

  void sendMessage(String message, int sourceId, int targetId) {
    setMessage("source", message);
    socket.emit("message",
        {"message": message, "sourceId": sourceId, "targetId": targetId});
  }

  void setMessage(String type, String message) {
    MessageModel messageModel = MessageModel(
      type: type,
      message: message,
    );
    print(messages);

    setState(() {
      messages.add(messageModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/whatsapp_Back.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leadingWidth: 70,
            titleSpacing: 0,
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Icon(
                      Icons.arrow_back,
                    ),
                  ),
                  Expanded(
                    child: CircleAvatar(
                      child: SvgPicture.asset(
                        "assets/person.svg",
                        color: Colors.white,
                        width: 30,
                        height: 30,
                      ),
                      backgroundColor: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            ),
            title: InkWell(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.all(6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.chatModel.name.toString(),
                      style: TextStyle(
                        fontSize: 18.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "last seen today at 12:05",
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    )
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(icon: Icon(Icons.videocam), onPressed: () {}),
              IconButton(icon: Icon(Icons.call), onPressed: () {}),
              PopupMenuButton<String>(
                padding: EdgeInsets.all(0),
                onSelected: (value) {
                  print(value);
                },
                itemBuilder: (BuildContext contesxt) {
                  return [
                    PopupMenuItem(
                      child: Text("View Contact"),
                      value: "View Contact",
                    ),
                    PopupMenuItem(
                      child: Text("Media, links, and docs"),
                      value: "Media, links, and docs",
                    ),
                    PopupMenuItem(
                      child: Text("Search"),
                      value: "Search",
                    ),
                    PopupMenuItem(
                      child: Text("Mute Notification"),
                      value: "Mute Notification",
                    ),
                    PopupMenuItem(
                      child: Text("Wallpaper"),
                      value: "Wallpaper",
                    ),
                  ];
                },
              ),
            ],
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: WillPopScope(
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    height: MediaQuery.of(context).size.height - 200,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        DateTime currentTime = DateTime.now();
                        int hour = currentTime.hour;
                        int minute = currentTime.minute;
                        if (messages[index].type == "source") {
                          return OwnMessageCard(
                            message: messages[index].message.toString(),
                            time: "$hour:$minute",
                          );
                        } else {
                          return ReplyCard(
                            message: messages[index].message.toString(),
                            time: "$hour:$minute",
                          );
                        }
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 15,
                    left: 5,
                    right: 5,
                    // right: 10,
                    child: Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width - 80,
                                child: Card(
                                  // margin: EdgeInsets.only(
                                  //     left: 2, right: 2, bottom: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: TextFormField(
                                    controller: _controller,
                                    focusNode: focusNode,
                                    textAlignVertical: TextAlignVertical.center,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 5,
                                    minLines: 1,
                                    onChanged: (value) {
                                      if (value.length > 0) {
                                        setState(() {
                                          sendButton = true;
                                        });
                                      } else {
                                        setState(() {
                                          sendButton = false;
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Type a message",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      prefixIcon: IconButton(
                                        icon: Icon(
                                          show
                                              ? Icons.keyboard
                                              : Icons.emoji_emotions_outlined,
                                        ),
                                        onPressed: () {
                                          if (!show) {
                                            focusNode.unfocus();
                                            focusNode.canRequestFocus = false;
                                            // _focusScopeNode.requestFocus();
                                          }
                                          setState(() {
                                            show = !show;
                                          });
                                        },
                                      ),
                                      suffixIcon: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.attach_file),
                                            onPressed: () {},
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.camera_alt),
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: Color(0xFF128C7E),
                                child: IconButton(
                                  icon: Icon(
                                    sendButton ? Icons.send : Icons.mic,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    if (sendButton) {
                                      final sourchatId = widget.sourchat.id ??
                                          0; // Replace 0 with a default value
                                      final chatModelId = widget.chatModel.id ??
                                          0; // Replace 0 with a default value
                                      sendMessage(_controller.text, sourchatId,
                                          chatModelId);
                                      _controller.clear();
                                      setState(() {
                                        sendButton = false;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          show ? emojiSelect() : Container(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              onWillPop: () {
                if (show) {
                  setState(() {
                    show = false;
                  });
                } else {
                  Navigator.pop(context);
                }
                return Future.value(false);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget emojiSelect() {
    _focusScopeNode.requestFocus();
    return Container(
      height: 300,
      width: MediaQuery.of(context)
          .size
          .width, // Set a fixed height for the EmojiPicker container
      child: EmojiPicker(
        textEditingController: _controller,
        onEmojiSelected: (emoji, category) {
          if (emoji != null) {
            setState(() {
              _controller.text = _controller.text;
            });
          }
        },
      ),
    );
  }
}
