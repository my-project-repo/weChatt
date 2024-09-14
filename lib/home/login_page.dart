import 'dart:developer';
import 'package:chat/home/authenticator/user_auth.dart';
import 'package:chat/home/create_page.dart';
import 'package:chat/home/main/models/firebase_helper.dart';
import 'package:chat/home/main/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'chat_page.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  final Auth _auth = Auth();
  final emailText = TextEditingController();
  final passText = TextEditingController();
  bool isVisible = true;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: isLoading? Center(child: SizedBox(
        child: CircularProgressIndicator(color: Colors.blue.withOpacity(.85),)
        ,),)
          :SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Icon(Icons.menu,size: 25,),
                const SizedBox(width: 200,),
                Container(
                  height: 30,
                  width: 30,
                  decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle
                  ),
                  child: const Icon(Icons.message,size: 19,color: Colors.white,),
                )
              ],
            ),
            const SizedBox(height: 120,),
            Padding(
              padding: const EdgeInsets.only(right: 10,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Welcome Back',
                    style: GoogleFonts.roboto(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),),
                  Text('Enter your credentials to login',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),),
                ],
              ),
            ),
            const SizedBox(height: 60,),
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height/14,
                  width: MediaQuery.of(context).size.width-40 ,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(.85),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: emailText,
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: Colors.white.withOpacity(.8)
                    ),
                    decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: GoogleFonts.roboto(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: Colors.white.withOpacity(.8),
                        ),
                        prefixIcon: const Icon(Icons.account_circle,size: 30,),
                        border: const OutlineInputBorder(borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(vertical: 15)
                    ),
                  ),
                ),
                const SizedBox(height: 40,),
                Container(
                  height: MediaQuery.of(context).size.height/14,
                  width: MediaQuery.of(context).size.width-40 ,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(.85),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: passText,
                    obscureText: !isVisible,
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: Colors.white.withOpacity(.8)
                    ),
                    decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: GoogleFonts.roboto(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            color: Colors.white.withOpacity(.8)
                        ),
                        suffixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              isVisible = !isVisible;
                            });
                          },
                          icon: (isVisible )?const Icon(Icons.visibility):const Icon(Icons.visibility_off),
                        ),
                        prefixIcon: const Icon(Icons.lock,size: 27,),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 15)
                    ),
                  ),
                ),
                const SizedBox(height: 75,),
                MaterialButton(onPressed: () {
                },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 150),
                    child: Container(
                      height:70,
                      width: 70,
                      decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(.7),
                          shape: BoxShape.circle
                      ),
                      child: Center(child: IconButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                            User? user = await _auth.validateUser(emailText.text.trim(), passText.text.trim());
                            if (user == null)
                            {
                              log('Could not find account ');
                              setState(() {
                                isLoading = false;
                              });
                            }
                            else
                            {
                              log('Success');
                              setState(() {
                                isLoading = false;
                              });
                              String uid = user.uid;
                              DocumentSnapshot userData = await FirebaseFirestore.instance.collection('User-details').doc(uid).get();
                              UserModel userModel = UserModel.fromMap(userData.data() as Map<String, dynamic>);
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>  chatPage(userModel: userModel ,firebaseUser: user,)));
                            }

                        },
                        icon: const Icon(Icons.arrow_forward,color: Colors.white,),
                      ),),
                    ),
                  ),
                ),
                const SizedBox(height: 100,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account ?",
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w400
                      ),),
                    TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const CreatePage() ));
                    },
                        child: Text('Create one.',
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.withOpacity(.75)
                          ),))
                  ],
                ),
              ],
            ),
          ],
        ),
      ),

    );
  }
}
