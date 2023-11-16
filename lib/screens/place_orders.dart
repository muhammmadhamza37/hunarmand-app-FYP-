import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlaceOrders extends StatefulWidget {
  const PlaceOrders({Key? key}) : super(key: key);

  @override
  State<PlaceOrders> createState() => _PlaceOrdersState();
}

class _PlaceOrdersState extends State<PlaceOrders> {
  final auth = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  var list1 = [];
  bool loadData = true;

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Place Orders"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("orders").where("client_uid", isEqualTo: auth!.uid).snapshots(),
        builder: (context, snapshot)
        {
          if(snapshot.hasData)
          {
            final da = snapshot.data;
            List<QueryDocumentSnapshot> dat = da!.docs;

            return ListView.builder(
                itemCount: dat.length,
                itemBuilder: (context, index){
                  //return Center(child: Text(dat[index]['description']),);
                  return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                          [
                            ClipRRect(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
                              child: Image(
                                image: NetworkImage(dat[index]['imgUrl'],),
                                fit: BoxFit.fitWidth,
                              ),
                            ),

                            SizedBox(
                              width: double.infinity,
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Text("Description", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),

                                      Text(
                                        dat[index]['description'],
                                        style: TextStyle(fontSize: 20),
                                      ),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Date", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),

                                              Text(
                                                dat[index]['date'],
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ],
                                          ),

                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Time", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),

                                              Text(
                                                dat[index]['time'],
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ),


                          ],
                        ),
                      )

                  );
                }
            );
          }
          else
          {
            return Center(child: Text("No data", style: TextStyle(fontWeight: FontWeight.bold, fontSize: size.width * 0.07),),);
          }
        },
      ),
    );
  }
}
