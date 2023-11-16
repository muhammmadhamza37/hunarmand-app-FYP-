import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'home_screen.dart';


class ReviewScreen extends StatefulWidget {
  const ReviewScreen({Key? key, required this.workerUid}) : super(key: key);

  final workerUid;
  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {

  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  final reviewController = TextEditingController();
  final key = GlobalKey<FormState>();


  submit()async{

    final nameData = await FirebaseFirestore.instance.collection("client").doc(auth.currentUser!.uid).get();
    final firstName = (nameData.data() as Map<String, dynamic>)['firstName'];
    final lastName = (nameData.data() as Map<String, dynamic>)['lastName'];

    DateTime now =  DateTime.now();
    final date = "${now.year.toString()}/${now.month.toString()}/${now.day.toString()}";


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

    await db.collection("reviews").add({
      'client_uid' : auth.currentUser!.uid,
      'worker_uid' : widget.workerUid,
      'rating' : rating.toString(),
      'name' : firstName + " " + lastName,
      'review' : reviewController.text.toString(),
      "time" : date.toString(),
    }).then((value){
      db.collection("workers").doc(widget.workerUid).update({
        'rating' : rating.toString(),
      });
      reviewController.clear();
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Successfully Submitted");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    });


  }


  var rating = 3.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reviews"),
        centerTitle: true,
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Form(
          key: key,
          child: Column(
            children: [
            RatingBar.builder(
            initialRating: rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              this.rating = rating;
            },
          ),


              TextFormField(
                maxLines: 5,
                controller: reviewController,
                validator: (value){
                  if(value!.isEmpty)
                    {
                      return "* required";
                    }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Leave a comment",
                ),
              ),


              ElevatedButton(
                  onPressed: (){
                    if(key.currentState!.validate())
                      {
                        submit();
                      }
                  },
                  child: Text("Submit")
              ),

            ],
          ),
        ),
      ),
    );
  }
}
