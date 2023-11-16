import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hunarmand_app/screens/worker_request_screen.dart';

import 'home_screen.dart';
import 'login_screen.dart';



class WlScreen extends StatefulWidget {
  const WlScreen({Key? key}) : super(key: key);

  @override
  State<WlScreen> createState() => _WlScreenState();
}

class _WlScreenState extends State<WlScreen> {

  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  bool workerExist = false;
  bool clientExist = false;
  bool loading = false;
  getUser()async
  {
    final worker =await db.collection("workers").doc(auth.currentUser?.uid).get();
    final client =await db.collection("client").doc(auth.currentUser?.uid).get();
    bool isWorker = worker.exists;
    bool isClient = client.exists;

    if(isWorker)
    {
      setState(() {
        workerExist = true;
      });
    }
    else if(isClient)
    {
      setState(() {
        clientExist = true;
      });
    }

    Future.delayed(Duration(seconds: 3));


    if(FirebaseAuth.instance.currentUser?.uid == null)
      {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    else if(workerExist)
      {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const WorkerRequestScreen()));
      }
    else if(clientExist)
    {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  HomeScreen()));
    }


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }


  @override
  Widget build(BuildContext context) {


    return Center(child: Image(
      image: AssetImage("assets/images/img1.png"),
    ),);

  }
}
