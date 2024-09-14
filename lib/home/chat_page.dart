import 'dart:developer';

import 'package:chat/home/chat_room.dart';
import 'package:chat/home/login_page.dart';
import 'package:chat/home/main/models/chat_room_model.dart';
import 'package:chat/home/main/models/firebase_helper.dart';
import 'package:chat/home/main/models/user_model.dart';
import 'package:chat/home/search_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class chatPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const chatPage({super.key, required this.userModel, required this.firebaseUser});

  @override
  State<chatPage> createState() => _chatPageState();
}

class _chatPageState extends State<chatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text("WeChatt",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),)),backgroundColor: Colors.blue.withOpacity(.8),
      shape: RoundedRectangleBorder(
        side: BorderSide.none,
        borderRadius: BorderRadius.circular(0)
      ),
      actions: [
        IconButton(onPressed: (){
          showDialog(context: context, builder: (context)=>AlertDialog(
            actions: [
              TextButton(onPressed: (){
                FirebaseAuth.instance.signOut();
                Navigator.popUntil(context, (route)=>route.isFirst);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const loginPage()));
              }, child: const Text("Sign out"))
            ],
            title: Text("Do you really want to sign out ? ",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black.withOpacity(.7)),),
            contentPadding: const EdgeInsets.all(10),
          ));
        }, icon: const Icon(Icons.exit_to_app_outlined))
      ],),
      body: SafeArea(
        child: Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("chatrooms").snapshots(),
            builder: (context,snapshot)
            {
              if (snapshot.connectionState == ConnectionState.active)
                {
                  if (snapshot.hasData)
                    {
                      QuerySnapshot snap = snapshot.data as QuerySnapshot;
                      return ListView.builder(
                          itemCount: snap.docs.length,
                          itemBuilder: (context,index)
                      {
                        ChatRoomModel chat = ChatRoomModel.fromMap(snap.docs[index].data() as Map<String,dynamic>);
                        Map<String,dynamic> participants = chat.participants!;
                        List<String> keys = participants.keys.toList();
                        keys.remove(widget.userModel.uid);
                        return FutureBuilder(future: FirebaseHelper().findUserByUid(keys[0]), builder: (context,snapshot)
                        {

                          if (snapshot.data!=null && snapshot.connectionState == ConnectionState.done)
                            {
                              UserModel dataUser = snapshot.data as UserModel;
                              return ListTile(
                                onTap: ()
                                {
                                  // Navigate
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                      ChatRoom(userTarget: dataUser, currentUser: widget.userModel, firebaseUser: widget.firebaseUser, chatRoom: chat)));
                                },
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(dataUser.profileImage!),
                                ),
                                title: Text(dataUser.profileName!,style: const TextStyle(fontWeight: FontWeight.w400),),
                                subtitle: Text(chat.lastMessage!),
                         );
                        } else
                          {
                            return const Center(child: ListTile(),);
                          }
                        });
                      });
                    }
                  else if (snapshot.hasError)
                    {
                      return const Center(child: Text("Some error occurred"));
                    }
                  else
                    {
                      return const Center(
                        child: Text("No data"),
                      );
                    }
                }
              else
                {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
            },
          ),

        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: (){
         Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchPage(userModel: widget.userModel,firebaseUser: widget.firebaseUser,)));
        },
        child: CircleAvatar(
          radius: 32,
          backgroundColor: Colors.blue.withOpacity(.8),
          child: const Icon(Icons.search,size: 30,color: Colors.white,),
        ),
      ),
    );
  }
}
