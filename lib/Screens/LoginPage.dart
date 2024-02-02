import 'dart:developer';

import 'package:chatbox/Models/userModel.dart';
import 'package:chatbox/Screens/homeapage.dart';
import 'package:chatbox/Screens/signUpPage.dart';
import 'package:chatbox/Widgets/uiHelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  validateLoginFields(){
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if(email=="" && password==""){
      showAdaptiveDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text("Please enter required fields"),
          actions: [
            TextButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text("OK",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),))
          ],
        );
      });
    }
    else{
      Login(email,password);
    }
  }
  Login(String email ,String password)async{
    UserCredential? userCredential;
    try{
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    }
    on FirebaseAuthException catch(ex){
      showAdaptiveDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text(ex.code.toString()),
          actions: [
            TextButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text("OK",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),))
          ],
        );
      });
    }
    if(userCredential!=null){
      String uid = userCredential.user!.uid;
      DocumentSnapshot userData = await FirebaseFirestore.instance.collection("Users").doc(uid).get();
      UserModel userModel = UserModel.fromMap(userData.data() as Map<String,dynamic>);
      log("LogIn successful");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage(userModel: userModel!, firebaseUser: userCredential!.user!)));
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
                        const Text("LOG-IN",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                        SizedBox(height: 15,),
                        const SizedBox(height: 20,),
                        Uihelper().authTf(emailController, "Enter Email", Icons.email, false),
                        SizedBox(height: 15,),
                        Uihelper().authTf(passwordController, "Password", Icons.password, true),
                        SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(onPressed: (){
                              validateLoginFields();
                              Login(emailController.text.toString(), passwordController.text.toString());

                            },style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                                child: Text("LOG-IN",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),)
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("don't have any account?",style: TextStyle(fontWeight: FontWeight.bold),),
                            TextButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpPage()));
                            }, child: Text("SIGN-UP",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),)),
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
