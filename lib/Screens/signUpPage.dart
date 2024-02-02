import 'dart:developer';
import 'package:chatbox/Models/userModel.dart';
import 'package:chatbox/Screens/LoginPage.dart';
import 'package:chatbox/Screens/completeProfile.dart';
import 'package:chatbox/Screens/homeapage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Widgets/uiHelper.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController =TextEditingController();
  TextEditingController confirmpasswordController =TextEditingController();

  validateSignUpFields(){
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String cpassword = confirmpasswordController.text.trim();
    if(email=="" && password=="" && cpassword==""){
      showAdaptiveDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text("Please fill required fields"),
          actions: [
            TextButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text("OK",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),))
          ],
        );
      });
    }
    else if(password!=cpassword){
      showAdaptiveDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text("Your confirm password note match to password field"),
          actions: [
            TextButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text("OK",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),))
          ],
        );
      });
    }
    else{
      log("User signUP successfullly");
    }
  }

  SignPU(String email ,String password)async{
    UserCredential? userCredential;
    try{
      userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    }
    on FirebaseAuthException catch(ex){
      showAdaptiveDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text(ex.code.toString()),
          actions: [
            TextButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: const
            Text("OK",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),))
          ],
        );
      });
    }
    if(userCredential !=null){
      String uid = userCredential.user!.uid;
      UserModel newUser = UserModel(
        uid: uid,
        email: email,
        fullname: "",
        profilepic: ""
      );
      await FirebaseFirestore.instance.collection("Users").doc(uid).set(newUser.toMap()).then((user){
        log("User created successful");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>completeProfile(userModel: newUser, firebaseUser: userCredential!.user!)));
      });
    }
}
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          // alignment: Alignment.center,
          children: [
            Container(
                height: double.infinity,
                width: double.infinity,
                decoration:const BoxDecoration(
                    color: Colors.grey
                )
            ),
            Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(MediaQuery.of(context).size.width, 115)),
                  color: Colors.deepPurple
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 100,horizontal: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    height: 480,
                    width: 380,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("SIGNUP",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                        const SizedBox(height: 15,),
                        Uihelper().authTf(emailController, "Enter Email", Icons.email, false),
                        const SizedBox(height: 15,),
                        Uihelper().authTf(passwordController, "Password", Icons.password, true),
                        const SizedBox(height: 15,),
                        Uihelper().authTf(confirmpasswordController, "Confirm Password", Icons.password, true),
                        const SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(onPressed: (){
                              validateSignUpFields();
                              SignPU(emailController.text.toString(), passwordController.text.toString());
                            },style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                                child:const Text("SING-UP",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),)
                            ),
                          ),
                        ),
                       const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("already have any account?",style: TextStyle(fontWeight: FontWeight.bold),),
                            TextButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>LogInPage()));
                            }, child: Text("LOG-IN",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),)),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
