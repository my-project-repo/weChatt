class UserModel
{
  String? uid;
  String? email;
  String? profileName;
  String? profileImage;
  UserModel ({this.uid,this.email,this.profileName,this.profileImage});
  UserModel.fromMap(Map<String,dynamic> map)
  {
    uid = map["uid"];
    email = map["email"];
    profileName = map["profileName"];
    profileImage = map["profileImage"];
  }
  Map<String,dynamic> toMap ()
  {
    return
        {
          "uid" : uid,
          "email" : email,
          "profileName" : profileName,
          "profileImage" : profileImage,
        };
  }
}