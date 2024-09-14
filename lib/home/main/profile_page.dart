import 'dart:typed_data';
import 'package:chat/home/authenticator/user_auth.dart';
import 'package:chat/home/chat_page.dart';
import 'package:chat/home/main/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ProfilePage extends StatefulWidget {
   final UserModel userModel;
   final User firebaseUser;

   ProfilePage({super.key,required this.userModel,required this.firebaseUser});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Uint8List? _image;
  final Auth _auth = Auth();
  bool isLoading = false;
  bool isExist = false;
  final nameController = TextEditingController();
  uploadData () async
  {
    try {
      UploadTask uploadTask = FirebaseStorage.instance.ref("profilePictures").child(widget.userModel.uid.toString()).putData(_image!);
      TaskSnapshot snapshot = await uploadTask;
      String? url = await snapshot.ref.getDownloadURL();
      String? fullName = nameController.text.trim();
      widget.userModel.profileName = fullName;
      widget.userModel.profileImage = url;
      await FirebaseFirestore.instance.collection("User-details").doc(widget.userModel.uid).set(widget.userModel.toMap());
      return true;
    } catch (error)
    {
      print(error.toString());
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: isLoading? const Center(child: CircularProgressIndicator(),) :SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 100,),
            CupertinoButton(
              onPressed: () {
                selectPictureOption();
                // pickImage(ImageSource.gallery);
              }, // to be implemented
              child: (_image!=null )? CircleAvatar(
                radius: 40,
                  backgroundImage: MemoryImage(_image!),)
                  :
              CircleAvatar(
                backgroundColor: Colors.blue.withOpacity(.8),
                radius: 40,
                child: const Icon(Icons.add_a_photo_outlined,size: 45,),
              ),
            ),
            const SizedBox(height: 50,),
            Container(
              height: MediaQuery.of(context).size.height/14,
              width: MediaQuery.of(context).size.width-50 ,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(.85),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: nameController,
                onChanged: (value)=> doesExist(value),
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: Colors.white.withOpacity(.8)
                ),
                decoration: InputDecoration(
                    hintText: 'Profile name',
                    hintStyle: GoogleFonts.roboto(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: Colors.white.withOpacity(.8)
                    ),
                    prefixIcon: const Icon(Icons.account_circle,size: 27,),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15)
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(right: 110),
              child: Text("Name already exists",style: GoogleFonts.roboto(
                fontWeight: FontWeight.w400,
                color: isExist? Colors.red.withOpacity(.8) : Colors.white,
                fontSize: 15
              ),),
            ),
            const SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.only(left: 180),
              child: IconButton(onPressed: () async {
                try
                    {
                      setState(() {
                        isLoading = true;
                      });
                      bool user;
                      if (!isExist) {
                         user =  await uploadData();
                      }
                      else
                        {
                          user = false;
                        }
                       await Future.delayed(const Duration(seconds: 2));
                       if (user)
                         {
                           setState(() {
                             isLoading = false;
                           });
                           Navigator.push(context,MaterialPageRoute(builder: (context)=> chatPage(userModel:widget.userModel ,firebaseUser: widget.firebaseUser ,)));
                         }
                       else
                         {
                           setState(() {
                             isLoading = false;
                           });
                           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Something went wrong")));
                         }
                    }
                    catch (error)
                {
                  print(error.toString());
                  setState(() {
                    isLoading = false;
                  });
                }
              }, icon: const Icon(Icons.arrow_forward,size: 30,)),
            )
          ],
        ),
      ),
    );
  }
  doesExist (String value) async
  {
    try
    {
      final bool? val = await _auth.findProfile(value);
      if (val!=null && val)
      {
        setState(() {
          isExist = true;
        });
      }
      else if (val!=null && !val)
      {
        setState(() {
          isExist = false;
        });
      }
    } catch (error)
    {
      print(error.toString());
    }
  }
  pickImage (ImageSource source) async
  {
    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: source);
    if (image!=null)
    {
      final byte = await image.readAsBytes();
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        _image = byte;
      });
    }
    else
    {
      return null;
    }
  }
  void selectPictureOption ()
  {
    showDialog(context: context, builder: (context)=>AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0)
      ),
      title:  Center(
        child: Text("Upload profile picture",
        style: GoogleFonts.roboto(fontSize: 20),),
      ),
      content:  Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo),
            onTap:()=> {
              Navigator.pop(context),
              pickImage(ImageSource.gallery)
            },
            title: const Text("Select from Gallery"),
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            onTap: ()=>{
              Navigator.pop(context),
              pickImage(ImageSource.camera)
            },
            title: const Text("Select from Camera"),
          )
        ],
      ),
    ));
  }
}
