import 'dart:developer';
import 'dart:io';
import 'package:chatbox/Models/userModel.dart';
import 'package:chatbox/Screens/homeapage.dart';
import 'package:chatbox/Widgets/uiHelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class completeProfile extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const completeProfile({super.key,required this.userModel,required this.firebaseUser});

  @override
  State<completeProfile> createState() => _completeProfileState();
}

class _completeProfileState extends State<completeProfile> {
  TextEditingController nameController= TextEditingController();
  File? pickedImageFile;

  showImageOption(){
    return showAdaptiveDialog(context: context, builder: (context){
      return AlertDialog(
        title:const Text("Upload Profile Picture",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap:(){
                selectImage(ImageSource.camera);
                Navigator.of(context).pop();
              } ,
              leading: Icon(Icons.camera_alt),
              title: Text("Camara",style:TextStyle(fontWeight: FontWeight.bold),),
            ),
            ListTile(
              onTap: (){
                selectImage(ImageSource.gallery);
                Navigator.of(context).pop();
              },
              leading: Icon(Icons.photo),
              title: Text("Gallery",style:TextStyle(fontWeight: FontWeight.bold),),
            )
          ],
        ),
      );
    });
  }

  //check user input is empty or not
  checkValues(){
    final fullName = nameController.text.trim();
    if(fullName=="" && pickedImageFile==null){
      return showAdaptiveDialog(context: context, builder: (context){
        return AlertDialog(
          content:const  Text("Please enter required fields"),
          actions: [
            TextButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text("OK",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),))
          ],
        );
      });
    }
    else{
      uploadData();
    }
  }
  //uplaod data on user id on cloud storage
  uploadData()async{
    UploadTask uploadTask = FirebaseStorage.instance.ref("UserProfilePic").child(widget.userModel.uid.toString()).putFile(pickedImageFile!);
    TaskSnapshot taskSnapshot = await uploadTask;//give url of image
    String? imageurl = await taskSnapshot.ref.getDownloadURL(); //store image url by taskSnapshot
    String? fullname =nameController.text.trim();
    widget.userModel.fullname = fullname;
    widget.userModel.profilepic=imageurl;
    await FirebaseFirestore.instance.collection("Users").doc(widget.userModel.uid).set(
      widget.userModel.toMap(),
    ).then((confirm){
      log("data uploaded");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Data successfully uploaded"),duration: Duration(seconds: 2),),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage(userModel: widget.userModel,firebaseUser: widget.firebaseUser,)));
    });
  }

  selectImage(ImageSource imageSource)async{
    try{
      final photo = await ImagePicker().pickImage(source: imageSource);
      if(photo==null)return;
      final tempImage = File(photo.path);
      setState(() {
        pickedImageFile=tempImage;
      });
    }
    catch(ex){
      log(ex.toString());
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        title: const Text("Complete your Profile",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.deepPurpleAccent,
          centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Container(
              height: 450,
              width: 380,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      showImageOption();
                    },
                    child: pickedImageFile!=null?
                    CircleAvatar(
                      radius: 70,
                      backgroundImage: FileImage(pickedImageFile!),
                      // child: Icon(Icons.person,size: 50,),
                    ):CircleAvatar(
                      radius: 70,
                      child: Icon(Icons.person),
                    )
                  ),
                  const SizedBox(height: 25,),
                  Uihelper().noborderTf(nameController, "Enter Name", Icons.drive_file_rename_outline),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Container(

                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(onPressed: (){
                        checkValues();
                      }, style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20)))
                          ,child: Text("SUBMIT",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
