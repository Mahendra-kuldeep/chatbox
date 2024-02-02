import 'package:chatbox/Models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class firebaseHelper{
  static Future<UserModel?>getUserModelId(String uid)async{
    UserModel? userModel;
    DocumentSnapshot docSnap = await  FirebaseFirestore.instance.collection("Users").doc(uid).get();
    if(docSnap.data()!=null)
      {
        userModel = UserModel.fromMap(docSnap.data() as Map<String,dynamic>);
      }
    return userModel;
  }

}