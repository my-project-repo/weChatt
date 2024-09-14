import 'dart:developer';
import 'package:chat/home/main/models/firebase_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import 'chat_room.dart';
import 'main/models/user_model.dart';
import 'main/models/chat_room_model.dart';
class SearchPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const SearchPage({super.key, required this.userModel, required this.firebaseUser});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  UserModel? user;
  final _email = TextEditingController();
  bool doesExist = false;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading? Center(child: SizedBox(
        child: CircularProgressIndicator(color: Colors.blue.withOpacity(.85),)
        ,),) : Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
        ),
        child: Column(
          children: [
            const SizedBox(height: 100,),
            Container(
              height: MediaQuery.of(context).size.height/14,
              width: MediaQuery.of(context).size.width-40 ,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(.85),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _email,
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: Colors.white.withOpacity(.8)
                ),
                decoration: InputDecoration(
                    hintText: 'Search email',
                    hintStyle: GoogleFonts.roboto(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: Colors.white.withOpacity(.8)
                    ),
                    prefixIcon: const Icon(Icons.person,size: 27,),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15)
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 200),
              child: IconButton(onPressed: ()async {
                Future.delayed(const Duration(seconds: 2));
                setState(() {
                  isLoading = true;
                });
                 user = await FirebaseHelper().findByEmail(_email.text.trim(),widget.userModel);
                if (user==null)
                  {
                    setState(() {
                      doesExist = false;
                      isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Account could not be found")));
                  }
                else
                  {
                    setState(() {
                      doesExist = true;
                      isLoading = false;
                    });
                  }
              }, icon: const Icon(Icons.arrow_forward)),
            ),
            const SizedBox(height: 20,),
            (doesExist)? ListTile(
              onTap: ()async {
                setState(() {
                  isLoading = true;
                });
                Future.delayed(const Duration(seconds: 2));
                ChatRoomModel? chatRoom = await getChat(user!);
                if (chatRoom!=null)
                  {
                    setState(() {
                      isLoading = false;
                    });
                     Navigator.pop(context);
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatRoom(userTarget: user!,currentUser: widget.userModel,firebaseUser: widget.firebaseUser,
                     chatRoom: chatRoom,)));

                  }


              },
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user!.profileImage!),
              ),
              title: Text(user!.profileName!),
              subtitle: Text(user!.email!),
              trailing: const Icon(Icons.keyboard_arrow_right),
            ) : const ListTile()
          ],
        ),
      ),
    );
  }
  Future<ChatRoomModel?> getChat (UserModel target) async
  {
    try {
      ChatRoomModel? chat;
      QuerySnapshot snap = await FirebaseFirestore.instance.collection("chatrooms").where("participants.${widget.userModel.uid}", isEqualTo: true)
          .where("participants.${target.uid}", isEqualTo: true)
          .get();
      if (snap.docs.isNotEmpty) {
        final list = snap.docs.map((user) => ChatRoomModel.fromMap(user.data() as Map<String, dynamic>)).toList();
        log("user exists");
        chat = list[0];
        return list[0];
      }
      if (snap.docs.isEmpty) {
        ChatRoomModel model = ChatRoomModel(
            chatRoomId: uid.v1(),
            lastMessage: "",
            participants:
            {
              widget.userModel.uid.toString(): true,
              target.uid.toString(): true,
            }

        );
        FirebaseFirestore.instance.collection("chatrooms").doc(model.chatRoomId).set(model.toMap());
        log("new chatroom created");
        chat = model;
      }
      return chat;
    } catch ( error )
    {
      log(error.toString());
      return null;
    }
  }
}
