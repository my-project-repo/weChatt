import 'dart:developer';
import 'package:chat/home/authenticator/user_auth.dart';
import 'package:chat/home/main/models/user_model.dart';
import 'package:chat/home/main/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final Auth _auth = Auth();
  final emailText = TextEditingController();
  final passText = TextEditingController();
  bool isVisible = true;
  bool isDigit = false;
  bool isPassChar = false;
  bool isLoading = false;
  checkPasswordAndChar (String pass)
  {
    setState(() {
      isDigit = false;
      isPassChar = false;
      final numRex = RegExp(r'[0-9]');
      if (numRex.allMatches(pass.trim()).length>=3)
      {
        isDigit = true;
      }
      if (pass.trim().length>=7)
      {
        isPassChar = true;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: isLoading ? Center(child: SizedBox(
        child: CircularProgressIndicator(color: Colors.blue.withOpacity(.85),)
        ,),) : SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
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
              padding: const EdgeInsets.only(right: 90,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sign up',
                    style: GoogleFonts.roboto(
                      fontSize: 29,
                      fontWeight: FontWeight.bold,
                    ),),
                  Text('Create your account',
                    style: GoogleFonts.roboto(
                      fontSize: 23,
                      fontWeight: FontWeight.w400,
                    ),),
                ],
              ),
            ),
            const SizedBox(height: 50,),
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
                const SizedBox(height: 30,),
                Container(
                  height: MediaQuery.of(context).size.height/14,
                  width: MediaQuery.of(context).size.width-40 ,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(.85),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: passText,
                    onChanged: (password)=>checkPasswordAndChar(password),
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
                const SizedBox(height: 15,),
                Row(
                  children: [
                    const SizedBox(width: 20,),
                    AnimatedContainer(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                          color: (isPassChar)? Colors.green.withOpacity(.8) : Colors.white,
                          border: (isPassChar)? Border.all(color: Colors.transparent) : Border.all(color : Colors.grey),
                          shape: BoxShape.circle
                      ),
                      duration: const Duration(milliseconds: 500),
                      child: const Center(child: Icon(Icons.check,size: 15,color: Colors.white,)),
                    ),
                    const SizedBox(width: 10,),
                    const Text('Contains at least 7 characters',)
                  ],
                ),
                const SizedBox(height: 15,),
                Row(
                  children: [
                    const SizedBox(width: 20,),
                    AnimatedContainer(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                          color: (isDigit)? Colors.green.withOpacity(.8) : Colors.white,
                          border: (isDigit)? Border.all(color: Colors.transparent) : Border.all(color : Colors.grey),
                          shape: BoxShape.circle
                      ),
                      duration: const Duration(milliseconds: 500),
                      child: const Center(child: Icon(Icons.check,size: 15,color: Colors.white,)),
                    ),
                    const SizedBox(width: 10,),
                    const Text('Contains at least 3 digits',)
                  ],
                ),
                const SizedBox(height: 40,),
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
                          if(isDigit && isPassChar )
                          {
                            setState(() {
                              isLoading = true;
                            });
                            log("hii : ${emailText.text} ${passText.text}");
                            UserCredential? user = await _auth.createUserWithEmailAndPass(emailText.text.trim(), passText.text.trim());
                         if (user!=null)
                          {
                            log('Success');
                            setState(() {
                              isLoading = false;
                            });
                            String uid = user.user!.uid;
                            UserModel model = UserModel(
                              uid: uid,
                              email: emailText.text.trim(),
                              profileImage: "",
                              profileName: "",
                            );

                            Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfilePage(userModel: model,firebaseUser:user.user! ,)));

                          }
                            else
                            {
                              log('Could not create account ');
                              setState(() {
                                isLoading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text(
                                  'Account already exist',
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                                  backgroundColor: Colors.white,)
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.arrow_forward,color: Colors.white,),
                      ),),
                    ),
                  ),
                ),
                const SizedBox(height: 80,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account ?",
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w400
                    ),),
                    TextButton(onPressed: (){
                     Navigator.pop(context);
                    },
                        child: Text('Log in.',
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
