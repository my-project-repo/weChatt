import 'dart:developer';

import 'package:chat/home/main/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper
{
   final FirebaseFirestore _store = FirebaseFirestore.instance;
   Future<UserModel?> findUserByUid (String uid) async
  {
     UserModel? user;
     DocumentSnapshot doc = await _store.collection("User-details").doc(uid).get();
     if (doc.data()!=null)
       {
         user = UserModel.fromMap(doc.data() as Map<String,dynamic>);
       }
     return user;

  }
  Future<UserModel?> findByEmail (String email,UserModel currentUser) async
  {
    try {
      QuerySnapshot doc = await _store.collection("User-details").where("email", isEqualTo: email).where("email",isNotEqualTo: currentUser?.email).get();
      if (doc.docs.isNotEmpty) {
        final dataList = doc.docs.map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
        return dataList[0];
      }
    } catch (error)
    {
      log(error.toString());
      return null;
    }
  }
}