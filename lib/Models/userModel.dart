class UserModel{
  String? uid;
  String? fullname;
  String? email;
  String? profilepic;

  UserModel({this.uid,this.fullname,this.email,this.profilepic});

  UserModel.fromMap(Map<String,dynamic>map){
    uid = map["uid"];
    fullname = map["fullName"];
    email = map["email"];
    profilepic = map["profilePic"];
  }

  Map<String,dynamic>toMap(){
    return{
      "uid":uid,
      "fullname":fullname,
      "email":email,
      "profilepic":profilepic
    };
  }
}