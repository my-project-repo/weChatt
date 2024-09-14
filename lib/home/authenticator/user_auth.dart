import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat/home/main/models/user_model.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  Future<UserCredential?> createUserWithEmailAndPass(String email, String password) async
  {
    try {
      final UserCredential user = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      UserModel? model;
      if (user.user != null ) {
       await _store.collection('User-details').doc(_auth.currentUser?.uid).set(
          {
            "uid" : user.user!.uid,
            "email" : email,
            "profileName" : "",
            "ProfileImage" : "",
          }
        );
      }
      return user;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<User?> validateUser(String email, String password) async
  {
    try {
      final UserCredential user = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return user.user;
    }
    catch (e) {
      log(e.toString());
      return null;
    }
  }
  Future<User?> findUser (String email) async
  {
    Map<String,dynamic> map;
    _store.collection('User-details').where("email",isEqualTo: email).get().then((value)=>{
      map = value.docs[0].data()
    });
  }

  Future<bool?> findProfile (String profile) async
  {
    try
        {
           Query query = _store.collection("User-details").where("profileName",isEqualTo: profile);
           final res = await query.get();
           if (res.docs.isNotEmpty)
             {
               return true;
             }
           else
             {
               return false;
             }
        }
        catch (error)
    {
      log(error.toString());
      return null;
    }
  }
}