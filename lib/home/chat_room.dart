import 'dart:developer';

import 'package:chat/home/main/models/message_model.dart';
import 'package:chat/home/main/models/user_model.dart';
import 'package:chat/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'main/models/chat_room_model.dart';

class ChatRoom extends StatefulWidget {
  UserModel userTarget;
  UserModel currentUser;
  User firebaseUser;
  ChatRoomModel chatRoom;
  ChatRoom({super.key,required this.userTarget,required this.currentUser,required this.firebaseUser,required this.chatRoom});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final chat = TextEditingController();
  Future<void> sendMessage () async
  {
    String myText = chat.text.trim();
    chat.clear();
    if (myText.isNotEmpty)
      {
        MessageModel newMessage = MessageModel(
          messageId: uid.v1(),
          sender: widget.currentUser.uid,
          text : myText,
          seen : false,
          createdOn: DateTime.now(),
        );
        FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatRoom.chatRoomId).collection("messages").doc(newMessage.messageId).set(newMessage.toMap());
        log("message saved");
        widget.chatRoom.lastMessage = myText;
        FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatRoom.chatRoomId).set(widget.chatRoom.toMap());

      }
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.withOpacity(.8),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                CircleAvatar(backgroundImage: NetworkImage(widget.userTarget.profileImage!),),
                const SizedBox(width: 10,),
                Text(widget.userTarget.profileName!,style: const TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500),),
              ],
            ),

            IconButton(onPressed: (){}, icon: const Icon(Icons.call))
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 5,),
            // chat
            Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatRoom.chatRoomId).collection("messages").orderBy("createdOn",descending: true).snapshots(),
                    builder: (context,snapshot){
                      if (snapshot.connectionState == ConnectionState.active)
                        {
                          if (snapshot.hasData)
                            {
                              QuerySnapshot snap = snapshot.data as QuerySnapshot;
                              return ListView.builder(
                                  reverse: true,
                                  itemCount: snap.docs.length ,
                                  itemBuilder: (context,index)
                              {
                               Map<String,dynamic> map = snap.docs[index].data() as Map<String,dynamic>;
                               Timestamp stamp = snap.docs[index].get("createdOn");
                               map["createdOn"] = stamp.toDate();
                               MessageModel msg = MessageModel.fromMap(map);
                               log(msg.text!);
                                return Row(
                                  mainAxisAlignment: (msg.sender == widget.currentUser.uid)? MainAxisAlignment.end : MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        padding: const EdgeInsets.all(8),
                                        margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 20).copyWith(left: (msg.sender == widget.currentUser.uid)?80:15),
                                      decoration: BoxDecoration(
                                        color: (msg.sender==widget.currentUser.uid)?Colors.blue.withOpacity(.8):Colors.black.withOpacity(.5),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                        child: Text(msg.text!,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w500),)
                                    ),
                                  ],
                                );
                              });
                            }
                          else if (snapshot.hasError)
                            {
                              return const Center(child: Text("An error detected! Please check your internet"));
                            }
                          else
                            {
                              return const Center(child: Text("Say hi to your new friend"));
                            }
                        }
                      else
                        {
                          return const Center(child: CircularProgressIndicator());
                        }
                    },
                  ),

            )),
            const SizedBox(height: 10,),
            Container(
              height: size.height/14,
              width: size.width-20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.withOpacity(.3),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                   Flexible(child: TextField(
                    controller: chat ,
                    decoration: const InputDecoration(
                      hintText: "Enter message",
                      border: InputBorder.none
                    ),
                  )),
                  IconButton(onPressed: ()async{
                    await sendMessage();
                  }, icon: Icon(Icons.send_rounded,color: Colors.blue.withOpacity(.8),))
                ],
              ),
            ),
            const SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }
}
