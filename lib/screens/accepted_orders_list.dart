import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hunarmand_app/screens/pics_desc_screen.dart';

import 'accepted_order_detail.dart';


class AcceptedOrderList extends StatefulWidget {
  const AcceptedOrderList({Key? key}) : super(key: key);

  @override
  State<AcceptedOrderList> createState() => _AcceptedOrderListState();
}

class _AcceptedOrderListState extends State<AcceptedOrderList> {

  final db = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser;
  bool loadData = false;
  final list1 = [];
  final list2 = [];

  void getUserUid()async{

    await db.collection("acceptedOrder").where('workerUid', isEqualTo: uid!.uid).get().then((QuerySnapshot snapshot){

      List<QueryDocumentSnapshot> docsData = snapshot.docs;
      final d = docsData.length;

      print(d);
      for(int i=0; i < d; i++)
      {
        list2.add(docsData[i]['uid']);
        getDataFromFirestore(docsData[i]['clientUid']);
      }
    });
  }


  getDataFromFirestore(String documentId)async
  {
    await db.collection("client").doc(documentId).get().then((snapshot){
      final data = snapshot.data() as Map<String, dynamic>;
      list1.add(data);
    });
    setState(() {
      loadData = true;
    });
  }


  @override
  void initState()
  {
    // TODO: implement initState
    super.initState();
    list1.clear();
    list2.clear();
    getUserUid();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Accepted Orders"),
      ),

      body:loadData ?  ListView.builder(
          itemCount: list1!.length,
          itemBuilder: (context, index){
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage('assets/images/dummy.jpg'),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.only(left:0,top: 10),
                        child: Text(list1[index]['firstName']),
                      ),
                      subtitle: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.call,size: 20,),
                              SizedBox(width: 10,),
                              Text(list1[index]['contact']),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.home,size: 20,),
                              SizedBox(width: 10,),
                              Text(list1[index]['city'])
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              OutlinedButton(onPressed: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                  return AcceptOrderDetail(uid: list2[index], fcmToken: list1[0]['fcmToken'],);
                                }));


                              }, child: Text('View Detailss',textAlign: TextAlign.justify,)),
                              ElevatedButton(onPressed: (){}, child: Text('Call'))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }) : Center(child: CircularProgressIndicator(),),
    );
  }
}
