import 'package:chat/home/chat_page.dart';
import 'package:chat/home/login_page.dart';
import 'package:chat/home/main/models/firebase_helper.dart';
import 'package:chat/home/main/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'firebase_options.dart';
var uid = const Uuid();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  User? user = FirebaseAuth.instance.currentUser;
  if (user!=null)
    {
      UserModel? userModel = await FirebaseHelper().findUserByUid(user.uid);
      runApp( MyAppLoggedIn(user: userModel! , firebaseUser: user));
    }
  else
    {
      runApp(const MyApp());
    }

}
// Not Logged In
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: loginPage(),
    );
  }
}
// Logged In
class MyAppLoggedIn extends StatelessWidget {
  final UserModel user;
  final User firebaseUser;
  const MyAppLoggedIn({super.key, required this.user, required this.firebaseUser});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: chatPage(userModel: user,firebaseUser: firebaseUser,),
    );
  }
}