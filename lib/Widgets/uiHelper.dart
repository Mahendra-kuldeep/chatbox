
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Uihelper{
  authTf(TextEditingController controller,String text , IconData iconData ,bool secure){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.withOpacity(.4)
        ),
        child: TextField(
          cursorColor: Colors.deepPurpleAccent,
          controller: controller,
          obscureText: secure,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: text,
            prefixIcon: Icon(iconData)
          ),
        ),
      ),
    );
  }
  noborderTf(TextEditingController controller,String text , IconData iconData ){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: text,
          prefixIcon: Icon(iconData),
        ),
      ),
    );
  }
}
