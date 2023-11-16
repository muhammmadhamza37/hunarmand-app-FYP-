import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hunarmand_app/screens/pics_desc_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../NotificationServices/notification_services.dart';
import 'accepted_orders_list.dart';
import 'auth.dart';
class WorkerRequestScreen extends StatefulWidget {
  const WorkerRequestScreen({Key? key}) : super(key: key);

  @override
  State<WorkerRequestScreen> createState() => _WorkerRequestScreenState();
}

class _WorkerRequestScreenState extends State<WorkerRequestScreen> {
  final firebaseAuth = FirebaseAuth.instance;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final auth = AuthUser();
  final uid = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  NotificationServices services = NotificationServices();

  bool loadData = false;
  final list = <String>[];

  final list1 = [];
  final orderUidList = [];

  saveToken() async {
    String? token = await messaging.getToken();
    await db.collection("workers").doc(uid!.uid).update({
      "fcmToken": token.toString(),
    }).then((value) => print("success"));
  }

  void getUserUid() async {
    await db
        .collection("orders")
        .where('worker-uid', isEqualTo: uid!.uid)
        .get()
        .then((QuerySnapshot snapshot) {
      List<QueryDocumentSnapshot> docsData = snapshot.docs;
      final d = docsData.length;

      for (int i = 0; i < d; i++) {
        orderUidList.add(docsData[i]['uid'].toString());
        getDataFromFirestore(docsData[i]['client_uid']);
      }
    });
  }

  getDataFromFirestore(String documentId) async {
    final record =
        await db.collection("client").doc(documentId).get().then((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>;
      list1.add(data);
    });

    setState(() {
      loadData = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    list1.clear();
    getUserUid();
    services.requestNotificationPermission();
    services.firebaseInit();
    saveToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Requests'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AcceptedOrderList()));
              },
              icon: Icon(Icons.receipt)),
          IconButton(
              onPressed: () {
                auth.signOut(context);
              },
              icon: Icon(Icons.login)),
        ],
      ),

      body: loadData
          ? ListView.builder(
              itemCount: list1!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(list1[index]['imgUrl']),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(left: 0, top: 10),
                            child: Text(list1[index]['firstName']),
                          ),
                          subtitle: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.call,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  // Text(list1[index]['contact']),
                                  Text('+923409244987'),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.home,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(list1[index]['city'])
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  OutlinedButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return PicsDescScreen(
                                            uid: orderUidList[index],
                                          );
                                        }));
                                      },
                                      child: const Text(
                                        'View Details',
                                        textAlign: TextAlign.justify,
                                      )),
                                  ElevatedButton(
                                      onPressed: () async {
                                        final call =
                                            Uri.parse('tel:+92 3409244987');
                                        if (await canLaunchUrl(call)) {
                                          launchUrl(call);
                                        } else {
                                          throw 'Could not launch $call';
                                        }
                                      },
                                      child: Text('Call')),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              })
          : const Center(
              child: CircularProgressIndicator(),
            ),

      // body: StreamBuilder(
      //   stream: FirebaseFirestore.instance.collection('client').snapshots(),
      //   builder: (BuildContext context,  snapshot){
      //
      //     if(snapshot.hasData)
      //       {
      //
      //         final data = snapshot.data!;
      //         List<QueryDocumentSnapshot> docsData = data.docs;
      //
      //         for(int i = 0; i < docsData.length; i++)
      //           {
      //             if(docsData[i]['uid'] == uid!.uid)
      //               {
      //                 setState((){
      //                   filterData = docsData;
      //                 });
      //               }
      //           }
      //
      //         return ListView.builder(
      //             itemCount: filterData!.length,
      //             itemBuilder: (context, index){
      //               return Padding(
      //                 padding: const EdgeInsets.all(8.0),
      //                 child: Container(
      //                   height: 120,
      //                   decoration: BoxDecoration(
      //                       borderRadius: BorderRadius.circular(15),
      //                       color: Colors.grey.shade200,
      //                       border: Border.all(color: Colors.grey.shade200),
      //                       boxShadow:[
      //                         BoxShadow(
      //                             color: Colors.grey,
      //                             blurRadius: 25,
      //                             spreadRadius: 1,
      //                             offset: Offset(2, 2))
      //                       ]
      //                   ),
      //                   child:ListTile(
      //                     leading: const CircleAvatar(
      //                       radius: 25,
      //                       backgroundImage: AssetImage('assets/images/dummy.jpg'),
      //                     ),
      //                     title: Padding(
      //                       padding: const EdgeInsets.only(left:0,top: 10),
      //                       child: Text('Muhammad Hamza'),
      //                     ),
      //                     trailing: Text('03:00 PM'),
      //                     subtitle: TextButton(
      //                         onPressed: (){
      //                           // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      //                           //   return PicsDescScreen();
      //                           // }));
      //                         }, child: Padding(
      //                       padding: const EdgeInsets.only(left: 0,top: 0),
      //                       child: Text('see more',textAlign: TextAlign.justify,),
      //                     )),
      //                   ) ,
      //                 ),
      //               );
      //             });
      //       }
      //     else
      //     {
      //       return Center(child: Text("hii"),);
      //     }
      //
      //     // if(!snapshot.hasData)
      //     //   {
      //     //     return const Center(child: CircularProgressIndicator(),);
      //     //   }
      //     // else
      //     //   {
      //     //     final docsData = snapshot.data;
      //     //     List<QueryDocumentSnapshot> data = docsData!.docs;
      //     //
      //     //     return ListView.builder(
      //     //         itemCount: data.length,
      //     //         itemBuilder: (context, index){
      //     //           return Padding(
      //     //             padding: const EdgeInsets.all(8.0),
      //     //             child: Container(
      //     //               height: 120,
      //     //               decoration: BoxDecoration(
      //     //                   borderRadius: BorderRadius.circular(15),
      //     //                   color: Colors.grey.shade200,
      //     //                   border: Border.all(color: Colors.grey.shade200),
      //     //                   boxShadow:[
      //     //                     BoxShadow(
      //     //                         color: Colors.grey,
      //     //                         blurRadius: 25,
      //     //                         spreadRadius: 1,
      //     //                         offset: Offset(2, 2))
      //     //                   ]
      //     //               ),
      //     //               child:ListTile(
      //     //                 leading: const CircleAvatar(
      //     //                   radius: 25,
      //     //                   backgroundImage: AssetImage('assets/images/dummy.jpg'),
      //     //                 ),
      //     //                 title: Padding(
      //     //                   padding: const EdgeInsets.only(left:0,top: 10),
      //     //                   child: Text('Muhammad Hamza'),
      //     //                 ),
      //     //                 trailing: Text('03:00 PM'),
      //     //                 subtitle: TextButton(
      //     //                     onPressed: (){
      //     //                   // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      //     //                   //   return PicsDescScreen();
      //     //                   // }));
      //     //                 }, child: Padding(
      //     //                   padding: const EdgeInsets.only(left: 0,top: 0),
      //     //                   child: Text('see more',textAlign: TextAlign.justify,),
      //     //                 )),
      //     //               ) ,
      //     //             ),
      //     //           );
      //     //         });
      //     //   }
      //
      //   },
      // ),
    );
  }
}
