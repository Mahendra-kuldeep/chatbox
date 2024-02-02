import 'package:chatbox/Models/userModel.dart';
import 'package:chatbox/Screens/SearchPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const HomePage({super.key, required this.userModel,required this.firebaseUser});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HomePage",style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold,),),
        actions: [
          IconButton(onPressed: (){
            logOut();
          }, icon: Icon(Icons.logout))
        ],
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: SafeArea(
          child:Container(

          )
      ),
      floatingActionButton:FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchPage(userModel: widget.userModel, firebaseUser: widget.firebaseUser)));
      },child:Icon(Icons.search),),
    );
  }
  logOut(){
    FirebaseAuth.instance.signOut();
  }
}
