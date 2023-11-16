import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:hunarmand_app/screens/review_screen.dart';
import 'package:hunarmand_app/screens/worker_request_screen.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

import 'accepted_orders_list.dart';

class AcceptOrderDetail extends StatefulWidget {
  const AcceptOrderDetail({Key? key, required this.uid, required this.fcmToken}) : super(key: key);

  final uid;
  final fcmToken;

  @override
  State<AcceptOrderDetail> createState() => _AcceptOrderDetailState();
}

class _AcceptOrderDetailState extends State<AcceptOrderDetail> {

  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance.currentUser;


  bool deleted = false;

  delAcceptOrder(final uid, var data)async{


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

    db.collection("completedOrders").add({
      'clientUid' : data[0]['clientUid'],
      'workerUid' : data[0]['workerUid'],
      'imgUrl' : data[0]['imgUrl'],
      'date' : data[0]['date'],
      'time' : data[0]['time'],
      'description' : data[0]['description'],
    }).then((value){
      db.collection("completedOrders").doc(value.id).update({
        'uid' : value.id,
      });
    });
    setState(() {
      deleted = true;
    });
    db.collection("acceptedOrder").doc(uid).delete().then((value){
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "success");
      sendNotification();
      Get.offAll(AcceptedOrderList());
    });


  }

  sendNotification()async{

    Uri url = Uri.parse("https://fcm.googleapis.com/fcm/send");

    final header = {
      "Content-Type" : "application/json",
      'Authorization' : 'key=AAAA1dnX8eA:APA91bE3uTNMe6_foYrEor91SrlV0Gx_qP6Req57w985zjN3NRCg7ZXBvaW32oiYVpK7ZYbPkRizJoYWIGadxY-_WCFEZFpNubJrjtVaJ-SHb4_kc5bmuoImhJRqj1xy5eJNUBnsbca9',
    };
    final body =jsonEncode( <String, dynamic>{
      "to": "${widget.fcmToken.toString()}",
      "notification": {
        "body": "Your order has been completed",
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


  installMap()async{

    final List<AvailableMap> availableMaps = await MapLauncher.installedMaps;

    await availableMaps.first.showMarker(
      coords: Coords(34.03079269896966, 71.44352164978706),
      title: "Jamal gull machli ferosh",
    );


  }
  openMap(final lat, final lang)async
  {

    if(await Permission.location.status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      try {
        if (MapLauncher.isMapAvailable(MapType.google) == true) {
          await MapLauncher.launchMap(
            mapType: MapType.google,
            coords: Coords(position.latitude, position.longitude),
            title: "Nasir bagh road",
          );


          await MapLauncher.showDirections(
            mapType: MapType.google,
            destination: Coords(lat, lang),
          );
        }
      }
      catch (e) {
        print(e);
      }
    }
    else
    {
      await Permission.location.request();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.uid);
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Details", style: TextStyle(fontSize: size.width * 0.08),),
      ),

      body:!deleted ? StreamBuilder(
        stream: FirebaseFirestore.instance.collection("acceptedOrder").where("uid", isEqualTo: widget.uid).snapshots(),
        builder: (context, snapshot){




          if(snapshot.hasData)
          {
            final da = snapshot.data;
            final dat = da!.docs;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                  [
                    Container(
                      width: size.width * 1,
                      height: size.height * 0.4,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Image(image: NetworkImage(dat[0]['imgUrl']), fit: BoxFit.cover,),
                    ),

                    SizedBox(
                      height: size.height * 0.05,
                    ),

                    Text("Description", style: TextStyle(fontSize: size.width * 0.07, fontWeight: FontWeight.bold),),

                    SizedBox(
                      height: size.height * 0.01,
                    ),

                    Text(dat[0]['description'], style: TextStyle(fontSize: size.width * 0.04),),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Text("Date and Time", style: TextStyle(fontSize: size.width * 0.07, fontWeight: FontWeight.bold),),

                    SizedBox(
                      height: size.height * 0.02,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          color: Colors.grey,
                          width: size.width * 0.3,
                          padding: EdgeInsets.all(size.width * 0.02),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:
                            [
                              Icon(Icons.calendar_month, color: Colors.black,),

                              Text(dat[0]['date'], style: TextStyle(fontSize: size.width * 0.05, fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),


                        Container(
                          color: Colors.grey,
                          width: size.width * 0.3,
                          padding: EdgeInsets.all(size.width * 0.02),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:
                            [
                              Icon(Icons.watch_later, color: Colors.black,),

                              Text(dat[0]['time'], style: TextStyle(fontSize: size.width * 0.05, fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(onPressed: (){
                          delAcceptOrder(dat[0]['uid'], dat);
                        }, child: Text('Order Completed'))
                      ],
                    ),


                  ],
                ),
              ),
            );
          }
          else
          {
            return Center(child: CircularProgressIndicator(),);
          }





        },
      ) : Center(child: Text("No date found"),),
    );
  }
}
