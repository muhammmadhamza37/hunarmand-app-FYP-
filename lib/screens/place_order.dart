import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hunarmand_app/models/worker_model.dart';
import 'package:image_picker/image_picker.dart';

import 'package:weekly_date_picker/weekly_date_picker.dart';

import 'add_location.dart';



class PlaceOrder extends StatefulWidget {

   PlaceOrder({Key? key, this.uid, this.fcmToken}) : super(key: key);

  String? uid;
  String? fcmToken;

  @override
  State<PlaceOrder> createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {

  DateTime _selectedDay = DateTime.now();

  String address = "null";
  String autocompletePlace = "null";

  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;


  String selectedDate = '${DateTime.now().day.toString()} ${DateTime.now().month.toString()} ${DateTime.now().year.toString()}';
  String? hour;
  String selectedTime = '8 : 00';
  bool timeSelect = false;
  bool imagePicked = false;

  bool imageLoading = false;

  final descController = TextEditingController();
  final key = GlobalKey<FormState>();
  File? fileImage;

  bool firstContainer = true;
  bool secondContainer = false;
  bool thirdContainer = false;
  bool fourthContainer = false;
  bool fiveContainer = false;
  bool sixContainer = false;
  bool seventhContainer = false;
  bool eightContainer = false;
  bool ninthContainer = false;

  void showMessage(String msg)async{
    Fluttertoast.showToast(msg: msg);
  }

  pickTime()async{
    final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: 12, minute: 00,),
    );

