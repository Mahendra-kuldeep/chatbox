import 'package:chatbox/Models/firebaseHelper.dart';
import 'package:chatbox/Models/userModel.dart';
import 'package:chatbox/Screens/homeapage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Screens/LoginPage.dart';
import 'Screens/completeProfile.dart';
import 'Screens/signUpPage.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  User? currentUser = FirebaseAuth.instance.currentUser;
  if(currentUser!=null){
    UserModel? thisUserModel= await firebaseHelper.getUserModelId(currentUser.uid);
    if(thisUserModel!=null){
      runApp(MyAppLoggedIn(userModel: thisUserModel,firebaseUser: currentUser,));
    }
    else{
      runApp(MyApp());
    }
  }
  else{
    runApp(MyApp());
  }

}


//not logged in
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      home: LogInPage(),
    );
  }
}

//already logged in
class MyAppLoggedIn extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  const MyAppLoggedIn({super.key, required this.userModel, required this.firebaseUser});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      home: HomePage(userModel: userModel, firebaseUser: firebaseUser),
    );
  }
}

