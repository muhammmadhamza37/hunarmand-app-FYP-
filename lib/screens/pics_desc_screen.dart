import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:hunarmand_app/screens/review_screen.dart';
import 'package:hunarmand_app/screens/worker_request_screen.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class PicsDescScreen extends StatefulWidget {
  const PicsDescScreen({Key? key, required this.uid,}) : super(key: key);

  final uid;

  @override
  State<PicsDescScreen> createState() => _PicsDescScreenState();
}

class _PicsDescScreenState extends State<PicsDescScreen> {

  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance.currentUser;
  bool dateDeleted = false;

  acceptOrder(var list)async
  {


    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Center(child: CircularProgressIndicator(),),
                )
              ],
            ),
          );
        }
    );
    await db.collection("acceptedOrder").add({
      'workerUid' : auth!.uid.toString(),
      'clientUid' : list[0]['client_uid'],
      'imgUrl' : list[0]['imgUrl'],
      'date' : list[0]['date'],
      'time' : list[0]['time'],
      "description" : list[0]['description'],
    }).then((value){
      db.collection("acceptedOrder").doc(value.id).update({
        "uid" : value.id,
      });
      sendNotification("accepted", list[0]['client_uid']);
    });

    dateDeleted = true;
    await db.collection("orders").doc(list[0]['uid']).delete().then((value){
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "success");
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => WorkerRequestScreen()));
    });

  }

  rejectOrder(var uid, var list)async
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Center(child: CircularProgressIndicator(),),
                )
              ],
            ),
          );
        }
    );
    await db.collection("orders").doc(uid).delete().then((value){
      setState(() {
        dateDeleted = true;
      });
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "success");
      sendNotification("rejected", list[0]['client_uid']);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => WorkerRequestScreen()));
    });
  }

  sendNotification(String orderMode, var uid)async{

    final getToken =await db.collection("client").doc(uid).get();
    final token = getToken['fcmToken'];

    Uri url = Uri.parse("https://fcm.googleapis.com/fcm/send");

    final header = {
      "Content-Type" : "application/json",
      'Authorization' : 'key=AAAA1dnX8eA:APA91bE3uTNMe6_foYrEor91SrlV0Gx_qP6Req57w985zjN3NRCg7ZXBvaW32oiYVpK7ZYbPkRizJoYWIGadxY-_WCFEZFpNubJrjtVaJ-SHb4_kc5bmuoImhJRqj1xy5eJNUBnsbca9',
    };
    final body =jsonEncode( <String, dynamic>{
      "to": "${token.toString()}",
      "notification": {
        "body": "Your order has been $orderMode",
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
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Client Needed Work", style: TextStyle(fontSize: size.width * 0.05),),
      ),

      body:!dateDeleted ? StreamBuilder(
        stream: FirebaseFirestore.instance.collection("orders").where("uid", isEqualTo: widget.uid).snapshots(),
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

                                Text(dat[0]['date'], style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.bold),),
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
                            acceptOrder(dat);
                          }, child: Text('Accepted')),
                          ElevatedButton(onPressed: (){
                            rejectOrder(dat[0]['uid'], dat);
                          }, child: Text('Rejected')),
                          ElevatedButton(onPressed: (){
                            installMap();
                            openMap(dat[0]['lat'], dat[0]['lang']);
                          }, child: Text('Direction'))
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
      ) : Center(child: Container(),),
    );
  }
}