    setState((){
      hour = selectedTime!.format(context);
      timeSelect = true;
    });
  }

  placeOrder()async{

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


    final number = DateTime.now().millisecondsSinceEpoch;
    final picRef = storage.ref().child("workImages").child(number.toString());

    await picRef.putFile(fileImage!);

    final imgUrl =await picRef.getDownloadURL();



    await db.collection("orders").add(
      {
        'imgUrl' : imgUrl,
        'worker-uid' : widget.uid,
        'date' : selectedDate,
        'time' : selectedTime,
        'client_uid' : auth.currentUser!.uid,
        'description' : descController.text,
        'lat' : lat,
        'lang' : lang,
      }
    ).then((value){
      db.collection("orders").doc(value.id).update({
        "uid" : value.id,
      });
      Navigator.of(context).pop();
      showMessage("Successfully created");
    });


    descController.clear();

    sendNotification();
    setState(() {
      fileImage = null;
      imagePicked = false;
    });
  }

  sendNotification()async{

    final getToken =await db.collection("workers").doc(widget.uid).get();
    final token = getToken['fcmToken'];

    Uri url = Uri.parse("https://fcm.googleapis.com/fcm/send");

    final header = {
      "Content-Type" : "application/json",
      'Authorization' : 'key=AAAA1dnX8eA:APA91bE3uTNMe6_foYrEor91SrlV0Gx_qP6Req57w985zjN3NRCg7ZXBvaW32oiYVpK7ZYbPkRizJoYWIGadxY-_WCFEZFpNubJrjtVaJ-SHb4_kc5bmuoImhJRqj1xy5eJNUBnsbca9',
    };
    final body =jsonEncode( <String, dynamic>{
      "to": "${token.toString()}",
      "notification": {
        "body": "you have new order",
        "content_available": true,
        "priority": "high",
        "title": "title",
        "channel_id" : "high_importance_channel",
      },
      "data": {
        "priority": "high",
        "user_id" : "from_user_id"
      }
    });

    try {
      final response = await http.post(url, body: body, headers: header);

      print(response.statusCode);
      print(response.body);
    }catch(e)
    {
      print(e.toString());
    }
  }

  pickeImage()async{

    final pickImage = await ImagePicker.platform.pickImage(source: ImageSource.camera);

    setState(() {
      imageLoading = true;
    });

    setState(() {
      fileImage = File(pickImage!.path);
      imagePicked = true;
    });

    await Future.delayed(Duration(seconds: 1));
    setState(() {
      imageLoading = false;
    });
  }


  @override
  Widget build(BuildContext context){

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Booking"),
        centerTitle: true,
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
            [
              Container(
                width: size.width * 1,
                height: size.height * 0.3,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: imagePicked ? imageLoading ? Center(child: CircularProgressIndicator()) : Image(image: FileImage(fileImage!),fit: BoxFit.cover) : IconButton(onPressed: (){
                    pickeImage();
                  },
                  icon: Icon(Icons.camera_alt, color: Colors.grey, size: size.width * 0.15,),
                ),
              ),

              SizedBox(
                height: size.height * 0.05,
              ),

              Text("Description", style: TextStyle(fontSize: size.height * 0.03, fontWeight: FontWeight.bold),),

              SizedBox(
                height: size.height * 0.01,
              ),

              Form(
                key: key,
                child: TextFormField(
                  validator: (value){
                    if(value!.isEmpty)
                      {
                        return "* required";
                      }
                  },
                  controller: descController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              SizedBox(
                height: size.height * 0.01,
              ),
              Text("Select Date", style: TextStyle(fontSize: size.height * 0.03, fontWeight: FontWeight.bold),),

              SizedBox(
                height: size.height * 0.009,
              ),
              WeeklyDatePicker(
                selectedDay: _selectedDay,
                changeDay: (value) => setState((){
                  _selectedDay = value;
                  selectedDate = '${value.day.toString()} ${value.month.toString()} ${value.year.toString()}';
                }),
                enableWeeknumberText: false,
                weeknumberColor: Colors.black,
                weeknumberTextColor: Colors.black,
                backgroundColor: Colors.grey.shade100,
                weekdayTextColor: Colors.black,
                digitsColor: Colors.black,
                selectedBackgroundColor: const Color(0xFF57AF87),
                weekdays: ["Mo", "Tu", "We", "Th", "Fr"],
                daysInWeek: 5,
              ),


              SizedBox(
                height: size.height * 0.02,
              ),

              Text("Select Time", style: TextStyle(fontSize: size.height * 0.03, fontWeight: FontWeight.bold),),

              SizedBox(
                height: size.height * 0.009,
              ),



              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                child: Row(
                  children:
                  [
                    InkWell(
                      onTap: (){
                        setState(() {
                          firstContainer = true;
                          secondContainer = false;
                          thirdContainer = false;
                          fourthContainer = false;
                          fiveContainer = false;
                          sixContainer = false;
                          seventhContainer = false;
                          eightContainer = false;
                          ninthContainer = false;
                          selectedTime = "9 : 00";
                        });
                      },
                      child: Container(
                        color:firstContainer ? Colors.green : Colors.grey.shade100,
                        width: size.width * 0.18,
                        height: size.height * 0.07,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("9 : 00", style: TextStyle(fontSize: size.width * 0.05),),
                            Text("AM", style: TextStyle(fontSize: size.width * 0.05),),
                          ],
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: (){
                        setState(() {
                          firstContainer = false;
                          secondContainer = true;
                          thirdContainer = false;
                          fourthContainer = false;
                          fiveContainer = false;
                          sixContainer = false;
                          seventhContainer = false;
                          eightContainer = false;
                          ninthContainer = false;
                          selectedTime = "10 : 00";
                        });
                      },
                      child: Container(
                        color:secondContainer ? Colors.green : Colors.grey.shade100,
                        width: size.width * 0.18,
                        height: size.height * 0.07,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children:
                          [
                            Text("10 : 00", style: TextStyle(fontSize: size.width * 0.05),),
                            Text("AM", style: TextStyle(fontSize: size.width * 0.05),),
                          ],
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: (){
                        setState(() {
                          firstContainer = false;
                          secondContainer = false;
                          thirdContainer = true;
                          fourthContainer = false;
                          fiveContainer = false;
                          sixContainer = false;
                          seventhContainer = false;
                          eightContainer = false;
                          ninthContainer = false;
                          selectedTime = "11 : 00";
                        });
                      },
                      child: Container(
                        color:thirdContainer ? Colors.green : Colors.grey.shade100,
                        width: size.width * 0.18,
                        height: size.height * 0.07,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("11 : 00", style: TextStyle(fontSize: size.width * 0.05),),
                            Text("AM", style: TextStyle(fontSize: size.width * 0.05),),
                          ],
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: (){
                        setState(() {
                          firstContainer = false;
                          secondContainer = false;
                          thirdContainer = false;
                          fourthContainer = true;
                          fiveContainer = false;
                          sixContainer = false;
                          seventhContainer = false;
                          eightContainer = false;
                          ninthContainer = false;
                          selectedTime = "12 : 00";
                        });
                      },
                      child: Container(
                        color:fourthContainer ? Colors.green : Colors.grey.shade100,
                        width: size.width * 0.18,
                        height: size.height * 0.07,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("12 : 00", style: TextStyle(fontSize: size.width * 0.05),),
                            Text("PM", style: TextStyle(fontSize: size.width * 0.05),),
                          ],
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: (){
                        setState(() {
                          firstContainer = false;
                          secondContainer = false;
                          thirdContainer = false;
                          fourthContainer = false;
                          fiveContainer = true;
                          sixContainer = false;
                          seventhContainer = false;
                          eightContainer = false;
                          ninthContainer = false;
                          selectedTime = "1 : 00";
                        });
                      },
                      child: Container(
                        color:fiveContainer ? Colors.green : Colors.grey.shade100,
                        width: size.width * 0.18,
                        height: size.height * 0.07,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("1 : 00", style: TextStyle(fontSize: size.width * 0.05),),
                            Text("PM", style: TextStyle(fontSize: size.width * 0.05),),
                          ],
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: (){
                        setState(() {
                          firstContainer = false;
                          secondContainer = false;
                          thirdContainer = false;
                          fourthContainer = false;
                          fiveContainer = false;
                          sixContainer = true;
                          seventhContainer = false;
                          eightContainer = false;
                          ninthContainer = false;
                          selectedTime = "2 : 00";
                        });
                      },
                      child: Container(
                        color:sixContainer ? Colors.green : Colors.grey.shade100,
                        width: size.width * 0.18,
                        height: size.height * 0.07,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("2 : 00", style: TextStyle(fontSize: size.width * 0.05),),
                            Text("PM", style: TextStyle(fontSize: size.width * 0.05),),
                          ],
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: (){
                        setState(() {
                          firstContainer = false;
                          secondContainer = false;
                          thirdContainer = false;
                          fourthContainer = false;
                          fiveContainer = false;
                          sixContainer = false;
                          seventhContainer = true;
                          eightContainer = false;
                          ninthContainer = false;
                          selectedTime = "3 : 00";
                        });
                      },
                      child: Container(
                        color:seventhContainer ? Colors.green : Colors.grey.shade100,
                        width: size.width * 0.18,
                        height: size.height * 0.07,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("3 : 00", style: TextStyle(fontSize: size.width * 0.05),),
                            Text("PM", style: TextStyle(fontSize: size.width * 0.05),),
                          ],
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: (){
                        setState(() {
                          firstContainer = false;
                          secondContainer = false;
                          thirdContainer = false;
                          fourthContainer = false;
                          fiveContainer = false;
                          sixContainer = false;
                          seventhContainer = false;
                          eightContainer = true;
                          ninthContainer = false;
                          selectedTime = "4 : 00";
                        });
                      },
                      child: Container(
                        color:eightContainer ? Colors.green : Colors.grey.shade100,
                        width: size.width * 0.18,
                        height: size.height * 0.07,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("4 : 00", style: TextStyle(fontSize: size.width * 0.05),),
                            Text("PM", style: TextStyle(fontSize: size.width * 0.05),),
                          ],
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: (){
                        setState(() {
                          firstContainer = false;
                          secondContainer = false;
                          thirdContainer = false;
                          fourthContainer = false;
                          fiveContainer = false;
                          sixContainer = false;
                          seventhContainer = false;
                          eightContainer = false;
                          ninthContainer = true;
                          selectedTime = "5 : 00";
                        });
                      },
                      child: Container(
                        color:ninthContainer ? Colors.green : Colors.grey.shade100,
                        width: size.width * 0.18,
                        height: size.height * 0.07,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("5 : 00", style: TextStyle(fontSize: size.width * 0.05),),
                            Text("PM", style: TextStyle(fontSize: size.width * 0.05),),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),


              SizedBox(
                height: size.height * 0.05,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:
                [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        minimumSize: Size(size.width * 0.3, size.height * 0.05),
                      ),
                      onPressed: ()
                      {

                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddLocation()));

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) {
                        //       return MapLocationPicker(
                        //         apiKey: "AIzaSyAnwvNqlOi62hWaoXAPWXc0VtiO3ouQ0Rc",
                        //         canPopOnNextButtonTaped: true,
                        //         currentLatLng: const LatLng(29.121599, 76.396698),
                        //         onNext: (GeocodingResult? result) {
                        //           if (result != null) {
                        //             setState(() {
                        //               address = result.formattedAddress ?? "";
                        //
                        //             });
                        //           }
                        //         },
                        //         onSuggestionSelected: (PlacesDetailsResponse? result) {
                        //           if (result != null) {
                        //             setState(() {
                        //               autocompletePlace =
                        //                   result.result.formattedAddress ?? "";
                        //             });
                        //           }
                        //         },
                        //       );
                        //     },
                        //   ),
                        // );
                      }, child: Text("Direction")),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        minimumSize: Size(size.width * 0.3, size.height * 0.05),
                      ),
                      onPressed: ()
                      {
                        if(key.currentState!.validate())
                        {
                          if(fileImage == null)
                          {
                            showMessage("Select image");
                          }
                          else
                          {
                            if(lat != "0" && lang != "0") {
                              placeOrder();
                            }
                            else
                              {
                                Fluttertoast.showToast(msg: "Select location");
                              }
                          }
                        }
                      }, child: Text("Place order")),
                ],
              ),


            ],
          ),
        ),
      ),
    );
  }
}
