


import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hunarmand_app/screens/worker_request_screen.dart';

import '../models/client_model.dart';
import '../models/worker_model.dart';
import 'home_screen.dart';
import 'login_screen.dart';



class AuthUser {

  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;


  void showToast(String msg)
  {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.black,
      gravity: ToastGravity.BOTTOM,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  Future<void> createAccount(
      String email,
      String password,
      String firstName,
      String cnic,
      String lastName,
      BuildContext context,
      String city,
      String contact,
      String role,
      String skill,
      File imageUrl,
      String  bio,
      String hourlyPrice
      )async
  {
    Size size = MediaQuery.of(context).size;
    try
    {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context)
          {
            return AlertDialog(
              content: Container(
                width: size.width * 0.8,
                height: size.height * 0.05,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Loading...", style: TextStyle(fontSize: 20, color: Colors.black),),
                    SizedBox(width: 20.0,),
                    CircularProgressIndicator(color: Colors.black,),
                  ],
                ),
              ),
            );
          }
      );
      final result = await auth.createUserWithEmailAndPassword(email: email, password: password);

      if(role == 'Client')
        {

          final ref =  storage.ref().child("profile images").child(result.user!.uid);

          UploadTask task =  ref.putFile(imageUrl);
          TaskSnapshot snap = await task;


          final url = await snap.ref.getDownloadURL();

          ClientModel userData = ClientModel(
            email: email,
            password: password ,
            firstName: firstName,
            lastName: lastName,
            uid: result.user!.uid,
            city: city,
            contact: contact,
            cnic: cnic,
            role: role,
            imageUrl: url,
          );

            db.collection('client').doc(result.user!.uid).set(userData.toJson());
            Navigator.pop(context);
            showToast("Account created");
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));

        }
      else {

        final ref =  storage.ref().child("profile images").child(result.user!.uid);

        UploadTask task =  ref.putFile(imageUrl);
        TaskSnapshot snap = await task;


        final url = await snap.ref.getDownloadURL();



        WorkerModel userData = WorkerModel(
          email: email,
          password: password ,
          firstName: firstName,
          lastName: lastName,
          uid: result.user!.uid,
          city: city,
          contact: contact,
          cnic: cnic,
          skill: skill,
          role: role,
          imageUrl: url,
          bio: bio,
          hourlyPrice: hourlyPrice,
          rating: "0.0",
          projects: "0.0",
        );

          db.collection('workers').doc(result.user!.uid).set(userData.toJson()).then((value){
            Navigator.pop(context);
            showToast("Account created");
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
          }).onError((error, stackTrace){
            showToast("Error");
          });

      }
    }
    catch(error)
    {
      Navigator.of(context).pop();
      showToast(error.toString());
    }
  }

  Future<void> loginUser(String email, String password, BuildContext context)async
  {
    Size size = MediaQuery.of(context).size;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context)
        {
          return AlertDialog(
            content: Container(
              width: size.width * 0.8,
              height: size.height * 0.05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Loading...", style: TextStyle(fontSize: 20, color: Colors.black),),
                  SizedBox(width: 20.0,),
                  CircularProgressIndicator(color: Colors.black,),
                ],
              ),
            ),
          );
        }
    );
    try
    {

      final result = await auth.signInWithEmailAndPassword(email: email, password: password);
      final worker =await db.collection("workers").doc(result.user!.uid).get();
      final client =await db.collection("client").doc(result.user!.uid).get();
      final bool workerExist = worker.exists;
      final bool clientExist = client.exists;

      if(workerExist)
      {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => WorkerRequestScreen()));
      }
      else if(clientExist)
      {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
      }

    }
    catch(err)
    {
      Navigator.of(context).pop();
      showToast(err.toString());
    }
  }

  Future<void> signOut(BuildContext context)async
  {
    Size size = MediaQuery.of(context).size;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context)
        {
          return AlertDialog(
            actions: [
              ElevatedButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("Cancel")),
              ElevatedButton(onPressed: (){
                auth.signOut();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
              }, child: Text("yes")),
            ],
            content: Container(
              width: size.width * 0.8,
              height: size.height * 0.05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Are you sure to logout?", style: TextStyle(fontSize: 20, color: Colors.black),),
                ],
              ),
            ),
          );
        }
    );

  }


}