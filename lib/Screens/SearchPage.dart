import 'package:chatbox/Models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const SearchPage({super.key, required this.userModel, required this.firebaseUser});


  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Search User",style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              padding:const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                          labelText: "Enter Email"
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Container(
                    height: 50,
                    width: 160,
                    child: ElevatedButton(onPressed: (){
                      setState(() {});
                    },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                        ),
                        child: Text("Search",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)),
                  ),
                  SizedBox(height: 20,),
                  StreamBuilder(stream: FirebaseFirestore.instance.collection("Users").where("email",isEqualTo: searchController.text).snapshots(),
                      builder: (context,snapshot){
                    if(snapshot.connectionState==ConnectionState.active){
                      if(snapshot.hasData){
                        QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;
                       if(dataSnapshot.docs.length>0){
                         Map<String,dynamic>userMap = dataSnapshot.docs[0].data() as Map<String,dynamic>;
                         UserModel searchedUser = UserModel.fromMap(userMap);
                         return ListTile(
                           title: Text(searchedUser.fullname!),
                           subtitle: Text(searchedUser.email!),
                         );
                       }
                       else{
                        return const Text("Note result found");
                       }
                      }
                      else if(snapshot.hasError){
                      return const Text("an error occured!");
                      }
                      else{
                      return const Text("Note result found");
                      }
                    }
                    else{
                      return CircularProgressIndicator();
                    }
                      }
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}
